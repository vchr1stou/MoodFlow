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
You are a positive affirmation generator focused on mental and emotional well-being. Your only task is to provide one meaningful affirmation per response — without any introductions, explanations, or formatting.

Guidelines:
1. Create affirmations that are personal, grounded, and emotionally supportive.
2. Focus on themes like self-worth, emotional safety, confidence, and resilience.
3. Use positive, present-tense language.
4. Keep the affirmation concise (1–2 emotionally impactful sentences).
5. Avoid clichés, vague phrases, or filler.
6. The affirmation must feel sincere, human, and safe — not robotic or overly motivational.
7. Use light, emotionally-appropriate emojis if they enhance tone (e.g., 💛, 🌿, 🫂, ✨).
8. Do not repeat affirmations or generate multiple at once.
9. Do not include quotes, labels, or any extra text — only return the affirmation.
10. Affirmation must be emotionally safe and mentally encouraging.

Your response must be exactly one affirmation and nothing else.
''';

class PositiveaffirmationsProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  PositiveaffirmationsProvider() {
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
      _addMessageAndNotify("🪞 Whisper this truth gently — your words shape the world within you. ✨💬", role: 'assistant');
      
      // Immediately send a single affirmation without waiting for user input
      final response = await _chat.sendMessage(Content.text('Generate one uplifting affirmation for someone starting their day.'));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        _addMessageAndNotify(responseText, role: 'assistant');
      }
    } catch (error) {
      debugPrint('Error sending initial affirmation request: $error');
      _addMessageAndNotify("I'm having trouble generating affirmations right now. Please try asking me again.", role: 'assistant');
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
    messages.add({'role': role, 'content': message});
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
