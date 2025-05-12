import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';
import '../saved_preview_screen/saved_preview_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                                                  ? FutureBuilder<String?>(
                                                      future: _getSpotifyAlbumArt(data['Youtube Link']),
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

                                                        return CachedNetworkImage(
                                                          imageUrl: snapshot.data!,
                                                          width: 160,
                                                          height: 90,
                                                          fit: BoxFit.cover,
                                                          memCacheWidth: 320,
                                                          memCacheHeight: 180,
                                                          maxWidthDiskCache: 320,
                                                          maxHeightDiskCache: 180,
                                                          fadeInDuration: Duration(milliseconds: 300),
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
                                                          ),
                                                        );
                                                      },
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
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['Title'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
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

  Future<String> _getSpotifyToken() async {
    // You'll need to implement this method to get a Spotify API token
    // This could be stored in your app's configuration or fetched from a secure backend
    return 'YOUR_SPOTIFY_API_TOKEN';
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
