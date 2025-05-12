import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';
import '../../services/spotify_track_service.dart';
import '../saved_preview_screen/saved_preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/album_landscape_card.dart';
import 'package:provider/provider.dart';
import '../music_screen/provider/music_provider.dart';
import 'package:html/parser.dart' as parser;

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const SavedScreen();
  }

  @override
  SavedScreenState createState() => SavedScreenState();
}

class SavedScreenState extends State<SavedScreen> {
  final UserService _userService = UserService();
  final SpotifyTrackService _spotifyService = SpotifyTrackService();

  Future<String?> _getSpotifyAlbumArt(String? spotifyUrl) async {
    if (spotifyUrl == null || spotifyUrl.isEmpty) return null;
    
    try {
      // Extract track ID from Spotify URL
      final uri = Uri.parse(spotifyUrl);
      final trackId = uri.pathSegments.last;
      
      // Make request to Spotify API
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
        headers: {
          'Authorization': 'Bearer ${await _getSpotifyToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final albumArtUrl = data['album']?['images']?[0]?['url'];
        return albumArtUrl;
      }
    } catch (e) {
      print('Error fetching Spotify album art: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getSpotifyTrackInfo(String? spotifyUrl) async {
    if (spotifyUrl == null || spotifyUrl.isEmpty) return null;
    
    try {
      // First try to get track info from the Spotify URL
      final uri = Uri.parse(spotifyUrl);
      final trackId = uri.pathSegments.last;
      
      // Make request to Spotify API
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
        headers: {
          'Authorization': 'Bearer ${await _getSpotifyToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'name': data['name'],
          'artists': data['artists']?.map((artist) => artist['name']).join(', '),
          'albumArtUrl': data['album']?['images']?[0]?['url'],
        };
      }
    } catch (e) {
      print('Error fetching Spotify track info from URL: $e');
      // If URL method fails, try searching by track name
      try {
        final searchResponse = await http.get(
          Uri.parse('https://api.spotify.com/v1/search?q=${Uri.encodeComponent(spotifyUrl)}&type=track&limit=1'),
          headers: {
            'Authorization': 'Bearer ${await _getSpotifyToken()}',
          },
        );

        if (searchResponse.statusCode == 200) {
          final searchData = json.decode(searchResponse.body);
          final tracks = searchData['tracks']?['items'];
          if (tracks != null && tracks.isNotEmpty) {
            final track = tracks[0];
            return {
              'name': track['name'],
              'artists': track['artists']?.map((artist) => artist['name']).join(', '),
              'albumArtUrl': track['album']?['images']?[0]?['url'],
            };
          }
        }
      } catch (searchError) {
        print('Error searching Spotify track: $searchError');
      }
    }
    return null;
  }

  Future<String> _getSpotifyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spotify_token') ?? '';
  }

  Future<String?> extractImageFromRecipeUrl(String recipeUrl) async {
    try {
      final response = await http.get(Uri.parse(recipeUrl));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        
        // Try to find og:image first
        final ogImageElements = document.head?.getElementsByTagName('meta')
            .where((meta) => meta.attributes['property'] == 'og:image');
        
        if (ogImageElements != null && ogImageElements.isNotEmpty) {
          final ogImage = ogImageElements.first.attributes['content'];
          if (ogImage != null && ogImage.isNotEmpty) {
            return ogImage;
          }
        }

        // If no og:image, try to find the first large image
        final images = document.getElementsByTagName('img');
        for (var img in images) {
          final src = img.attributes['src'];
          if (src != null && src.isNotEmpty) {
            // Check if it's a large image (you can adjust these dimensions)
            final width = int.tryParse(img.attributes['width'] ?? '0');
            final height = int.tryParse(img.attributes['height'] ?? '0');
            if (width != null && height != null && width > 300 && height > 200) {
              return src;
            }
          }
        }

        // If still no image found, return the first image
        if (images.isNotEmpty) {
          final firstImage = images.first.attributes['src'];
          if (firstImage != null && firstImage.isNotEmpty) {
            return firstImage;
          }
        }
      }
    } catch (e) {
      print('Error extracting image from recipe URL: $e');
    }
    return null;
  }

  /// Extracts the YouTube video ID from a full URL and returns the thumbnail URL.
  String? getYouTubeThumbnail(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return null;

    String? videoId;

    if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }

    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: _buildAppbar(context),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Semi-transparent overlay with blur
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Color(0xFF000000).withOpacity(0.15),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Stack(
              children: [
                // Title
                Positioned(
                  top: 0,
                  left: 21,
                  child: Text(
                    'Saved',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // List content
                Positioned(
                  top: 47,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FutureBuilder<String?>(
                    future: _userService.getCurrentUserEmail(),
                    builder: (context, emailSnapshot) {
                      if (emailSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (emailSnapshot.hasError || !emailSnapshot.hasData) {
                        return Center(child: Text('Error loading user data'));
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(emailSnapshot.data)
                            .collection('saved')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final savedItems = snapshot.data?.docs ?? [];

                          return ListView.builder(
                            itemCount: savedItems.length,
                            itemBuilder: (context, index) {
                              final data = savedItems[index].data() as Map<String, dynamic>;
                              final type = data['type'] as String? ?? '';

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SavedPreviewScreen(
                                        title: data['Title'] as String? ?? '',
                                        subtitle: data['Subtitle'] as String? ?? '',
                                        description: data['Description'] as String? ?? '',
                                        imageLink: data['Image Link'] as String?,
                                        youtubeLink: data['Youtube Link'] as String?,
                                        type: type,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  child: Stack(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/saved_preview.svg',
                                        width: 355,
                                        height: 117,
                                        fit: BoxFit.contain,
                                      ),
                                      // Image container
                                      Positioned(
                                        left: 18,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: Container(
                                            width: 160,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: type == 'Movie'
                                                ? CachedNetworkImage(
                                                    imageUrl: data['Image Link'] ?? '',
                                                    width: 160,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: CupertinoActivityIndicator(
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      color: Colors.grey[300],
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            'Image not available',
                                                            style: TextStyle(
                                                              color: Colors.grey[600],
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : type == 'Music'
                                                  ? FutureBuilder<Map<String, dynamic>?>(
                                                      future: _spotifyService.searchTrack(data['Title']),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Container(
                                                            color: Colors.grey[300],
                                                            child: Center(
                                                              child: CupertinoActivityIndicator(
                                                                color: Colors.grey[600],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        
                                                        if (snapshot.hasError || !snapshot.hasData) {
                                                          return Container(
                                                            color: Colors.grey[300],
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.music_note, color: Colors.grey[600], size: 40),
                                                                SizedBox(height: 8),
                                                                Text(
                                                                  'Album art not available',
                                                                  style: TextStyle(
                                                                    color: Colors.grey[600],
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }

                                                        final trackInfo = snapshot.data!;
                                                        return AlbumLandscapeCard(
                                                          imageUrl: trackInfo['albumArtUrl'] ?? '',
                                                          title: '',
                                                          artist: '',
                                                        );
                                                      },
                                                    )
                                                  : type == 'Book'
                                                    ? CachedNetworkImage(
                                                        imageUrl: data['Image Link'] ?? '',
                                                        width: 160,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey[300],
                                                          child: Center(
                                                            child: CupertinoActivityIndicator(
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: Colors.grey[300],
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.book, color: Colors.grey[600], size: 40),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                'Book cover not available',
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  : type == 'Cooking'
                                                    ? FutureBuilder<String?>(
                                                        future: extractImageFromRecipeUrl(data['Youtube Link'] ?? ''),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            return Container(
                                                              color: Colors.grey[300],
                                                              child: Center(
                                                                child: CupertinoActivityIndicator(
                                                                  color: Colors.grey[600],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          
                                                          if (snapshot.hasError || !snapshot.hasData) {
                                                            return Container(
                                                              color: Colors.grey[300],
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.restaurant, color: Colors.grey[600], size: 40),
                                                                  SizedBox(height: 8),
                                                                  Text(
                                                                    'Recipe image not available',
                                                                    style: TextStyle(
                                                                      color: Colors.grey[600],
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }

                                                          return CachedNetworkImage(
                                                            imageUrl: snapshot.data!,
                                                            width: 160,
                                                            height: 90,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Container(
                                                              color: Colors.grey[300],
                                                              child: Center(
                                                                child: CupertinoActivityIndicator(
                                                                  color: Colors.grey[600],
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget: (context, url, error) => Container(
                                                              color: Colors.grey[300],
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.restaurant, color: Colors.grey[600], size: 40),
                                                                  SizedBox(height: 8),
                                                                  Text(
                                                                    'Recipe image not available',
                                                                    style: TextStyle(
                                                                      color: Colors.grey[600],
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                  : type == 'Travel'
                                                    ? CachedNetworkImage(
                                                        imageUrl: data['Image Link'] ?? '',
                                                        width: 160,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey[300],
                                                          child: Center(
                                                            child: CupertinoActivityIndicator(
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: Colors.grey[300],
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.place, color: Colors.grey[600], size: 40),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                'Travel image not available',
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  : type == 'Workout'
                                                    ? CachedNetworkImage(
                                                        imageUrl: getYouTubeThumbnail(data['Youtube Link'] ?? '') ?? data['Image Link'] ?? '',
                                                        width: 160,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey[300],
                                                          child: Center(
                                                            child: CupertinoActivityIndicator(
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: Colors.grey[300],
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.fitness_center, color: Colors.grey[600], size: 40),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                'Workout image not available',
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  : type == 'Meditation'
                                                    ? CachedNetworkImage(
                                                        imageUrl: getYouTubeThumbnail(data['Youtube Link'] ?? '') ?? data['Image Link'] ?? '',
                                                        width: 160,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          color: Colors.grey[300],
                                                          child: Center(
                                                            child: CupertinoActivityIndicator(
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          color: Colors.grey[300],
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.self_improvement, color: Colors.grey[600], size: 40),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                'Meditation image not available',
                                                                style: TextStyle(
                                                                  color: Colors.grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  : Container(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Title and Type
                                      Positioned(
                                        left: 18 + 160 + 21,
                                        top: 37,
                                        right: 50,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              data['Title'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              type,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Right chevron
                                      Positioned(
                                        right: 20,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/right_chevron_saved.svg',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LittleLiftsScreen.builder(context),
                ),
                (route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 10),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27,
                height: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
