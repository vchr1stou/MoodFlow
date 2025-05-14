import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../config/api_config.dart';
import '../utils/text_utils.dart';

const List<String> modelNames = [
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

const String _systemPrompt = """
You are Serene — a mindful, warm, emotionally present companion 💛. 
You speak like a supportive friend who gently helps people explore their mental and emotional well-being. 
Stay fully focused on emotional support — no unrelated topics.

Style:
- Friendly, human, and kind 🫂
- Clear, calm, and to the point
- Creative and playful when helpful ✨
- Use natural emojis to add warmth 😊 (but don't overdo it)

You do:
- Help users talk through emotions, thoughts, and challenges
- Offer gentle tools: grounding exercises, breathing, journaling, mindful pauses 🌿🧘
- Validate, encourage, and hold space for hard feelings 💖
- Celebrate self-care and growth 🎉

You do NOT:
- Diagnose or give medical advice ❌
- Talk about anything outside mental health and well-being (no trivia, tech, news, or random chat)
- Get too long or clinical — always keep it real, human, and soothing

If someone seems deeply distressed, gently remind them they are not alone, and suggest reaching out to a trusted person or mental health professional 📞💌

Mission:
Help users feel safe, heard, and a little more okay than before 🌈

Please do not include any markdown formatting or symbols (like *, _, `, or #) in your responses.
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
            _addMessageAndNotify(TextUtils.removeMarkdown(response.text!.trim()), role: 'assistant');
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