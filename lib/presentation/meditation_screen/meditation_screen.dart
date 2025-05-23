import 'dart:ui';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';
import 'provider/meditation_provider.dart';
import '../../widgets/unlock_slider.dart';
import '../log_screen/log_screen.dart';
import '../../core/services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import '../../services/remote_config_service.dart';

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

// Helper to fetch poster path from TMDb
Future<String?> fetchPosterPath(String title, String duration) async {
  try {
    // First try to get from local storage
    final prefs = await SharedPreferences.getInstance();
    final String? cachedPosterPath = prefs.getString('poster_${title}_$duration');
    
    if (cachedPosterPath != null) {
      debugPrint('Using cached poster path for $title: $cachedPosterPath');
      return cachedPosterPath;
    }

    // If not in cache, fetch from API
    final apiKey = 'd333a0b62b637851256f90a16c56f448';
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeComponent("peaceful nature " + title)}&include_adult=false',
    );
    
    debugPrint('Fetching nature image for: $title');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final results = data['results'] as List;
        debugPrint('Found ${results.length} results for $title');
        
        // Try to find a result with a backdrop
        for (var result in results) {
          final backdropPath = result['backdrop_path'];
          if (backdropPath != null && backdropPath.toString().isNotEmpty) {
            debugPrint('Found backdrop path: $backdropPath');
            // Cache the backdrop path
            await prefs.setString('poster_${title}_$duration', backdropPath);
            return backdropPath;
          }
        }
        
        // If no backdrop found, try poster_path as fallback
        for (var result in results) {
          final posterPath = result['poster_path'];
          if (posterPath != null && posterPath.toString().isNotEmpty) {
            debugPrint('No backdrop found, using poster path: $posterPath');
            await prefs.setString('poster_${title}_$duration', posterPath);
            return posterPath;
          }
        }
        
        debugPrint('No valid image path found for $title');
      } else {
        debugPrint('No results found for $title');
      }
    } else {
      debugPrint('Error fetching image data: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in fetchPosterPath: $e');
  }
  return null;
}

// Widget to display the poster
class MeditationPoster extends StatelessWidget {
  final String title;
  final String duration;

  const MeditationPoster({required this.title, required this.duration, Key? key}) : super(key: key);

  Future<bool> _verifyImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchPosterPath(title, duration),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 313,
            height: 176,
            child: Center(child: CupertinoActivityIndicator(color: Colors.white)),
          );
        }
        
        if (snapshot.hasError) {
          return _buildErrorContainer();
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          final posterUrl = 'https://image.tmdb.org/t/p/w780${snapshot.data}';
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 313,
              height: 176,
              child: FutureBuilder<bool>(
                future: _verifyImageUrl(posterUrl),
                builder: (context, verifySnapshot) {
                  if (verifySnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CupertinoActivityIndicator(color: Colors.white));
                  }
                  
                  if (verifySnapshot.hasData && verifySnapshot.data == true) {
                    return CachedNetworkImage(
                      imageUrl: posterUrl,
                      fit: BoxFit.cover,
                      width: 313,
                      height: 176,
                      memCacheWidth: 626,
                      memCacheHeight: 352,
                      maxWidthDiskCache: 626,
                      maxHeightDiskCache: 352,
                      fadeInDuration: Duration(milliseconds: 300),
                      placeholder: (context, url) => Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => _buildErrorContainer(),
                    );
                  } else {
                    return _buildErrorContainer();
                  }
                },
              ),
            ),
          );
        }
        
        return _buildErrorContainer();
      },
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
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  MeditationScreenState createState() => MeditationScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MeditationProvider(),
      child: const MeditationScreen(),
    );
  }
}

class MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
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
  String? _currentMeditationRecommendation;
  bool _isSaved = false;
  Map<String, Map<String, String>> _meditationInfoCache = {};
  final RemoteConfigService _remoteConfig = RemoteConfigService();

  Future<List<Map<String, dynamic>>> _searchVideos(String query) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=5&q=${Uri.encodeComponent(query)}&key=${_remoteConfig.getYoutubeApiKey()}'),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      if (response.statusCode == 403 && 
          errorData['error']?['status'] == 'PERMISSION_DENIED' &&
          errorData['error']?['details']?[0]?['reason'] == 'SERVICE_DISABLED') {
        print('⚠️ YouTube API is not enabled. Please enable it in the Google Cloud Console.');
        print('🔗 Visit: https://console.developers.google.com/apis/api/youtube.googleapis.com/overview?project=544663069826');
        return [];
      }
      print('❌ YouTube API error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return [];
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List<dynamic>;
    print('📊 Found ${items.length} videos');

    final videos = <Map<String, dynamic>>[];

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

      if (durationMinutes <= 20) {
        final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
        print('✅ Found suitable video: $videoUrl');
        videos.add({
          'id': videoId,
          'url': videoUrl,
          'duration': durationMinutes.toString(),
        });
      } else {
        print('⏰ Video too long: $durationMinutes minutes');
      }
    }

    print('📊 Found ${videos.length} suitable videos');
    return videos;
  }

  int _parseIsoDurationToMinutes(String isoDuration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?');
    final match = regex.firstMatch(isoDuration);
    if (match == null) return 0;

    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;

    return (hours * 60) + minutes;
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

  // Helper to extract all meditation information from AI response
  Future<Map<String, String>> extractMeditationInfo(String response) async {
    // Check cache first
    if (_meditationInfoCache.containsKey(response)) {
      print('📦 Using cached meditation info');
      return _meditationInfoCache[response]!;
    }

    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(response);
    final summaryMatch = RegExp(r'Summary:\s*(.*)').firstMatch(response);
    final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n|$)').firstMatch(response);
    
    final title = titleMatch?.group(1)?.trim() ?? '';
    final summary = summaryMatch?.group(1)?.trim() ?? '';
    final description = descriptionMatch?.group(1)?.trim() ?? '';
    
    // Search for a relevant meditation video
    final searchQuery = '$title guided meditation';
    print('🔍 Searching YouTube for: $searchQuery');
    final videos = await _searchVideos(searchQuery);
    
    if (videos.isNotEmpty) {
      print('🎥 Found YouTube videos');
      final video = videos[0];
      final videoUrl = video['url'];
      final durationMinutes = int.parse(video['duration']);
      print('⏱️ Video duration: $durationMinutes minutes');

      if (durationMinutes <= 20) {
        print('✅ Found suitable video: $videoUrl');
        final thumbnailUrl = getYouTubeThumbnail(videoUrl);
        print('🖼️ Thumbnail URL: $thumbnailUrl');

        // Check if thumbnail is accessible
        if (thumbnailUrl != null) {
          try {
            final response = await http.head(Uri.parse(thumbnailUrl));
            if (response.statusCode != 200) {
              print('❌ Thumbnail not accessible, requesting new recommendation');
              // Request new recommendation from the provider
              final provider = Provider.of<MeditationProvider>(context, listen: false);
              await provider.sendMessage('Please suggest a different meditation');
              return {};
            }
          } catch (e) {
            print('❌ Error checking thumbnail: $e');
            // Request new recommendation from the provider
            final provider = Provider.of<MeditationProvider>(context, listen: false);
            await provider.sendMessage('Please suggest a different meditation');
            return {};
          }
        }
      } else {
        print('⏰ Video too long: $durationMinutes minutes');
      }
    } else {
      print('❌ No suitable YouTube videos found');
    }
    
    String? imageUrl = videoUrl != null ? getYouTubeThumbnail(videoUrl) : null;
    
    final meditationInfo = {
      'title': title,
      'summary': summary,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'videoUrl': videoUrl ?? '',
    };

    // Cache the result
    _meditationInfoCache[response] = meditationInfo;

    // Check if this meditation is already saved
    try {
      final userData = await _userService.getCurrentUserData();
      if (userData != null && userData['email'] != null) {
        final userEmail = userData['email'] as String;
        final firestore = FirebaseFirestore.instance;
        
        final querySnapshot = await firestore
            .collection('users')
            .doc(userEmail)
            .collection('saved')
            .where('Title', isEqualTo: title)
            .get();

        if (mounted) {
          setState(() {
            _isSaved = querySnapshot.docs.isNotEmpty;
          });
        }
      }
    } catch (e) {
      print('❌ Error checking if meditation is saved: $e');
    }
    
    return meditationInfo;
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

    final provider = Provider.of<MeditationProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
        // Update the current meditation recommendation when a new message is added
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentMeditationRecommendation = lastMessage['content'];
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
            
            final provider = Provider.of<MeditationProvider>(context, listen: false);
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
    final provider = Provider.of<MeditationProvider>(context, listen: false);
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
    final provider = Provider.of<MeditationProvider>(context);
    
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
                        // Meditation recommendation overlay
                        if (_currentMeditationRecommendation != null)
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
                                    // Meditation time box background
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/movie_time_box.svg',
                                        width: 366,
                                        height: 491,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    // Content or Loading Indicator
                                    if (_currentMeditationRecommendation != null)
                                      FutureBuilder<Map<String, String>>(
                                        future: extractMeditationInfo(_currentMeditationRecommendation!),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    'Finding the perfect meditation...',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                              // Meditation title
                                              Positioned(
                                                top: 233,
                                                left: 36,
                                                child: Text(
                                                  info['title'] ?? '',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
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
                                              // YouTube Watch Button
                                              Positioned(
                                                top: 394,
                                                left: 92,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    print('Button pressed!');
                                                    _launchVideoUrl();
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
                                                        // Watch meditation text
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
                                                    if (_currentMeditationRecommendation != null) {
                                                      print('🧘 Current meditation recommendation exists');
                                                      
                                                      try {
                                                        // Update UI state immediately
                                                        setState(() {
                                                          _isSaved = !_isSaved;
                                                        });
                                                        print('🔄 Save button state updated immediately: $_isSaved');
                                                        
                                                        final info = await extractMeditationInfo(_currentMeditationRecommendation!);
                                                        print('📋 Meditation info extracted: $info');
                                                        
                                                        if (info.isEmpty) {
                                                          print('❌ Failed to extract meditation info');
                                                          setState(() {
                                                            _isSaved = !_isSaved; // Revert the state
                                                          });
                                                          return;
                                                        }
                                                        
                                                        if (!_isSaved) {  // Note: _isSaved is now the new state
                                                          // If now unsaved, remove it
                                                          await _removeMeditationFromFirestore(info);
                                                        } else {
                                                          // If now saved, save it
                                                          await _saveMeditationToFirestore(info);
                                                        }
                                                      } catch (e) {
                                                        print('❌ Error in save button handler: $e');
                                                        // Revert the state on error
                                                        setState(() {
                                                          _isSaved = !_isSaved;
                                                        });
                                                      }
                                                    } else {
                                                      print('❌ No current meditation recommendation');
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

  Future<void> _launchVideoUrl() async {
    if (_currentMeditationRecommendation == null) return;
    
    final meditationInfo = await extractMeditationInfo(_currentMeditationRecommendation!);
    final videoUrl = meditationInfo['videoUrl'];
    
    if (videoUrl != null && videoUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(videoUrl);
        
        final videoIdMatch = RegExp(r'(?:v=|/)([0-9A-Za-z_-]{11})(?:\?|&|$)').firstMatch(videoUrl);
        if (videoIdMatch != null) {
          final videoId = videoIdMatch.group(1);
          
          final youtubeUri = Uri.parse('youtube://${videoId}');
          if (await canLaunchUrl(youtubeUri)) {
            await launchUrl(youtubeUri);
            return;
          }
          
          final browserUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
          await launchUrl(
            browserUrl,
            mode: LaunchMode.platformDefault,
          );
          return;
        }
        
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        try {
          await launchUrl(
            Uri.parse(videoUrl),
            mode: LaunchMode.platformDefault,
          );
        } catch (e) {}
      }
    }
  }

  Future<void> _saveMeditationToFirestore(Map<String, String> info) async {
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
      
      // Get the saved meditations collection for the current user
      final savedMeditationsRef = userDocRef.collection('saved');
      print('🧘 Saved meditations collection reference created');

      // Get the current count of saved meditations to use as the new document ID
      final countSnapshot = await savedMeditationsRef.count().get();
      final newDocId = ((countSnapshot.count ?? 0) + 1).toString();
      print('🔢 New document ID: $newDocId');

      // Create the meditation document
      print('📝 Creating meditation document with data:');
      print('Title: ${info['title']}');
      print('Summary: ${info['summary']}');
      print('Description: ${info['description']}');
      print('YouTube Link: ${info['videoUrl']}');
      print('Image Link: ${info['imageUrl']}');
      
      await savedMeditationsRef.doc(newDocId).set({
        'Title': info['title'] ?? '',
        'Subtitle': info['summary'] ?? '',
        'Description': info['description'] ?? '',
        'Youtube Link': info['videoUrl'] ?? '',
        'Image Link': info['imageUrl'] ?? '',
        'type': 'Meditation',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('✅ Meditation saved successfully with ID: $newDocId');
    } catch (e, stackTrace) {
      print('❌ Error saving meditation: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _removeMeditationFromFirestore(Map<String, String> info) async {
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
      
      // Get reference to saved meditations collection
      final savedMeditationsRef = firestore
          .collection('users')
          .doc(userEmail)
          .collection('saved');

      // Query for the meditation with matching title
      final querySnapshot = await savedMeditationsRef
          .where('Title', isEqualTo: info['title'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first matching document
        await querySnapshot.docs.first.reference.delete();
        print('✅ Meditation removed successfully');
      } else {
        print('❌ No matching meditation found to remove');
      }
    } catch (e) {
      print('❌ Error removing meditation: $e');
    }
  }
}
