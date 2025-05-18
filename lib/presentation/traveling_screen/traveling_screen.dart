import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'dart:math' as math;
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
import '../../widgets/unlock_slider.dart';
import '../log_screen/log_screen.dart';
import '../../core/services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'provider/traveling_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

const String unsplashApiKey = 'eyfC5QB1_xUKVD3T4v1fBbFtxFrs514GA1WXTUsFHvg';

Future<String?> getUnsplashImage(String query) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/search/photos?query=$query&orientation=landscape&per_page=1&client_id=$unsplashApiKey'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]['urls']['regular'];
      }
    }
  } catch (e) {
    print('Error fetching Unsplash image: $e');
  }
  return null;
}

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
      Radius.circular(isKeyboardOpen ? 0 : 0),
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

class TravelingScreen extends StatefulWidget {
  const TravelingScreen({Key? key}) : super(key: key);

  @override
  _TravelingScreenState createState() => _TravelingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TravelingProvider(),
      child: const TravelingScreen(),
    );
  }
}

class _TravelingScreenState extends State<TravelingScreen> with SingleTickerProviderStateMixin {
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
  String? _currentTravelRecommendation;
  bool _isSaved = false;

  // Helper to extract all travel information from AI response
  Map<String, String> extractTravelInfo(String response) {
    debugPrint('🔍 [AI Response] Raw response: $response');
    
    // Updated regex patterns to match the exact format
    final titleMatch = RegExp(r'Title:\s*([^\n]+)').firstMatch(response);
    final summaryMatch = RegExp(r'Summary:\s*([^\n]+)').firstMatch(response);
    final descriptionMatch = RegExp(r'Description:\s*([^\n]+)').firstMatch(response);
    
    final info = {
      'title': titleMatch?.group(1)?.trim() ?? '',
      'location': summaryMatch?.group(1)?.trim() ?? '',
      'description': descriptionMatch?.group(1)?.trim() ?? '',
      'bestTime': 'Year-round',
      'photoUrl': '',  // Will be set by FutureBuilder
      'link': '',
    };
    
    debugPrint('🔍 [AI Response] Extracted info: $info');
    return info;
  }

  Future<void> _launchTravelLink() async {
    if (_currentTravelRecommendation == null) return;
    
    debugPrint('🔗 [Travel Link] Current recommendation: $_currentTravelRecommendation');
    final travelInfo = extractTravelInfo(_currentTravelRecommendation!);
    final link = travelInfo['link'];
    
    debugPrint('🔗 [Travel Link] Attempting to launch: $link');
    if (link != null && link.isNotEmpty) {
      try {
        await launchUrl(
          Uri.parse(link),
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        debugPrint('❌ [Travel Link] Error launching URL: $e');
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

    final provider = Provider.of<TravelingProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
        // Update the current travel recommendation when a new message is added
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentTravelRecommendation = lastMessage['content'];
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
            
            final provider = Provider.of<TravelingProvider>(context, listen: false);
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
    final provider = Provider.of<TravelingProvider>(context, listen: false);
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
    final provider = Provider.of<TravelingProvider>(context);
    
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
            Positioned.fill(
              child: GlowEffect(isKeyboardOpen: _focusNode.hasFocus),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (_currentTravelRecommendation != null)
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
                                    // Movie time box background
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/movie_time_box.svg',
                                        width: 366,
                                        height: 491,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Description box background
                                    Positioned(
                                      top: 216, // 12px below the poster (176 + 24 + 12)
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
                                    if (_currentTravelRecommendation != null)
                                      Positioned(
                                        top: 24,
                                        left: 26,
                                        child: Builder(
                                          builder: (context) {
                                            final info = extractTravelInfo(_currentTravelRecommendation!);
                                            return FutureBuilder<String?>(
                                              future: getUnsplashImage(info['title'] ?? ''),
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
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          CupertinoActivityIndicator(
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(height: 16),
                                                          Text(
                                                            'Finding the perfect destination...',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                                
                                                final String? imageUrl = snapshot.data;
                                                
                                                if (imageUrl == null) {
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
                                                }
                                                
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl,
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
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            CupertinoActivityIndicator(
                                                              color: Colors.white,
                                                            ),
                                                            SizedBox(height: 16),
                                                            Text(
                                                              'Finding the perfect destination...',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
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
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    // Title
                                    Positioned(
                                      top: 230,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractTravelInfo(_currentTravelRecommendation!);
                                          final title = info['title'] ?? '';
                                          // Replace comma with bullet point
                                          final formattedTitle = title.replaceAll(',', ' ·');
                                          return Text(
                                            formattedTitle,
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
                                    // Location
                                    Positioned(
                                      top: 264,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractTravelInfo(_currentTravelRecommendation!);
                                          return Text(
                                            info['location'] ?? '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // About text
                                    Positioned(
                                      top: 284,
                                      left: 37,
                                      child: Text(
                                        'About',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // Description
                                    Positioned(
                                      top: 304,
                                      left: 37,
                                      right: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractTravelInfo(_currentTravelRecommendation!);
                                          return Text(
                                            info['description'] ?? '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height: 1.4,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Save Box Button
                                    Positioned(
                                      top: 394,
                                      left: 256,
                                      child: GestureDetector(
                                        onTap: () async {
                                          print('🔘 Save button tapped');
                                          if (_currentTravelRecommendation != null) {
                                            print('✈️ Current travel recommendation exists');
                                            
                                            // Update UI state immediately
                                            setState(() {
                                              _isSaved = !_isSaved;
                                            });
                                            print('🔄 Save button state updated immediately: $_isSaved');
                                            
                                            final info = extractTravelInfo(_currentTravelRecommendation!);
                                            print('📋 Travel info extracted: $info');
                                            
                                            if (!_isSaved) {  // Note: _isSaved is now the new state
                                              // If now unsaved, remove it
                                              await _removeTravelFromFirestore(info);
                                            } else {
                                              // If now saved, save it
                                              final imageUrl = await getUnsplashImage(info['title'] ?? '');
                                              print('🖼️ Image URL: $imageUrl');
                                              await _saveTravelToFirestore(info, imageUrl ?? '');
                                            }
                                          } else {
                                            print('❌ No current travel recommendation');
                                          }
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
                              ? 15.0
                              : (provider.messages.isEmpty 
                                  ? -30.0
                                  : (provider.showChat ? -30.0 : -30.0)),
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

  Future<void> _saveTravelToFirestore(Map<String, String> info, String imageUrl) async {
    try {
      print('🔄 Starting save process...');
      
      // Get current user's email
      final userData = await _userService.getCurrentUserData();
      print('👤 User data: $userData');
      
      if (userData == null || userData['email'] == null) {
        print('❌ No user email found');
        return;
      }

      final userEmail = userData['email'] as String;
      print('📧 User email: $userEmail');
      
      final firestore = FirebaseFirestore.instance;
      
      // Get reference to user document
      final userDocRef = firestore.collection('users').doc(userEmail);
      print('📄 User document reference created');
      
      // Check if user document exists, if not create it
      final userDoc = await userDocRef.get();
      print('🔍 User document exists: ${userDoc.exists}');
      
      if (!userDoc.exists) {
        print('📝 Creating new user document...');
        await userDocRef.set({
          'email': userEmail,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('✅ User document created');
      }
      
      // Get the saved travels collection for the current user
      final savedTravelsRef = userDocRef.collection('saved');
      print('✈️ Saved travels collection reference created');

      // Get the current count of saved travels to use as the new document ID
      final countSnapshot = await savedTravelsRef.count().get();
      final newDocId = ((countSnapshot.count ?? 0) + 1).toString();
      print('🔢 New document ID: $newDocId');

      // Create the travel document
      print('📝 Creating travel document with data:');
      print('Title: ${info['title']}');
      print('Subtitle: ${info['location']}');
      print('Description: ${info['description']}');
      print('Image Link: $imageUrl');
      
      await savedTravelsRef.doc(newDocId).set({
        'Title': info['title'] ?? '',
        'Subtitle': info['location'] ?? '',
        'Description': info['description'] ?? '',
        'Image Link': imageUrl,
        'type': 'Travel',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Travel saved successfully with ID: $newDocId');
    } catch (e, stackTrace) {
      print('❌ Error saving travel: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _removeTravelFromFirestore(Map<String, String> info) async {
    try {
      print('🔄 Starting remove process...');
      
      // Get current user's email
      final userData = await _userService.getCurrentUserData();
      if (userData == null || userData['email'] == null) {
        print('❌ No user email found');
        return;
      }

      final userEmail = userData['email'] as String;
      final firestore = FirebaseFirestore.instance;
      
      // Get reference to saved travels collection
      final savedTravelsRef = firestore
          .collection('users')
          .doc(userEmail)
          .collection('saved');

      // Query for the travel with matching title
      final querySnapshot = await savedTravelsRef
          .where('Title', isEqualTo: info['title'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first matching document
        await querySnapshot.docs.first.reference.delete();
        print('✅ Travel removed successfully');
      } else {
        print('❌ No matching travel found to remove');
      }
    } catch (e) {
      print('❌ Error removing travel: $e');
    }
  }
}

/// Checks if a given image URL is valid and approximately landscape (e.g., width > height).
Future<bool> isLandscapeImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final image = img.decodeImage(bytes);
      if (image != null) {
        final width = image.width;
        final height = image.height;
        return width > height;
      }
    }
  } catch (e) {
    print('Error validating image: $e');
  }
  return false;
}
