import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = bookProvider.messages[index];
                    final isUser = message['role'] == 'user';
                    
                    if (isUser) {
                      return _buildUserMessage(message['content']!);
                    } else {
                      final info = extractBookInfo(message['content']!);
                      return _buildBookRecommendation(info);
                    }
                  },
                ),
              ),
              if (bookProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> extractBookInfo(String message) {
    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(message);
    final authorMatch = RegExp(r'Author:\s*(.*)').firstMatch(message);
    final genreMatch = RegExp(r'Genre:\s*(.*)').firstMatch(message);
    final publishedMatch = RegExp(r'Published:\s*(.*)').firstMatch(message);
    final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n\w+:|$)').firstMatch(message);
    final linkMatch = RegExp(r'Link:\s*(.*)').firstMatch(message);
    final isbnMatch = RegExp(r'ISBN:\s*(.*)').firstMatch(message);
    final coverMatch = RegExp(r'Cover:\s*(.*)').firstMatch(message);
    final photoMatch = RegExp(r'Photo:\s*(.*)').firstMatch(message);

    // Use cover URL from either Cover: or Photo: field
    final coverUrl = coverMatch?.group(1)?.trim() ?? photoMatch?.group(1)?.trim();

    return {
      'title': titleMatch?.group(1)?.trim() ?? '',
      'author': authorMatch?.group(1)?.trim() ?? '',
      'genre': genreMatch?.group(1)?.trim() ?? '',
      'published': publishedMatch?.group(1)?.trim() ?? '',
      'description': descriptionMatch?.group(1)?.trim() ?? '',
      'link': linkMatch?.group(1)?.trim() ?? '',
      'isbn': isbnMatch?.group(1)?.trim() ?? '',
      'coverUrl': coverUrl ?? '',
    };
  }

  Widget _buildBookRecommendation(Map<String, String> info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BookCover(
                coverUrl: info['coverUrl'] ?? '',
                title: info['title'] ?? '',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            info['title'] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book (${info['published']}) · ${info['genre']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            info['description'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (info['link']?.isNotEmpty ?? false)
            GestureDetector(
              onTap: () {
                if (info['link'] != null) {
                  launchUrl(Uri.parse(info['link']!));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/watch_ytb.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Get Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    // Implementation of _buildMessageInput method
  }

  Widget _buildUserMessage(String message) {
    // Implementation of _buildUserMessage method
  }
} 