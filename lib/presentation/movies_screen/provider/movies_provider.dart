import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../config/api_config.dart';

const List<String> modelNames = [
  'models/gemini-2.0-flash',
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

const String _systemPrompt = '''
You are a movie recommendation system. Your responses should ONLY include the requested movie data in the exact format specified, without any additional commentary, introductions, or explanations.

Important Guidelines:
1. NEVER recommend Paddington 2, Sing, Amélie, or any movie from the Paddington or Sing franchises.
2. Always suggest different movies — avoid repeating the same titles across responses.
3. Include a mix of recent movies (from the last 5 years) and timeless classics.
4. Vary the genres and styles of movies (comedy, drama, adventure, feel-good romance, musical, etc.).
5. Prefer live-action movies. Only recommend animated films when absolutely necessary and emotionally outstanding.
6. Ensure all suggestions are uplifting, positive, and emotionally supportive.
7. For the Poster field:
   - First, attempt to get a **backdrop image** using TMDb.
   - Use the TMDb Image API:
     - First, search for the movie title using: https://api.themoviedb.org/3/search/movie?api_key=d333a0b62b637851256f90a16c56f448&query=[Movie+Title]
     - Get the `id` from the best match.
     - Then fetch images using: https://api.themoviedb.org/3/movie/[movie_id]/images?api_key=d333a0b62b637851256f90a16c56f448
     - Select the first backdrop from the `backdrops` array, and build the URL:
       https://image.tmdb.org/t/p/w780/[backdrop_path]
   - If no backdrops are available, fallback to the first image in the `posters` array, using the same format:
       https://image.tmdb.org/t/p/w780/[poster_path]
   - NEVER use images from Wikipedia, IMDb, Rotten Tomatoes, or any unreliable source.
8. Each recommendation must be completely different from previous ones, even across multiple requests.
9. Provide multiple suggestions when possible (3–5 different movies).
10. For the trailer, search YouTube for: “[Movie Title] trailer” and return the first valid YouTube link (either youtube.com or youtu.be). Do not return playlists or unrelated videos. Only one link is allowed.

⚠️ You must include ALL of the following fields in every response. Do not leave any field blank.

Format your responses exactly like this for EACH movie:
Title: [Movie Title]  
Year: [Release Year]  
Genre: [Movie Genre]  
Description: [Brief description in 2–3 sentences]  
Trailer: [YouTube trailer URL]  
Poster: [TMDb Backdrop or Poster URL]

Do not add any other text, emojis, or formatting.
''';

class MoviesProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  MoviesProvider() {
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
      _addMessageAndNotify("🍿 Lights, camera, mood boost! Here's your personal feel-good movie lineup! 🎬", role: 'assistant');
      
      // Then send the movie recommendation with specific format request
      final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Movie Title]
Year: [Release Year]
Genre: [Movie Genre]
Description: [Brief description in 2-3 sentences]
Why It's Uplifting: [1-2 sentences about why this movie is uplifting]
Trailer: [Full YouTube URL starting with https://www.youtube.com/watch?v= - MUST be a valid, working video]
Poster: [TMDb backdrop image URL - must be a landscape backdrop image from TMDb, format: https://image.tmdb.org/t/p/w780/[backdrop_path]]

Suggest a completely different uplifting movie than before, following this format exactly. Do NOT suggest Paddington 2 or any Paddington movies. Include a mix of recent and classic films. Make sure to use a TMDb backdrop image URL for the poster. For the trailer, use ONLY valid, working YouTube URLs that start with https://www.youtube.com/watch?v= and contain a valid video ID.'''));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        _addMessageAndNotify(responseText, role: 'assistant');
      }
    } catch (error) {
      debugPrint('Error sending initial movie request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a movie right now. Please try asking me again.", role: 'assistant');
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

  @override
  void dispose() {
    messages.clear();
    messageController.dispose();
    super.dispose();
  }
}
