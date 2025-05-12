import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../../config/api_config.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

const List<String> modelNames = [
  'models/gemini-2.0-flash',
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

class ImageCacheHelper {
  static Future<String> getLocalImagePath(String imageUrl) async {
    try {
      // Create a hash of the URL to use as filename
      final hash = sha256.convert(utf8.encode(imageUrl)).toString();
      final extension = imageUrl.split('.').last.split('?').first;
      final fileName = '$hash.$extension';
      
      // Get the local cache directory
      final cacheDir = await getTemporaryDirectory();
      final filePath = '${cacheDir.path}/recipe_images/$fileName';
      
      // Create directory if it doesn't exist
      final directory = Directory('${cacheDir.path}/recipe_images');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        debugPrint('📸 Using cached image: $filePath');
        return filePath;
      }
      
      // Download and save the image
      debugPrint('📥 Downloading image from: $imageUrl');
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      
      await file.writeAsBytes(response.data);
      debugPrint('💾 Saved image to: $filePath');
      
      return filePath;
    } catch (e) {
      debugPrint('❌ Error caching image: $e');
      return imageUrl; // Return original URL if caching fails
    }
  }
}

Future<Map<String, String>?> fetchBBCGoodFoodRecipe(String query) async {
  try {
    debugPrint('🔍 Processing recipe query: $query');
    
    // Convert title to URL format
    final urlTitle = query
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '') // Remove special characters
        .trim()
        .replaceAll(RegExp(r'\s+'), '-'); // Replace spaces with hyphens
    
    final recipeUrl = 'https://www.bbcgoodfood.com/recipes/$urlTitle';
    debugPrint('🔗 Constructed recipe URL: $recipeUrl');
    
    // Fetch the recipe page
    final recipeResponse = await http.get(Uri.parse(recipeUrl));
    debugPrint('📡 Recipe page response status: ${recipeResponse.statusCode}');

    if (recipeResponse.statusCode != 200) {
      debugPrint('❌ Recipe page request failed with status: ${recipeResponse.statusCode}');
      return null;
    }

    final recipeDoc = parse(recipeResponse.body);
    
    // Get the title
    final titleElement = recipeDoc.querySelector('h1') ??
                        recipeDoc.querySelector('.recipe__title') ??
                        recipeDoc.querySelector('.recipe-header__title');
    final title = titleElement?.text.trim() ?? '';
    
    // Get the image URL from og:image meta tag
    String? imageUrl;
    final ogImageTag = recipeDoc.querySelector('meta[property="og:image"]');
    if (ogImageTag != null) {
      imageUrl = ogImageTag.attributes['content'];
      debugPrint('🖼️ Found og:image URL: $imageUrl');
    }
    
    debugPrint('📝 Found title: $title');

    final result = {
      'title': title,
      'url': recipeUrl,
      'image': imageUrl ?? '',
    };
    debugPrint('✅ Successfully fetched recipe data: $result');
    return result;
  } catch (e) {
    debugPrint('❌ Error fetching recipe: $e');
    return null;
  }
}

const String _systemPrompt = '''
You are a recipe suggestion assistant. Your job is to recommend fun and uplifting recipes based on variety and inspiration.

Important Guidelines:
1. Only suggest real recipes from **bbcgoodfood.com**
2. Always return different recipes — avoid repetition.
3. Include a variety of cuisines, ingredients, and meal types.
4. The description must be fun, playful, and make someone excited to cook.
5. Do NOT guess or create fake recipe URLs.
6. For the recipe field:
   - Just return the exact recipe title.
   - The system using your response will search bbcgoodfood.com using that title.
7. Leave the Recipe and Image fields as [To be looked up by app].
8. Time must be specified in minutes (e.g., "45 mins")
9. Servings must be specified as "{number} portions" (e.g., "4 portions")

⚠️ Include ALL of the following fields. Do not skip any.

Format:
Title: [Recipe Name]  
Time: [Total prep + cook time in minutes] mins
Servings: [Number] portions
Description: [5 fun sentences about why the recipe is exciting]  
Recipe: [To be looked up by app]  
Image: [To be looked up by app]

Do not add any extra text or formatting.
''';

class CookingProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;
  bool isLoading = false;
  Function? onMessageAdded;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];

  CookingProvider() {
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
      debugPrint('👋 Sending initial greeting');
      _addMessageAndNotify("🫖 A cozy kitchen, a calm mood, and the perfect feel-good recipe. 💛", role: 'assistant');
      
      // Try up to 10 different recipes
      for (int attempt = 0; attempt < 10; attempt++) {
        debugPrint('🤖 Requesting recipe from AI (attempt ${attempt + 1})');
        final response = await _chat.sendMessage(Content.text('''
Format:
Title: [Recipe Name]
Time: [Total prep + cook time in minutes]
Servings: [How many it serves]
Description: [2–3 fun sentences about why the recipe is exciting]
Recipe: [To be looked up by app]
Image: [To be looked up by app]

Suggest a completely different recipe than before, following this format exactly. Do not include any other text, emojis, or formatting.'''));
        
        if (response.text != null) {
          final responseText = response.text!.trim();
          debugPrint('📝 AI Response: $responseText');
          
          final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(responseText);
          if (titleMatch != null) {
            final recipeTitle = titleMatch.group(1)?.trim();
            debugPrint('🔍 Extracted recipe title: $recipeTitle');
            
            if (recipeTitle != null) {
              final recipeData = await fetchBBCGoodFoodRecipe(recipeTitle);
              if (recipeData != null && recipeData['image']?.isNotEmpty == true) {
                debugPrint('🔄 Updating message with recipe data');
                final updatedResponse = responseText
                    .replaceAll('Recipe: [To be looked up by app]', 'Recipe: ${recipeData['url']}')
                    .replaceAll('Image: [To be looked up by app]', 'Image: ${recipeData['image']}');
                _addMessageAndNotify(updatedResponse, role: 'assistant');
                debugPrint('✅ Message updated with recipe data');
                return; // Successfully found a recipe with image
              } else {
                debugPrint('⚠️ Recipe found but no image URL, trying another recipe...');
                continue; // Try another recipe
              }
            }
          }
        }
      }
      
      // If we get here, we couldn't find a valid recipe after 10 attempts
      debugPrint('❌ Could not find a valid recipe after 10 attempts');
      _addMessageAndNotify("I'm having trouble finding a recipe right now. Please try asking me again.", role: 'assistant');
    } catch (error) {
      debugPrint('❌ Error in sendInitialGreeting: $error');
      _addMessageAndNotify("I'm having trouble suggesting a recipe right now. Please try asking me again.", role: 'assistant');
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

    // Add user message
    messages.add({
      'role': 'user',
      'content': message,
    });
    notifyListeners();

    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      final response = await _chat.sendMessage(
        Content.text(message),
      );

      final responseText = response.text;
      if (responseText != null && responseText.isNotEmpty) {
        // Add assistant message
        messages.add({
          'role': 'assistant',
          'content': responseText,
        });
        notifyListeners();

        if (onMessageAdded != null) {
          onMessageAdded!();
        }
      }
    } catch (error) {
      debugPrint('Error sending message: $error');
      // Add error message
      messages.add({
        'role': 'assistant',
        'content': "I'm having trouble processing your request. Please try again.",
      });
      notifyListeners();
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
