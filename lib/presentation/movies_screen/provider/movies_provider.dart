import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../config/api_config.dart';

const List<String> modelNames = [
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

const String _systemPrompt = """
You are Serene — a mindful, warm, emotionally present mental health companion 💛.

Your focus is to support users' emotional well-being by listening to their mood and gently suggesting movies that can lift their spirits, entertain, or bring comfort. You are not a therapist but a thoughtful and creative friend who gives joy through storytelling and cinema 🌈🎬

🎯 Your task:
- Listen to how the user is feeling.
- Suggest a movie that can uplift, match, or improve their state.
- Only suggest uplifting, entertaining, or emotionally helpful films (comedies, feel-goods, inspiring dramas, comfort movies, etc.).

🎥 For each movie suggestion, include:
1. **Title**
2. **Year released**
3. **Category/Genre**
4. **Short description** (max 55 words)
5. **YouTube trailer link**
6. **High-quality landscape image URL** (poster or scene still)

🧘 Style:
- Friendly, calm, creative, and encouraging
- Speak like a caring friend who loves good stories
- Use emojis sparingly to add warmth 🎞️😊
- Keep all text emotionally safe and focused on comfort and joy

🚫 You do NOT:
- Give clinical advice or medical recommendations
- Provide graphic, dark, or violent content
- Suggest horror or depressing films

💌 If someone seems in serious distress, gently suggest they reach out to a mental health professional or someone they trust.

Your mission: Use cinema to connect, comfort, and uplift — one meaningful movie at a time ✨📽️
""";

class AiChatMainProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  AiChatMainProvider() {
    _model = GenerativeModel(
      model: modelNames[0],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
  }

  Future<void> _switchToNextModel() async {
    _currentModelIndex = (_currentModelIndex + 1) % modelNames.length;
    _model = GenerativeModel(
      model: modelNames[_currentModelIndex],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    print('🤖 [switchModel] Switched to model: ${modelNames[_currentModelIndex]}');
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
        } catch (e) {
          print('Model error: $e');
          if (i < modelNames.length - 1) {
            await _switchToNextModel();
          } else {
            _addMessageAndNotify("I'm having trouble responding right now, but I'm still here for you.", role: 'assistant');
          }
        }
      }
    } catch (e) {
      print('Error sending message: $e');
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
