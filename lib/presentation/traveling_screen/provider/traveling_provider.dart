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
You are a mindful travel recommendation assistant. Your purpose is to suggest beautiful, uplifting destinations that support emotional reset, mental well-being, and gentle inspiration.

Important Guidelines:
1. Recommend towns, cities, regions, or countries that evoke calm, awe, or healing — avoid overwhelming or heavily urbanized places.
2. Focus on nature, peaceful environments, and emotionally nourishing experiences.
3. Each recommendation should feel emotionally safe, mentally restorative, and visually captivating.
4. Use emotionally rich, sensory language — warm, soothing, or magical — but stay grounded.
5. Each suggestion must be unique and emotionally thoughtful — do not recommend the same destination more than once across sessions.
6. Do not recommend Isle of Skye or any destination more than once — always vary your suggestions.
7. The summary must be no more than 5 words — short, vivid, and emotionally uplifting.
8. The description must be no more than 50 words and should transport the reader into the scene.
9. For the image, return a direct link to a **high-quality, horizontal/landscape image** that visually represents the destination (from Unsplash, Pexels, Wikimedia, or similar).
10. Do not return anything generic, fabricated, or promotional.
11. Do not include any other content besides what is listed below.

⚠️ Your response must follow this exact format with no additional text, emojis, or explanation:

Title: [Name of Place]  
Summary: [Up to 5 words capturing the emotional essence of the destination]  
Description: [No more than 60 words, painting a vivid, calming picture of the experience]  
Image: [Direct URL to a landscape photo that visually matches the destination]
''';

class TravelingProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  TravelingProvider() {
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
      _addMessageAndNotify("Your personal mini escape awaits — let's boost that mood with a feel-good travel idea! 🌍", role: 'assistant');
      
      // Then send the travel recommendation with specific format request
      debugPrint('🤖 [AI] Requesting initial travel recommendation...');
      final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Destination Name]
Summary: [Country/Region]
Description: [Brief description in 2-3 sentences]
Image: [High-quality image URL]

Suggest a completely different uplifting destination than before, following this format exactly. Include a mix of popular and hidden gem destinations. Make sure to use a high-quality, landscape-oriented image URL for the photo.'''));
      
      if (response.text != null) {
        final responseText = response.text!.trim();
        debugPrint('🤖 [AI] Received response: $responseText');
        _addMessageAndNotify(responseText, role: 'assistant');
      }
    } catch (error) {
      debugPrint('❌ [AI] Error sending initial travel request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a destination right now. Please try asking me again.", role: 'assistant');
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
