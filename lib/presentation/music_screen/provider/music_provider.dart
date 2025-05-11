import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../config/api_config.dart';
import '../../../services/spotify_track_service.dart';

const List<String> modelNames = [
  'models/gemini-2.0-flash',
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

const String _systemPrompt = '''
You are a mindful music recommendation system focused on mental and emotional well-being. Your role is to suggest songs that support self-love, mindfulness, healing, emotional regulation, or simply uplifting energy.

Important Guidelines:
1. Only suggest music that promotes emotional support, resilience, joy, calm, confidence, or reflection.
2. Always suggest different songs and artists — avoid repeating titles across responses.
3. Include a variety of genres and styles (pop, rock, indie, R&B, lo-fi, jazz, classical, ambient, etc.).
4. Include both recent songs (from the last 5 years) and timeless classics.
5. All music must be emotionally safe and mentally supportive — avoid dark, aggressive, or triggering content.
6. For the Album Art:
   - Use Spotify's album art URLs when possible.
   - Format: https://i.scdn.co/image/[album_art_id]
   - If unavailable, use a reliable public album art URL from a trusted music source (e.g., Apple Music).
7. For the Spotify link, use the direct Spotify track URL: https://open.spotify.com/track/[track_id]
8. Each song must be completely different from previous ones, even across multiple requests.
9. Do not guess links. If a real link is unavailable, do not fabricate it.
10. Return only one song per response.

⚠️ Include ALL of the following fields in every response. Do not leave any field blank. Do not add anything extra.

Format your response exactly like this:
Title: [Song Title]  
Artist: [Artist Name]  
Album: [Album Name]  
Year: [Release Year]  
Genre: [Music Genre]  
Description: [2–3 full sentences on what the song feels like and why it supports mental or emotional health]  
Spotify: [Spotify track URL]  
Album Art: [Album art URL]

Do not include any introductions, comments, emojis, or formatting outside of the structure above.
''';

/// A provider class for the MusicScreen.
///
/// This provider manages the state of the MusicScreen, including the
/// current musicModelObj.
// ignore_for_file: must_be_immutable
class MusicProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;
  final SpotifyTrackService _spotifyService = SpotifyTrackService();

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;
  Map<String, dynamic>? _currentTrackInfo;

  MusicProvider() {
    _model = GenerativeModel(
      model: modelNames[0],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    // Send initial greeting message
    sendInitialGreeting();
  }

  Future<void> sendInitialGreeting() async {
    isLoading = true;
    notifyListeners();

    try {
      // First send the welcome message
      _addMessageAndNotify("Hit play, close your eyes 🎧. Let melodies carry you somewhere better. 🎶🎷", role: 'assistant');
      
      // Then send the music recommendation with specific format request
      final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Song Title]
Artist: [Artist Name]
Album: [Album Name]
Year: [Release Year]
Genre: [Music Genre]
Description: [Brief description in 2-3 sentences]
Why It's Uplifting: [1-2 sentences about why this song is uplifting]
Spotify: [Full Spotify URL starting with https://open.spotify.com/track/]
Album Art: [Album art URL from Spotify or reliable music service]

Suggest a completely different uplifting song than before, following this format exactly. Include a mix of recent and classic music. Make sure to use a valid Spotify track URL and album art URL.'''));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        _addMessageAndNotify(responseText, role: 'assistant');
        
        // Extract title and artist to search for the track
        final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(responseText);
        final artistMatch = RegExp(r'Artist:\s*(.*)').firstMatch(responseText);
        
        if (titleMatch != null && artistMatch != null) {
          final title = titleMatch.group(1)?.trim();
          final artist = artistMatch.group(1)?.trim();
          
          if (title != null && artist != null) {
            try {
              // Search for the track using title and artist
              final searchQuery = '$title $artist';
              _currentTrackInfo = await _spotifyService.searchTrack(searchQuery);
              notifyListeners();
            } catch (e) {
              debugPrint('Error fetching track info: $e');
            }
          }
        }
      }
    } catch (error) {
      debugPrint('Error sending initial music request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a song right now. Please try asking me again.", role: 'assistant');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _switchToNextModel() async {
    _currentModelIndex = (_currentModelIndex + 1) % modelNames.length;
    _model = GenerativeModel(
      model: modelNames[_currentModelIndex],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    debugPrint('🤖 [switchModel] Switched to model: ${modelNames[_currentModelIndex]}');
  }

  void _addMessageAndNotify(String message, {required String role}) {
    if (role == 'assistant') {
      // Filter out the "Why It's Uplifting" line from AI responses
      final filteredMessage = message.split('\n')
          .where((line) => !line.startsWith('Why It\'s Uplifting:'))
          .join('\n');
      messages.add({'role': role, 'content': filteredMessage});
    } else {
      messages.add({'role': role, 'content': message});
    }
    isLoading = false;
    notifyListeners();
    if (onMessageAdded != null) onMessageAdded!();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      _addMessageAndNotify(message, role: 'user');
      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      for (int i = 0; i < modelNames.length; i++) {
        try {
          _chat = _model.startChat(history: [
            Content.text(_systemPrompt),
            ...messages.map((msg) => Content.text(msg['content']!)),
          ]);

          final response = await _chat.sendMessage(Content.text(message));
          if (response.text != null) {
            final responseText = response.text!.trim();
            _addMessageAndNotify(responseText, role: 'assistant');
            
            // Extract title and artist to search for the track
            final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(responseText);
            final artistMatch = RegExp(r'Artist:\s*(.*)').firstMatch(responseText);
            
            if (titleMatch != null && artistMatch != null) {
              final title = titleMatch.group(1)?.trim();
              final artist = artistMatch.group(1)?.trim();
              
              if (title != null && artist != null) {
                try {
                  // Search for the track using title and artist
                  final searchQuery = '$title $artist';
                  _currentTrackInfo = await _spotifyService.searchTrack(searchQuery);
                  notifyListeners();
                } catch (e) {
                  debugPrint('Error fetching track info: $e');
                }
              }
            }
            break;
          }

          await _switchToNextModel();
        } catch (error) {
          debugPrint('Model error: $error');
          if (i < modelNames.length - 1) {
            await _switchToNextModel();
          } else {
            _addMessageAndNotify("I'm having trouble responding right now, but I'm still here for you.", role: 'assistant');
          }
        }
      }
    } catch (error) {
      debugPrint('Error sending message: $error');
      _addMessageAndNotify("Something went wrong. Please try again in a moment.", role: 'assistant');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? get currentTrackInfo => _currentTrackInfo;

  @override
  void dispose() {
    messages.clear();
    messageController.dispose();
    super.dispose();
  }
}
