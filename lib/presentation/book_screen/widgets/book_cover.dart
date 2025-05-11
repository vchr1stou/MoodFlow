import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

class BookCover extends StatelessWidget {
  final String coverUrl;
  final String title;

  const BookCover({
    required this.coverUrl,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coverUrl.isEmpty) {
      debugPrint('❌ Empty cover URL provided to BookCover');
      return _buildErrorContainer();
    }
    
    debugPrint('📚 Building BookCover with URL: $coverUrl');
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 313,
        height: 176,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred background image
            CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              width: 313,
              height: 176,
              memCacheWidth: 626,
              memCacheHeight: 352,
              maxWidthDiskCache: 626,
              maxHeightDiskCache: 352,
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) {
                debugPrint('❌ Error loading image: $error');
                return _buildErrorContainer();
              },
            ),
            // Blur overlay
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            // Main cover image
            CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.contain,
              width: 313,
              height: 176,
              memCacheWidth: 626,
              memCacheHeight: 352,
              maxWidthDiskCache: 626,
              maxHeightDiskCache: 352,
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) {
                debugPrint('❌ Error loading image: $error');
                return _buildErrorContainer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      width: 313,
      height: 176,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 