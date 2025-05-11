import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../homescreen_screen/homescreen_screen.dart';
import '../../services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../log_input_screen/log_input_screen.dart';
import '../../core/app_export.dart';
import 'package:provider/provider.dart';
import 'provider/music_provider.dart';
import '../../widgets/unlock_slider.dart';
import '../log_screen/log_screen.dart';
import '../../core/services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import '../../widgets/album_landscape_card.dart';

class GlowPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  final List<double> stops;
  final bool isKeyboardOpen;

  GlowPainter({
    required this.animation,
    required this.colors,
    required this.stops,
    required this.isKeyboardOpen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Create the gradient paint
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: colors.map((c) => c.withOpacity(0.8)).toList(),
        stops: stops,
        transform: GradientRotation(animation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 35);

    // Draw the main glow with conditional corner radius
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(-0.2),
      Radius.circular(isKeyboardOpen ? 0 : 47.33),
    );
    canvas.drawRRect(rrect, gradientPaint);

    // Draw an inner stroke with conditional corner radius
    final innerPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: stops,
        transform: GradientRotation(animation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawRRect(rrect, innerPaint);
  }

  @override
  bool shouldRepaint(GlowPainter oldDelegate) {
    return animation != oldDelegate.animation ||
           stops != oldDelegate.stops ||
           isKeyboardOpen != oldDelegate.isKeyboardOpen;
  }
}

class GlowEffect extends StatefulWidget {
  final bool isKeyboardOpen;
  
  const GlowEffect({Key? key, required this.isKeyboardOpen}) : super(key: key);

  @override
  State<GlowEffect> createState() => _GlowEffectState();
}

class ListTween extends Tween<List<double>> {
  ListTween({required List<double> begin, required List<double> end})
      : super(begin: begin, end: end);

  @override
  List<double> lerp(double t) {
    if (begin == null || end == null) return [];
    return List.generate(
      begin!.length,
      (i) => begin![i] + (end![i] - begin![i]) * t,
    );
  }
}

class _GlowEffectState extends State<GlowEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Color> _colors = [
    Color(0xFFBC82F3),
    Color(0xFFF5B9EA),
    Color(0xFF8D9FFF),
    Color(0xFFFF6778),
    Color(0xFFFFBA71),
    Color(0xFFC686FF),
  ];
  
  // Fixed stops for consistent gradient
  final List<double> _fixedStops = [
    0.0,
    0.2,
    0.4,
    0.6,
    0.8,
    1.0,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowPainter(
            animation: _animation.value,
            colors: _colors,
            stops: _fixedStops,
            isKeyboardOpen: widget.isKeyboardOpen,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  MusicScreenState createState() => MusicScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: const MusicScreen(),
    );
  }
}

class MusicScreenState extends State<MusicScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  String? _userName;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isManualStop = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  ScrollController _scrollController = ScrollController();
  bool _showChat = false;
  String? _currentMusicRecommendation;
  bool _isSaved = false;

  // Helper to extract all music information from AI response
  Map<String, String> extractMusicInfo(String response) {
    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(response);
    final artistMatch = RegExp(r'Artist:\s*(.*)').firstMatch(response);
    final albumMatch = RegExp(r'Album:\s*(.*)').firstMatch(response);
    final yearMatch = RegExp(r'Year:\s*(\d{4})').firstMatch(response);
    final genreMatch = RegExp(r'Genre:\s*(.*)').firstMatch(response);
    final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n|$)').firstMatch(response);
    final spotifyMatch = RegExp(r'Spotify:\s*(.*)').firstMatch(response);
    final albumArtMatch = RegExp(r'Album Art:\s*(.*)').firstMatch(response);
    
    return {
      'title': titleMatch?.group(1)?.trim() ?? '',
      'artist': artistMatch?.group(1)?.trim() ?? '',
      'album': albumMatch?.group(1)?.trim() ?? '',
      'year': yearMatch?.group(1)?.trim() ?? '',
      'genre': genreMatch?.group(1)?.trim() ?? '',
      'description': descriptionMatch?.group(1)?.trim() ?? '',
      'spotifyUrl': spotifyMatch?.group(1)?.trim() ?? '',
      'albumArtUrl': albumArtMatch?.group(1)?.trim() ?? '',
    };
  }

  Future<void> _launchSpotifyUrl() async {
    if (_currentMusicRecommendation == null) return;
    
    final provider = Provider.of<MusicProvider>(context, listen: false);
    final trackInfo = provider.currentTrackInfo;
    
    if (trackInfo != null && trackInfo['spotifyUrl'] != null) {
      try {
        final uri = Uri.parse(trackInfo['spotifyUrl']!);
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        debugPrint('Error launching Spotify URL: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _isTyping = false;
        if (mounted) setState(() {});
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
    _loadUserName();
    _speech = stt.SpeechToText();
    
    _breathingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5)
      .animate(CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ));
    
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    final provider = Provider.of<MusicProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
        // Update the current music recommendation when a new message is added
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentMusicRecommendation = lastMessage['content'];
          }
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    };

    setState(() {
      _showChat = true;
    });
  }

  Future<void> _loadUserName() async {
    final userData = await _userService.getCurrentUserData();
    if (userData != null) {
      setState(() {
        _userName = userData['name'] as String? ?? 'User';
      });
    } else {
      setState(() {
        _userName = 'User';
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (!_isManualStop) {
              setState(() {
                _isListening = false;
              });
              _breathingController.stop();
            }
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() {
            _isListening = false;
            _isManualStop = false;
          });
          _breathingController.stop();
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _isManualStop = false;
        });
        _breathingController.forward();
        
        await _speech.listen(
          onResult: (result) {
            if (!mounted || _isManualStop) return;
            
            final provider = Provider.of<MusicProvider>(context, listen: false);
            setState(() {
              provider.messageController.text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 8),
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.dictation,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _isManualStop = true;
      });
      _breathingController.stop();
      await _speech.stop();
    }
  }

  void _sendMessage() {
    final provider = Provider.of<MusicProvider>(context, listen: false);
    if (provider.messageController.text.trim().isEmpty) return;
    
    final userMessage = provider.messageController.text.trim();
    provider.messageController.clear();
    setState(() {
      _isTyping = false;
    });

    _focusNode.unfocus();
    provider.sendMessage(userMessage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _breathingController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomescreenScreen.builder(context),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
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
            // Glow Effect
            Positioned.fill(
              child: GlowEffect(isKeyboardOpen: _focusNode.hasFocus),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Music recommendation overlay
                        if (_currentMusicRecommendation != null)
                          Positioned(
                            top: 120.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 366,
                                height: 491,
                                child: Stack(
                                  children: [
                                    // Music time box background
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/movie_time_box.svg',
                                        width: 366,
                                        height: 491,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Album art image
                                    if (_currentMusicRecommendation != null)
                                      Positioned(
                                        top: 24,
                                        left: 26,
                                        child: Builder(
                                          builder: (context) {
                                            final provider = Provider.of<MusicProvider>(context);
                                            final trackInfo = provider.currentTrackInfo;
                                            
                                            if (trackInfo != null) {
                                              return AlbumLandscapeCard(
                                                imageUrl: trackInfo['albumArtUrl'] ?? '',
                                                title: trackInfo['name'] ?? '',
                                                artist: trackInfo['artists'] ?? '',
                                              );
                                            }
                                            
                                            // Fallback to the old way if track info is not available
                                            final info = extractMusicInfo(_currentMusicRecommendation!);
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                imageUrl: info['albumArtUrl'] ?? '',
                                                width: 313,
                                                height: 176,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Center(
                                                  child: CupertinoActivityIndicator(),
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
                                                      Icon(Icons.image_not_supported, color: Colors.grey[600]),
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
                                              ),
                                            );
                                          },
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
                                    // Song title
                                    Positioned(
                                      top: 222,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractMusicInfo(_currentMusicRecommendation!);
                                          return Text(
                                            info['title'] ?? '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Artist and Album info
                                    Positioned(
                                      top: 256,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractMusicInfo(_currentMusicRecommendation!);
                                          return Text(
                                            '${info['artist']} · ${info['album']} (${info['year']})',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
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
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractMusicInfo(_currentMusicRecommendation!);
                                          return Text(
                                            info['description'] ?? '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height: 1.4,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Spotify Play Button
                                    Positioned(
                                      top: 394,
                                      left: 117,
                                      child: GestureDetector(
                                        onTap: _launchSpotifyUrl,
                                        child: Container(
                                          width: 203,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/play_on_spotify_box.svg',
                                                width: 203,
                                                height: 42,
                                                fit: BoxFit.contain,
                                              ),
                                              // Spotify Icon
                                              Positioned(
                                                left: 13,
                                                top: 13,
                                                child: SvgPicture.asset(
                                                  'assets/images/spotify.svg',
                                                  width: 18,
                                                  height: 18,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              // Play on Spotify text
                                              Positioned(
                                                left: 34,
                                                top: 13,
                                                child: Text(
                                                  'Play on Spotify',
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
                                    // Save Box Button
                                    Positioned(
                                      top: 394,
                                      left: 256,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isSaved = !_isSaved;
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            SvgPicture.asset(
                                              _isSaved ? 'assets/images/save_box2.svg' : 'assets/images/save_box.svg',
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
                                                  _isSaved ? 'Saved' : 'Save',
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
                            ),
                          ),
                        // Chat messages (show only the welcome message)
                        if (provider.showChat && provider.messages.isNotEmpty)
                          Positioned(
                            top: 0.h,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                reverse: false,
                                padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Only show the first message (welcome message)
                                    if (provider.messages.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: Column(
                                          children: [
                                            BubbleSpecialThree(
                                              text: provider.messages[0]['content'] ?? '',
                                              color: Color(0xFFF5B9EA).withOpacity(0.3),
                                              tail: true,
                                              isSender: false,
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // User greeting text
                        if (!provider.showChat && !_isTyping)
                          Positioned(
                            top: 80,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                'How are you feeling\nnow, ${_userName ?? 'User'}?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                        // Input box
                        Positioned(
                          bottom: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 15.0  // Higher position when keyboard is present
                              : (provider.messages.isEmpty 
                                  ? -30.0  // Lower position when no messages
                                  : (provider.showChat ? -30.0 : -30.0)),  // Keep it low in other states
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                                  ? 8
                                  : 30 + MediaQuery.of(context).padding.bottom,
                              top: 8,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (!_isTyping) {
                                    setState(() {
                                      _isTyping = true;
                                    });
                                    _focusNode.requestFocus();
                                  }
                                },
                                child: Container(
                                  width: 372,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: -1,
                                        blurRadius: 30,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Text box background
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/images/text_box.svg',
                                          width: 372,
                                          height: 44,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      // Mic Button with animation
                                      Positioned(
                                        left: 30,
                                        top: (44 - 28) / 2,
                                        child: GestureDetector(
                                          onTap: _listen,
                                          child: Stack(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/mic_button.svg',
                                                width: 28,
                                                height: 28,
                                                fit: BoxFit.contain,
                                              ),
                                              if (_isListening)
                                                Positioned.fill(
                                                  child: IgnorePointer(
                                                    child: AnimatedBuilder(
                                                      animation: _breathingAnimation,
                                                      builder: (context, child) {
                                                        return Container(
                                                          width: 28,
                                                          height: 28,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: Color(0xE2917D),
                                                              width: 1.5 * _breathingAnimation.value,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(0xE2917D).withOpacity(0.5),
                                                                blurRadius: 4.0 * _breathingAnimation.value,
                                                                spreadRadius: 1.0 * _breathingAnimation.value,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Send Button
                                      Positioned(
                                        right: 13,
                                        top: 1,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (provider.messageController.text.trim().isNotEmpty) {
                                              _sendMessage();
                                              _focusNode.unfocus();
                                              setState(() {
                                                _isTyping = false;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 49,
                                            height: 49,
                                            color: Colors.transparent,
                                            child: SvgPicture.asset(
                                              'assets/images/send_button.svg',
                                              width: 49,
                                              height: 49,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Text input field
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: _isTyping
                                            ? Container(
                                                width: 372,
                                                height: 44,
                                                child: TextField(
                                                  controller: provider.messageController,
                                                  focusNode: _focusNode,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFFFFFFFF).withOpacity(0.75),
                                                    height: 1.0,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: 65, right: 65, top: 12),
                                                    hintText: '',
                                                    isDense: true,
                                                    isCollapsed: true,
                                                  ),
                                                  onSubmitted: (text) {
                                                    if (text.trim().isNotEmpty) {
                                                      _sendMessage();
                                                      _focusNode.unfocus();
                                                    }
                                                  },
                                                ),
                                              )
                                            : Container(),
                                      ),
                                      // Static text overlay
                                      if (!_isTyping)
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 65),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                provider.messageController.text.isEmpty ? 'Ask me anything' : provider.messageController.text,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFFFFFFFF).withOpacity(0.75),
                                                  height: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
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
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27.h,
                height: 27.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
