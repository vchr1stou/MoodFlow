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
You are a wellness workout recommendation assistant. Your goal is to suggest one energizing or calming workout that supports emotional well-being, mental clarity, and self-confidence.

Important Guidelines:
1. Recommend workouts that help mentally — reduce stress, boost mood, or restore energy.
2. Prioritize workouts that empower, reset the nervous system, or help the user feel strong and emotionally clear.
3. Suggestions can include light movement (e.g. yoga, walking, stretching) or energizing routines (e.g. boxing, dance, strength), but they must always feel emotionally safe and supportive.
4. Be playful, encouraging, and real — use a human tone.
5. Avoid anything overwhelming, aggressive, or overly intense.
6. Every suggestion must be unique and not repeated — do not recommend the same workout type twice in a row.
7. Do not only suggest dance cardio or similar workouts — offer variety across yoga, pilates, stretching, boxing, HIIT, breathwork, strength, etc.
8. For the summary, use exactly 5 words that feel punchy, playful, or comforting.
9. For the description, write a warm, motivating paragraph (no more than 50 words) that explains what the workout helps with emotionally and physically.
10. For the video, include a direct link to a workout on YouTube that clearly demonstrates the routine. The link must work and match the workout recommended.

⚠️ Your output must follow this exact format with no additional text, emojis, or formatting:

Title: [Workout Title]  
Summary: [Exactly 5 words, playful and tone-appropriate]  
Description: [Up to 50 words describing how the workout supports mental and emotional well-being]  
Video: [Direct YouTube link to the workout]
''';

class WorkoutProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  WorkoutProvider() {
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
      debugPrint('🤖 [AI] Sending initial greeting...');
      // First send the welcome message
      _addMessageAndNotify("Let's get your body moving and your mood lifting! 💪", role: 'assistant');
      
      // Then send the workout recommendation with specific format request
      debugPrint('🤖 [AI] Requesting initial workout recommendation...');
      final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Workout Title]  
Summary: [Exactly 5 words, playful and tone-appropriate]  
Description: [Up to 50 words describing how the workout supports mental and emotional well-being]  

Suggest a completely different uplifting workout than before, following this format exactly. Include a mix of different workout types. Make sure to use a high-quality, landscape-oriented image URL for the photo.'''));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        debugPrint('🤖 [AI] Received response: $responseText');
        _addMessageAndNotify(responseText, role: 'assistant');
      }
    } catch (error) {
      debugPrint('❌ [AI] Error sending initial workout request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a workout right now. Please try asking me again.", role: 'assistant');
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
      // Filter out any unwanted lines from AI responses
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
      debugPrint('🤖 [AI] User message: $message');
      _addMessageAndNotify(message, role: 'user');
      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      for (int i = 0; i < modelNames.length; i++) {
        try {
          debugPrint('🤖 [AI] Attempting with model: ${modelNames[i]}');
          _chat = _model.startChat(history: [
            Content.text(_systemPrompt),
            ...messages.map((msg) => Content.text(msg['content']!)),
          ]);

          final response = await _chat.sendMessage(Content.text(message));
          if (response.text != null) {
            final responseText = response.text!.trim();
            debugPrint('🤖 [AI] Model ${modelNames[i]} response: $responseText');
            _addMessageAndNotify(responseText, role: 'assistant');
            break;
          }

          await _switchToNextModel();
        } catch (error) {
          debugPrint('❌ [AI] Model ${modelNames[i]} error: $error');
          if (i < modelNames.length - 1) {
            await _switchToNextModel();
          } else {
            _addMessageAndNotify("I'm having trouble responding right now, but I'm still here for you.", role: 'assistant');
          }
        }
      }
    } catch (error) {
      debugPrint('❌ [AI] Error sending message: $error');
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
