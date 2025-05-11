import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../config/api_config.dart';

const List<String> modelNames = [
  'models/gemini-2.0-flash',
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

const String _systemPrompt = '''
You are a meditation recommendation assistant designed to support mental well-being and emotional clarity. Your purpose is to suggest a specific guided meditation that helps users return to calm, presence, and inner balance.

Important Guidelines:
1. Recommend only real meditation styles that promote mindfulness, presence, relaxation, and emotional resilience.
2. Include a variety of themes: breathwork, body scan, visualization, grounding, compassion, stress release, focus, etc.
3. Use soothing, grounded language — emotionally safe, never clinical or forceful.
4. Each recommendation must feel personal, gentle, and mentally supportive.
5. Avoid repetition — do not suggest the same meditation or format more than once.
6. The title must be no more than 5 words and reflect the emotional or thematic focus of the meditation.
7. The summary must be exactly 5 words that evoke emotional tone and presence.
8. The description must be no more than 50 words — warm, clear, and designed to help someone understand what the meditation offers emotionally and mentally.
9. Do not include music or sleep meditations unless explicitly requested.
10. Do not include any other content — no introductions, explanations, quotes, or emojis.

⚠️ Your response must follow this exact format with no additional text or formatting:

Title: [Meditation Title — maximum 5 words]  
Summary: [Exactly 5 words evoking the emotional tone of the meditation]  
Description: [No more than 50 words describing how the meditation supports mental and emotional well-being]
''';

/// A provider class for the MeditationScreen.
///
/// This provider manages the state of the MeditationScreen, including the
/// current meditationModelObj.
// ignore_for_file: must_be_immutable
class MeditationProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  MeditationProvider() {
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
      _addMessageAndNotify("🧘‍♀️ Welcome to your peaceful meditation space. Let's find the perfect practice for you. 🌿", role: 'assistant');
      
      // Then send the meditation recommendation with specific format request
      final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Meditation Title]  
Summary: [Exactly 5 words evoking the emotional tone of the meditation]  
Description: [No more than 50 words describing how the meditation supports mental and emotional well-being]

Suggest a completely different meditation than before, following this format exactly. Include a mix of guided meditations and breathing exercises.'''));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        _addMessageAndNotify(responseText, role: 'assistant');
      }
    } catch (error) {
      debugPrint('Error sending initial meditation request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a meditation right now. Please try asking me again.", role: 'assistant');
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
      // Filter out the "Benefits" line from AI responses
      final filteredMessage = message.split('\n')
          .where((line) => !line.startsWith('Benefits:'))
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
