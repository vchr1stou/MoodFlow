import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? userEmail;
  bool _isInitialized = false;
  Map<String, dynamic>? _movieData;

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
    if (_movieData == null) return;
    
    final trailerUrl = _movieData!['Youtube Link'];
    if (trailerUrl != null && trailerUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(trailerUrl);
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
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userEmail)
                          .collection('saved')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final savedCount = snapshot.data!.docs.length;
                        
                        if (savedCount == 0) {
                          return SizedBox.shrink();
                        }

                        // Get the first movie data
                        final doc = snapshot.data!.docs[0];
                        _movieData = doc.data() as Map<String, dynamic>;

                        return Container(
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
                              // Movie poster image
                              Positioned(
                                top: 24,
                                left: 26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    _movieData!['Image Link'] ?? '',
                                    width: 313,
                                    height: 176,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                    },
                                    errorBuilder: (context, error, stackTrace) {
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
                                            Icon(Icons.error_outline, color: Colors.grey[600]),
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
                                      );
                                    },
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
                              // Movie title
                              Positioned(
                                top: 222,
                                left: 37,
                                child: Text(
                                  _movieData!['Title'] ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24,
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
                                  _movieData!['Subtitle'] ?? '',
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
                                  _movieData!['Description'] ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              // YouTube Watch Button
                              Positioned(
                                top: 394,
                                left: 45,
                                child: GestureDetector(
                                  onTap: _launchTrailerUrl,
                                  child: Container(
                                    width: 203,
                                    height: 42,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/watch_ytb.svg',
                                          width: 203,
                                          height: 42,
                                          fit: BoxFit.contain,
                                        ),
                                        // YouTube Icon
                                        Positioned(
                                          left: 10,
                                          top: 13,
                                          child: SvgPicture.asset(
                                            'assets/images/youtube.svg',
                                            width: 20,
                                            height: 16,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        // Watch trailer text
                                        Positioned(
                                          left: 34,
                                          top: 13,
                                          child: Text(
                                            'Watch the trailer on YouTube',
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
                                      // Delete the movie from Firebase
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userEmail)
                                          .collection('saved')
                                          .doc(doc.id)
                                          .delete();
                                      
                                      // Navigate back to saved screen
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => LittleLiftsScreen.builder(context),
                                        ),
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      print('Error deleting movie: $e');
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
                        );
                      },
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
