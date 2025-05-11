import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart';

const List<String> modelNames = [
  'models/gemini-2.0-flash',
  'models/gemini-2.5-pro',
  'models/gemini-2.0-pro',
  'models/gemini-2.0-flash-lite',
];
int _currentModelIndex = 0;

// Fetch ISBN from Open Library by book title
Future<String?> fetchISBNByTitle(String title) async {
  try {
    final searchUrl = 'https://openlibrary.org/search.json?title=${Uri.encodeComponent(title)}';
    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final docs = data['docs'] as List<dynamic>;
      if (docs.isNotEmpty && docs[0]['isbn'] != null) {
        final isbnList = List<String>.from(docs[0]['isbn']);
        return isbnList.first;
      }
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching ISBN: $e');
    return null;
  }
}

// Fetch book cover ID from Open Library by book title
Future<String?> fetchCoverIdByTitle(String title) async {
  try {
    final searchUrl = 'https://openlibrary.org/search.json?title=${Uri.encodeComponent(title)}';
    debugPrint('🔍 Searching Open Library: $searchUrl');
    
    final response = await http.get(Uri.parse(searchUrl));
    if (response.statusCode != 200) {
      debugPrint('❌ Open Library search failed: ${response.statusCode}');
      return null;
    }

    final data = jsonDecode(response.body);
    final docs = data['docs'] as List<dynamic>;
    
    if (docs.isEmpty) {
      debugPrint('❌ No results found for title: $title');
      return null;
    }

    // Get the first result
    final firstDoc = docs[0];
    
    // Check if it has a cover_i field (Open Library's cover ID)
    if (firstDoc['cover_i'] != null) {
      final coverId = firstDoc['cover_i'].toString();
      debugPrint('✅ Found cover ID: $coverId for title: $title');
      return coverId;
    }

    debugPrint('❌ No cover ID found for title: $title');
    return null;
  } catch (e) {
    debugPrint('❌ Error fetching cover ID: $e');
    return null;
  }
}

// Check if the cover image is valid (not white/blank)
Future<bool> isCoverImageValid(String coverUrl) async {
  try {
    debugPrint('🔍 Checking cover URL: $coverUrl');
    
    // First check if the URL is valid
    if (!coverUrl.startsWith('https://covers.openlibrary.org/b/isbn/')) {
      debugPrint('❌ Invalid cover URL format');
      return false;
    }

    final response = await http.get(Uri.parse(coverUrl));
    debugPrint('📥 Response status: ${response.statusCode}, content-length: ${response.headers['content-length']}');
    
    if (response.statusCode != 200) {
      debugPrint('❌ Invalid status code: ${response.statusCode}');
      return false;
    }
    
    // Check content length from headers
    final contentLength = response.headers['content-length'];
    if (contentLength != null) {
      final length = int.tryParse(contentLength);
      if (length != null) {
        debugPrint('📏 Content length: $length bytes');
        // Open Library blank covers are typically very small
        if (length < 5000) {
          debugPrint('❌ Content too small, likely a blank cover');
          return false;
        }
      }
    }

    // Check actual image data
    final bytes = response.bodyBytes;
    debugPrint('📦 Image data size: ${bytes.length} bytes');
    
    if (bytes.length < 5000) {
      debugPrint('❌ Image data too small, likely a blank cover');
      return false;
    }

    // Check JPEG header
    if (bytes.length >= 2) {
      final isJpeg = bytes[0] == 0xFF && bytes[1] == 0xD8;
      if (!isJpeg) {
        debugPrint('❌ Not a valid JPEG image');
        return false;
      }
    }

    // Additional check: look for Open Library's blank cover pattern
    // Open Library's blank covers often have a specific pattern in their first few bytes
    if (bytes.length > 20) {
      final header = bytes.sublist(0, 20);
      final isBlankPattern = header.every((byte) => byte == 0xFF || byte == 0xDB || byte == 0xC0);
      if (isBlankPattern) {
        debugPrint('❌ Detected Open Library blank cover pattern');
        return false;
      }
    }

    debugPrint('✅ Cover image appears valid');
    return true;
  } catch (e) {
    debugPrint('❌ Error checking cover image: $e');
    return false;
  }
}

const String _systemPrompt = '''
You are a thoughtful book recommendation assistant focused on emotional well-being, inspiration, and mental clarity. Your job is to recommend books that support the reader's mental, emotional, or spiritual growth — following the exact format and guidelines below.

Important Guidelines:
1. Only suggest books that are uplifting, mindful, emotionally enriching, inspiring, or supportive of mental health.
2. Include a variety of genres (non-fiction, memoir, fiction, poetry, essays, etc.).
3. Do not include books with heavy trauma, graphic violence, or emotionally triggering content.
4. Recommendations may be modern or classic — aim for variety and depth.
5. Avoid repeating the same titles or authors across responses (Dont recommend the same book twice & Dont recommend th Braiding Sweetgrass & dont recommend the Man's Search for Meaning).
6. The description must be concise and thoughtful: maximum 50 words, focusing on what the book explores and why it's helpful for well-being.
7. Use emotionally intelligent and human language — grounded, gentle, and hopeful.
8. Do not recommend multiple books — only one per response.
9. For the cover photo, use Open Library's cover image URL format:
   - https://covers.openlibrary.org/b/id/[COVER_ID]-L.jpg
   - The cover ID will be provided by the system, do not include it in your response.

⚠️ You must include ALL of the following fields in every response. Do not leave any field blank. Do not include additional commentary or formatting.

Format your response exactly like this:
Title: [Book Title]  
Author: [Author Name]  
Genre: [Book Genre]  
Published: [Year]  
Description: [Concise description, max 50 words]  
Link: [Direct link to a trusted source like Goodreads, Bookshop.org, or the publisher]  
Photo: [Leave this blank, the system will add the cover URL]

Do not include any extra text, emojis, or formatting outside this structure.
''';

class BookProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  bool showChat = true;

  late GenerativeModel _model;
  late ChatSession _chat;
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  Function? onMessageAdded;

  BookProvider() {
    _model = GenerativeModel(
      model: modelNames[0],
      apiKey: ApiConfig.geminiApiKey,
    );
    _chat = _model.startChat(history: [Content.text(_systemPrompt)]);
    sendInitialGreeting();
  }

  Future<bool> isOpenLibraryLinkValid(String title, String author) async {
    try {
      final searchQuery = Uri.encodeComponent('$title $author');
      final url = 'https://openlibrary.org/search?q=$searchQuery';
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 && response.body.contains('works/');
    } catch (e) {
      debugPrint('Error checking Open Library link: $e');
      return false;
    }
  }

  Future<void> sendInitialGreeting() async {
    isLoading = true;
    notifyListeners();

    try {
      _addMessageAndNotify("📖✨ Storytime, mood on! Here's your perfect bookish escape—just for you! 📚💫", role: 'assistant');
      
      bool validBook = false;
      int attempts = 0;
      const maxAttempts = 3;
      
      while (!validBook && attempts < maxAttempts) {
        attempts++;
        final response = await _chat.sendMessage(Content.text('''
Please suggest a completely different uplifting book than before, following this format exactly:
Title: [Book Title]
Author: [Author Name]
Genre: [Book Genre]
Published: [Year]
Description: [Concise description, max 50 words]'''));
        
        if (response.text != null) {
          final responseText = response.text!.trim();
          debugPrint('📚 AI Response: $responseText');
          
          final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(responseText);
          final authorMatch = RegExp(r'Author:\s*(.*)').firstMatch(responseText);
          
          if (titleMatch != null && authorMatch != null) {
            final title = titleMatch.group(1)?.trim() ?? '';
            final author = authorMatch.group(1)?.trim() ?? '';
            debugPrint('📚 Extracted title: $title, author: $author');
            
            if (title.isNotEmpty && author.isNotEmpty) {
              // Check if the Open Library link is valid
              final isValid = await isOpenLibraryLinkValid(title, author);
              if (!isValid) {
                debugPrint('❌ Open Library link not valid for: $title by $author, requesting new book...');
                continue; // Try another book
              }

              // Get the cover ID directly from Open Library
              final coverId = await fetchCoverIdByTitle(title);
              if (coverId == null) {
                debugPrint('❌ No cover found for: $title, requesting new book...');
                continue; // Try another book
              }

              // Construct the cover URL using the cover ID
              final coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
              debugPrint('🖼️ Generated Cover URL: $coverUrl');
              
              // Verify the cover URL format
              if (!coverUrl.startsWith('https://covers.openlibrary.org/b/id/')) {
                debugPrint('❌ Invalid cover URL format: $coverUrl');
                continue; // Try another book
              }
              
              final searchQuery = Uri.encodeComponent('$title $author');
              final bookLink = 'https://openlibrary.org/search?q=$searchQuery';
              debugPrint('🔗 Open Library link: $bookLink');
              
              // Remove any existing Photo line from the response
              final cleanedResponse = responseText.split('\n')
                  .where((line) => !line.startsWith('Photo:'))
                  .join('\n');
              
              final finalMessage = cleanedResponse + 
                '\nPhoto: $coverUrl' +
                '\nLink: $bookLink';
              
              _addMessageAndNotify(finalMessage, role: 'assistant');
              validBook = true;
            } else {
              _addMessageAndNotify(responseText, role: 'assistant');
              validBook = true;
            }
          } else {
            _addMessageAndNotify(responseText, role: 'assistant');
            validBook = true;
          }
        }
      }
      
      if (!validBook) {
        _addMessageAndNotify("I'm having trouble finding a valid book right now. Please try asking me again.", role: 'assistant');
      }
    } catch (error) {
      debugPrint('❌ Error sending initial book request: $error');
      _addMessageAndNotify("I'm having trouble suggesting a book right now. Please try asking me again.", role: 'assistant');
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
    debugPrint('🤖 [switchModel] Switched to model: \${modelNames[_currentModelIndex]}');
  }

  void _addMessageAndNotify(String message, {required String role}) {
    if (role == 'assistant') {
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
          debugPrint('Model error: \$error');
          if (i < modelNames.length - 1) {
            await _switchToNextModel();
          } else {
            _addMessageAndNotify("I'm having trouble responding right now, but I'm still here for you.", role: 'assistant');
          }
        }
      }
    } catch (error) {
      debugPrint('Error sending message: \$error');
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
