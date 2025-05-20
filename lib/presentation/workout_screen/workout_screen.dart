import 'dart:ui';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../core/app_export.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'provider/workout_provider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_service.dart';
import '../../services/remote_config_service.dart';

class GlowEffect extends StatefulWidget {
  final bool isKeyboardOpen;
  
  const GlowEffect({Key? key, required this.isKeyboardOpen}) : super(key: key);

  @override
  State<GlowEffect> createState() => _GlowEffectState();
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
    
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: colors.map((c) => c.withOpacity(0.8)).toList(),
        stops: stops,
        transform: GradientRotation(animation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 35);

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(-0.2),
      Radius.circular(isKeyboardOpen ? 0 : 0),
    );
    canvas.drawRRect(rrect, gradientPaint);

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

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  WorkoutScreenState createState() => WorkoutScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutProvider(),
      child: const WorkoutScreen(),
    );
  }
}

class WorkoutScreenState extends State<WorkoutScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isManualStop = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  ScrollController _scrollController = ScrollController();
  bool _showChat = false;
  String? _currentWorkoutRecommendation;
  bool _isSaved = false;
  Map<String, Map<String, String>> _workoutInfoCache = {};
  final RemoteConfigService _remoteConfig = RemoteConfigService();

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

  Future<String?> fetchWorkoutVideo({
    required String query,
    int maxDurationMinutes = 30,
  }) async {
    print('🌐 Making YouTube API request for: $query');
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=5&q=${Uri.encodeComponent(query)}&key=${_remoteConfig.getYoutubeApiKey()}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        if (response.statusCode == 403 && 
            errorData['error']?['status'] == 'PERMISSION_DENIED' &&
            errorData['error']?[0]?['details']?[0]?['reason'] == 'SERVICE_DISABLED') {
          print('⚠️ YouTube API is not enabled. Please enable it in the Google Cloud Console.');
          print('🔗 Visit: https://console.developers.google.com/apis/api/youtube.googleapis.com/overview?project=544663069826');
          return null;
        }
        print('❌ YouTube API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }

      final data = jsonDecode(response.body);
      final items = data['items'] as List<dynamic>;
      print('📊 Found ${items.length} videos');

      for (final item in items) {
        final videoId = item['id']['videoId'];
        print('🔎 Checking video: $videoId');
        
        final durationUrl = Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoId&key=${_remoteConfig.getYoutubeApiKey()}',
        );
        final durationResponse = await http.get(durationUrl);
        if (durationResponse.statusCode != 200) {
          print('❌ Duration API error for video $videoId: ${durationResponse.statusCode}');
          continue;
        }

        final durationData = jsonDecode(durationResponse.body);
        final details = durationData['items'] as List<dynamic>;
        if (details.isEmpty) {
          print('❌ No duration details for video $videoId');
          continue;
        }

        final isoDuration = details[0]['contentDetails']['duration'];
        final durationMinutes = _parseIsoDurationToMinutes(isoDuration);
        print('⏱️ Video duration: $durationMinutes minutes');

        if (durationMinutes <= maxDurationMinutes) {
          final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
          print('✅ Found suitable video: $videoUrl');
          return videoUrl;
        } else {
          print('⏰ Video too long: $durationMinutes minutes');
        }
      }

      print('❌ No suitable videos found within duration limit');
      return null;
    } catch (e) {
      print('❌ Error fetching YouTube video: $e');
      return null;
    }
  }

  int _parseIsoDurationToMinutes(String isoDuration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
    final match = regex.firstMatch(isoDuration);
    if (match == null) return 0;

    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;

    return (hours * 60) + minutes;
  }

  Future<Map<String, String>> extractWorkoutInfo(String response) async {
    // Check cache first
    if (_workoutInfoCache.containsKey(response)) {
      print('📦 Using cached workout info');
      return _workoutInfoCache[response]!;
    }

    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(response);
    final summaryMatch = RegExp(r'Summary:\s*(.*)').firstMatch(response);
    final typeMatch = RegExp(r'Type:\s*(.*)').firstMatch(response);
    final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n|$)').firstMatch(response);
    
    final title = titleMatch?.group(1)?.trim() ?? '';
    final summary = summaryMatch?.group(1)?.trim() ?? '';
    final type = typeMatch?.group(1)?.trim() ?? '';
    final description = descriptionMatch?.group(1)?.trim() ?? '';
    
    // Search for a relevant workout video
    final searchQuery = '$title $type workout';
    print('🔍 Searching YouTube for: $searchQuery');
    final videoUrl = await fetchWorkoutVideo(query: searchQuery);
    
    if (videoUrl != null) {
      print('🎥 Found YouTube video: $videoUrl');
      final thumbnailUrl = getYouTubeThumbnail(videoUrl);
      print('🖼️ Thumbnail URL: $thumbnailUrl');
    } else {
      print('❌ No suitable YouTube video found');
    }
    
    String? imageUrl = videoUrl != null ? getYouTubeThumbnail(videoUrl) : null;
    
    final workoutInfo = {
      'title': title,
      'summary': summary,
      'type': type,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'videoUrl': videoUrl ?? '',
    };

    // Cache the result
    _workoutInfoCache[response] = workoutInfo;
    
    return workoutInfo;
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

    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentWorkoutRecommendation = lastMessage['content'];
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
            
            final provider = Provider.of<WorkoutProvider>(context, listen: false);
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
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
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
    final provider = Provider.of<WorkoutProvider>(context);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LittleLiftsScreen.builder(context),
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
                        // Workout recommendation overlay
                        if (_currentWorkoutRecommendation != null)
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
                                    // Workout box background
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/movie_time_box.svg',
                                        width: 366,
                                        height: 491,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Content or Loading Indicator
                                    if (_currentWorkoutRecommendation != null)
                                      FutureBuilder<Map<String, String>>(
                                        future: extractWorkoutInfo(_currentWorkoutRecommendation!),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: CupertinoActivityIndicator(color: Colors.white),
                                            );
                                          }
                                          
                                          final info = snapshot.data!;
                                          return Stack(
                                            children: [
                                              // Workout image
                                              Positioned(
                                                top: 24,
                                                left: 26,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: CachedNetworkImage(
                                                    imageUrl: info['imageUrl'] ?? '',
                                                    width: 313,
                                                    height: 176,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Container(
                                                      width: 313,
                                                      height: 176,
                                                      color: Colors.grey[300],
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
                                              // Workout title
                                              Positioned(
                                                top: 222,
                                                left: 37,
                                                child: Text(
                                                  info['title'] ?? '',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              // Summary
                                              Positioned(
                                                top: 256,
                                                left: 37,
                                                child: Text(
                                                  info['summary'] ?? '',
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
                                                top: 279,
                                                left: 37,
                                                right: 37,
                                                child: Text(
                                                  info['description'] ?? '',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                              // Start Workout Button
                                              Positioned(
                                                top: 394,
                                                left: 92,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final videoUrl = info['videoUrl'];
                                                    if (videoUrl != null && videoUrl.isNotEmpty) {
                                                      final Uri url = Uri.parse(videoUrl);
                                                      if (await canLaunchUrl(url)) {
                                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 203,
                                                    height: 42,
                                                    child: Stack(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/images/watch_workout_ytb.svg',
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
                                                            'Watch it on YouTube',
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
                                                  onTap: () async {
                                                    print('🔘 Save button tapped');
                                                    if (_currentWorkoutRecommendation != null) {
                                                      print('💪 Current workout recommendation exists');
                                                      
                                                      // Update UI state immediately
                                                      setState(() {
                                                        _isSaved = !_isSaved;
                                                      });
                                                      print('🔄 Save button state updated immediately: $_isSaved');
                                                      
                                                      final info = await extractWorkoutInfo(_currentWorkoutRecommendation!);
                                                      print('📋 Workout info extracted: $info');
                                                      
                                                      if (!_isSaved) {  // Note: _isSaved is now the new state
                                                        // If now unsaved, remove it
                                                        await _removeWorkoutFromFirestore(info);
                                                      } else {
                                                        // If now saved, save it
                                                        await _saveWorkoutToFirestore(info);
                                                      }
                                                    } else {
                                                      print('❌ No current workout recommendation');
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
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // Chat messages
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

  Widget _buildWorkoutImage(BuildContext context, String? recommendation) {
    if (recommendation == null) return Container();
    return Container(); // This is now handled in the main FutureBuilder
  }

  Widget _buildWorkoutTitle(BuildContext context, String? recommendation) {
    if (recommendation == null) return Container();
    return Container(); // This is now handled in the main FutureBuilder
  }

  Widget _buildWorkoutSummary(BuildContext context, String? recommendation) {
    if (recommendation == null) return Container();
    return Container(); // This is now handled in the main FutureBuilder
  }

  Widget _buildWorkoutDescription(BuildContext context, String? recommendation) {
    if (recommendation == null) return Container();
    return Container(); // This is now handled in the main FutureBuilder
  }

  Future<void> _saveWorkoutToFirestore(Map<String, String> info) async {
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
      
      // Get the saved workouts collection for the current user
      final savedWorkoutsRef = userDocRef.collection('saved');
      print('💪 Saved workouts collection reference created');

      // Get the current count of saved workouts to use as the new document ID
      final countSnapshot = await savedWorkoutsRef.count().get();
      final newDocId = ((countSnapshot.count ?? 0) + 1).toString();
      print('🔢 New document ID: $newDocId');

      // Create the workout document
      print('📝 Creating workout document with data:');
      print('Title: ${info['title']}');
      print('Summary: ${info['summary']}');
      print('Description: ${info['description']}');
      print('YouTube Link: ${info['videoUrl']}');
      print('Image Link: ${info['imageUrl']}');
      
      await savedWorkoutsRef.doc(newDocId).set({
        'Title': info['title'] ?? '',
        'Subtitle': info['summary'] ?? '',
        'Description': info['description'] ?? '',
        'Youtube Link': info['videoUrl'] ?? '',
        'Image Link': info['imageUrl'] ?? '',
        'type': 'Workout',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Workout saved successfully with ID: $newDocId');
    } catch (e, stackTrace) {
      print('❌ Error saving workout: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _removeWorkoutFromFirestore(Map<String, String> info) async {
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
      
      // Get reference to saved workouts collection
      final savedWorkoutsRef = firestore
          .collection('users')
          .doc(userEmail)
          .collection('saved');

      // Query for the workout with matching title
      final querySnapshot = await savedWorkoutsRef
          .where('Title', isEqualTo: info['title'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first matching document
        await querySnapshot.docs.first.reference.delete();
        print('✅ Workout removed successfully');
      } else {
        print('❌ No matching workout found to remove');
      }
    } catch (e) {
      print('❌ Error removing workout: $e');
    }
  }
} 