import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../config/api_config.dart';
import '../../../core/services/storage_service.dart';

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

Your task is to understand how the user is feeling. Choose one of the following moods:
Heavy, Low, Neutral, Light, Bright.
Ask gentle, reflective questions to understand the user's emotional state.
When you're confident, respond:
"I sense you're feeling {mood} — your mood is safe with me! 🌟 Let's gently flow through it together. Did I get your mood right, or should we rewind? 🎯✨"
Then stop.
Wait for the user to reply again before continuing the conversation or rethinking their mood.

Be open to updating the mood if the user shares new or deeper information.

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
- Talk about anything outside mental health and well-being
- Get too long or clinical — always keep it real, human, and soothing

If someone seems deeply distressed, gently remind them they are not alone, and suggest reaching out to a trusted person or mental health professional 📞💌

Mission:
Help users feel safe, heard, and a little more okay than before 🌈
""";

class AiScreenTextProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  String? currentMood;
  bool moodConfirmed = false;
  Function? onMessageAdded;
  bool showChat = false;
  Function? onMoodConfirmed;

  AiScreenTextProvider() {
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: modelNames[_currentModelIndex],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
  }

  Future<void> _switchToNextModel() async {
    _currentModelIndex = (_currentModelIndex + 1) % modelNames.length;
    _initializeModel();
    print('🤖 [switchModel] Switched to model: ${modelNames[_currentModelIndex]}');
  }

  void _addMessageAndNotify(String message, {required String role}) {
    final isSender = role == 'user';
    messages.add({
      'text': message,
      'isSender': isSender,
      'color': isSender ? Color(0xFF1B97F3) : Color(0xFFE8E8EE),
      'tail': true,
    });
    showChat = true;
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

      // Allow mood reassessment after user's follow-up
      if (moodConfirmed) {
        moodConfirmed = false;
      }

      bool responseReceived = false;
      int attempts = 0;
      final maxAttempts = modelNames.length;

      while (!responseReceived && attempts < maxAttempts) {
        try {
          // Reset chat history for each attempt
          _chat = _model.startChat(history: [
            Content.text(_systemPrompt),
            ...messages.map((msg) => Content.text(msg['text'] as String)),
          ]);

          final response = await _chat.sendMessage(Content.text(message));
          
          if (response.text != null) {
            final responseText = response.text!.trim();
            
            // Check if the response contains a mood detection
            if (_isValidMoodResponse(responseText)) {
              _addMessageAndNotify(responseText, role: 'assistant');
              _detectMood(responseText);
              responseReceived = true;
            } else {
              // If no mood detected, try next model
              print('⚠️ No mood detected in response, trying next model');
              await _switchToNextModel();
            }
          }
        } catch (e) {
          print('Model error: $e');
          await _switchToNextModel();
        }
        attempts++;
      }

      if (!responseReceived) {
        _addMessageAndNotify(
          "I'm having trouble understanding your mood right now. Could you tell me more about how you're feeling?",
          role: 'assistant'
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      _addMessageAndNotify(
        "Something went wrong. Please try again in a moment.",
        role: 'assistant'
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidMoodResponse(String responseText) {
    final moods = ['Heavy', 'Low', 'Neutral', 'Light', 'Bright'];
    return moods.any((mood) => 
      responseText.contains("I sense you're feeling $mood") &&
      responseText.contains("your mood is safe with me")
    );
  }

  void _detectMood(String responseText) {
    print('🔍 Starting mood detection with response: $responseText');
    final moods = ['Heavy', 'Low', 'Neutral', 'Light', 'Bright'];
    for (final mood in moods) {
      if (responseText.contains("I sense you're feeling $mood")) {
        print('🎯 Found mood match: $mood');
        currentMood = mood;
        print('💡 Detected mood: $mood');
        // Save the mood immediately after detection with the correct format
        final moodWithEmoji = _getMoodWithEmoji(mood);
        print('🎨 Formatted mood with emoji: $moodWithEmoji');
        print('💾 Saving mood to storage: $moodWithEmoji with source: emoji_one');
        StorageService.saveCurrentMood(moodWithEmoji, 'emoji_one');
        print('✅ Mood saved successfully');
        break;
      }
    }
  }

  void confirmMood() {
    print('🔔 confirmMood called');
    if (currentMood != null) {
      print('📝 Current mood before confirmation: $currentMood');
      moodConfirmed = true;
      print('✅ Mood confirmed: $currentMood');
      // Don't save the mood again, it's already saved in _detectMood
    } else {
      print('⚠️ No mood to confirm - currentMood is null');
    }
  }

  String _getMoodWithEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'heavy':
        return 'Heavy 😔';
      case 'low':
        return 'Low 😕';
      case 'neutral':
        return 'Neutral 😐';
      case 'light':
        return 'Light 😃';
      case 'bright':
        return 'Bright 😊';
      default:
        return 'Neutral 😐';
    }
  }

  @override
  void dispose() {
    messages.clear();
    messageController.dispose();
    super.dispose();
  }
}