import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';
import '../../services/spotify_track_service.dart';
import '../saved_screen/saved_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/album_landscape_card.dart';

class SavedPreviewScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final String? imageLink;
  final String? youtubeLink;
  final String type;

  const SavedPreviewScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.imageLink,
    this.youtubeLink,
    required this.type,
  }) : super(key: key);

  static Widget builder(BuildContext context) {
    return const SavedPreviewScreen(
      title: '',
      subtitle: '',
      description: '',
      type: '',
    );
  }

  @override
  SavedPreviewScreenState createState() => SavedPreviewScreenState();
}

class SavedPreviewScreenState extends State<SavedPreviewScreen> {
  final UserService _userService = UserService();
  final SpotifyTrackService _spotifyService = SpotifyTrackService();
  String? userEmail;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final userData = await _userService.getCurrentUserData();
      setState(() {
        userEmail = userData?['email'];
        _isInitialized = true;
      });
    } catch (e) {
      print('Error loading user email: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _launchTrailerUrl() async {
    if (widget.youtubeLink != null && widget.youtubeLink!.isNotEmpty) {
      try {
        final uri = Uri.parse(widget.youtubeLink!);
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        print('Error launching URL: $e');
      }
    }
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
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  if (_isInitialized && userEmail != null)
                    Container(
                      width: 366,
                      height: 491,
                      child: Stack(
                        children: [
                          // Movie time box background
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/movie_time_box.svg',
                              width: 366,
                              height: 491,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Image or Album Art
                          Positioned(
                            top: 24,
                            left: 26,
                            child: widget.type == 'Music'
                              ? FutureBuilder<Map<String, dynamic>?>(
                                  future: _spotifyService.searchTrack(widget.title),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        width: 313,
                                        height: 176,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    if (snapshot.hasError || !snapshot.hasData) {
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
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.imageLink ?? '',
                                    width: 313,
                                    height: 176,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 313,
                                      height: 176,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 313,
                                      height: 176,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            widget.type == 'Book' ? Icons.book : Icons.error_outline,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.type == 'Book' ? 'Book cover not available' : 'Image not available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          // Description box background
                          Positioned(
                            top: 216,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 332,
                                height: 238,
                                child: SvgPicture.asset(
                                  'assets/images/desc_box.svg',
                                  width: 332,
                                  height: 238,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Title
                          Positioned(
                            top: widget.type == 'Book' ? 230 : widget.type == 'Cooking' ? 233 : widget.type == 'Workout' ? 222 : 222,
                            left: widget.type == 'Book' ? 34 : 37,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: widget.type == 'Book' ? 18 : widget.type == 'Cooking' ? 19 : widget.type == 'Workout' ? 19 : 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Subtitle
                          Positioned(
                            top: 256,
                            left: 37,
                            child: Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // About text
                          Positioned(
                            top: 279,
                            left: 37,
                            child: Text(
                              'About',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Description text
                          Positioned(
                            top: 296,
                            left: 37,
                            right: 37,
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                          // YouTube/Spotify/Book Button
                          if (widget.type != 'Travel') Positioned(
                            top: 394,
                            left: widget.type == 'Music' 
                              ? 117 
                              : widget.type == 'Book'
                                ? 128
                                : widget.type == 'Cooking'
                                  ? 119
                                  : widget.type == 'Meditation'
                                    ? 92
                                    : 92,
                            child: GestureDetector(
                              onTap: _launchTrailerUrl,
                              child: Container(
                                width: 203,
                                height: 42,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      widget.type == 'Music'
                                        ? 'assets/images/play_on_spotify_box.svg'
                                        : widget.type == 'Book'
                                          ? 'assets/images/get_the_book.svg'
                                          : widget.type == 'Cooking'
                                            ? 'assets/images/get_the_recipe.svg'
                                            : widget.type == 'Meditation'
                                              ? 'assets/images/watch_workout_ytb.svg'
                                              : 'assets/images/watch_workout_ytb.svg',
                                      width: 203,
                                      height: 42,
                                      fit: BoxFit.contain,
                                    ),
                                    // Icon
                                    Positioned(
                                      left: 13,
                                      top: 13,
                                      child: SvgPicture.asset(
                                        widget.type == 'Music'
                                          ? 'assets/images/spotify.svg'
                                          : widget.type == 'Book'
                                            ? 'assets/images/book_icon.svg'
                                            : widget.type == 'Cooking'
                                              ? 'assets/images/recipe_icon.svg'
                                              : 'assets/images/youtube.svg',
                                        width: widget.type == 'Music' ? 18 : 20,
                                        height: widget.type == 'Music' ? 18 : 16,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Text
                                    Positioned(
                                      left: 34,
                                      top: 13,
                                      child: Text(
                                        widget.type == 'Music'
                                          ? 'Play on Spotify'
                                          : widget.type == 'Book'
                                            ? 'Get the book'
                                            : widget.type == 'Cooking'
                                              ? 'Get the Recipe'
                                              : 'Watch it on YouTube',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Save Button
                          Positioned(
                            top: 394,
                            left: 256,
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  // Delete the item from Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userEmail)
                                      .collection('saved')
                                      .where('Title', isEqualTo: widget.title)
                                      .get()
                                      .then((snapshot) {
                                        if (snapshot.docs.isNotEmpty) {
                                          snapshot.docs.first.reference.delete();
                                        }
                                      });
                                  
                                  // Navigate back to saved screen
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => SavedScreen.builder(context),
                                    ),
                                    (route) => false,
                                  );
                                } catch (e) {
                                  print('Error deleting item: $e');
                                }
                              },
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/save_box2.svg',
                                    width: 78,
                                    height: 42,
                                    fit: BoxFit.contain,
                                  ),
                                  // Save Icon
                                  Positioned(
                                    left: 10,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/images/save_icon.svg',
                                        width: 21,
                                        height: 21,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  // Save Text
                                  Positioned(
                                    left: 35,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Text(
                                        'Saved',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                  builder: (context) => SavedScreen.builder(context),
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
