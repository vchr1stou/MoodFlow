import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
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
import 'provider/movies_provider.dart';
import '../../widgets/unlock_slider.dart';
import '../log_screen/log_screen.dart';
import '../../core/services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

// Helper to fetch poster path from TMDb
Future<String?> fetchPosterPath(String title, String year) async {
  try {
    // First try to get from local storage
    final prefs = await SharedPreferences.getInstance();
    final String? cachedPosterPath = prefs.getString('poster_${title}_$year');
    
    if (cachedPosterPath != null) {
      debugPrint('Using cached poster path for $title: $cachedPosterPath');
      return cachedPosterPath;
    }

    // If not in cache, fetch from API
    final apiKey = 'd333a0b62b637851256f90a16c56f448';
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(title)}&year=$year&include_adult=false',
    );
    
    debugPrint('Fetching movie data for: $title ($year)');
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
            await prefs.setString('poster_${title}_$year', backdropPath);
            return backdropPath;
          }
        }
        
        // If no backdrop found, try poster_path as fallback
        for (var result in results) {
          final posterPath = result['poster_path'];
          if (posterPath != null && posterPath.toString().isNotEmpty) {
            debugPrint('No backdrop found, using poster path: $posterPath');
            await prefs.setString('poster_${title}_$year', posterPath);
            return posterPath;
          }
        }
        
        debugPrint('No valid image path found for $title');
      } else {
        debugPrint('No results found for $title');
      }
    } else {
      debugPrint('Error fetching movie data: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in fetchPosterPath: $e');
  }
  return null;
}

// Widget to display the poster
class MoviePoster extends StatelessWidget {
  final String title;
  final String year;

  const MoviePoster({required this.title, required this.year, Key? key}) : super(key: key);

  Future<bool> _verifyImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      debugPrint('Image URL verification status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error verifying image URL: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchPosterPath(title, year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 313,
            height: 176,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          debugPrint('Error loading poster for $title: ${snapshot.error}');
          return _buildErrorContainer();
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          final posterUrl = 'https://image.tmdb.org/t/p/w780${snapshot.data}';
          debugPrint('Loading image from URL: $posterUrl');
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 313,
              height: 176,
              color: Colors.black,
              child: FutureBuilder<bool>(
                future: _verifyImageUrl(posterUrl),
                builder: (context, verifySnapshot) {
                  if (verifySnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  
                  if (verifySnapshot.hasData && verifySnapshot.data == true) {
                    return CachedNetworkImage(
                      imageUrl: posterUrl,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      memCacheWidth: 626,
                      memCacheHeight: 352,
                      maxWidthDiskCache: 626,
                      maxHeightDiskCache: 352,
                      fadeInDuration: Duration(milliseconds: 300),
                      placeholder: (context, url) => Container(
                        color: Colors.black,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) {
                        debugPrint('Error loading image from $url: $error');
                        return _buildErrorContainer();
                      },
                    );
                  } else {
                    debugPrint('Image URL verification failed for: $posterUrl');
                    return _buildErrorContainer();
                  }
                },
              ),
            ),
          );
        }
        
        debugPrint('No poster data available for $title');
        return _buildErrorContainer();
      },
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      width: 313,
      height: 176,
      decoration: BoxDecoration(
        color: Colors.black,
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

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  MoviesScreenState createState() => MoviesScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MoviesProvider(),
      child: const MoviesScreen(),
    );
  }
}

class MoviesScreenState extends State<MoviesScreen> with SingleTickerProviderStateMixin {
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
  String? _currentMovieRecommendation;
  bool _isSaved = false;

  // Helper to extract all movie information from AI response
  Map<String, String> extractMovieInfo(String response) {
    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(response);
    final yearMatch = RegExp(r'Year:\s*(\d{4})').firstMatch(response);
    final genreMatch = RegExp(r'Genre:\s*(.*)').firstMatch(response);
    final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n|$)').firstMatch(response);
    
    final trailerLine = response.split('\n').firstWhere(
      (line) => line.contains('Trailer:'),
      orElse: () => '',
    );
    
    final trailerMatch = RegExp(r'Trailer:\s*(.*)').firstMatch(trailerLine);
    final rawUrl = trailerMatch?.group(1)?.trim() ?? '';
    
    String cleanUrl = rawUrl;
    if (rawUrl.contains('youtu.be')) {
      final videoId = rawUrl.split('/').last;
      cleanUrl = 'https://www.youtube.com/watch?v=$videoId';
    } else if (rawUrl.contains('youtube.com')) {
      final videoIdMatch = RegExp(r'(?:v=|/)([0-9A-Za-z_-]{11})(?:\?|&|$)').firstMatch(rawUrl);
      if (videoIdMatch != null) {
        final videoId = videoIdMatch.group(1);
        cleanUrl = 'https://www.youtube.com/watch?v=$videoId';
      }
    }
    
    return {
      'title': titleMatch?.group(1)?.trim() ?? '',
      'year': yearMatch?.group(1)?.trim() ?? '',
      'genre': genreMatch?.group(1)?.trim() ?? '',
      'description': descriptionMatch?.group(1)?.trim() ?? '',
      'trailerUrl': cleanUrl,
    };
  }

  Future<void> _launchTrailerUrl() async {
    if (_currentMovieRecommendation == null) return;
    
    final movieInfo = extractMovieInfo(_currentMovieRecommendation!);
    final trailerUrl = movieInfo['trailerUrl'];
    
    if (trailerUrl != null && trailerUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(trailerUrl);
        
        final videoIdMatch = RegExp(r'(?:v=|/)([0-9A-Za-z_-]{11})(?:\?|&|$)').firstMatch(trailerUrl);
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
            Uri.parse(trailerUrl),
            mode: LaunchMode.platformDefault,
          );
        } catch (e) {}
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

    final provider = Provider.of<MoviesProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
        // Update the current movie recommendation when a new message is added
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentMovieRecommendation = lastMessage['content'];
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
            
            final provider = Provider.of<MoviesProvider>(context, listen: false);
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
    final provider = Provider.of<MoviesProvider>(context, listen: false);
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
    final provider = Provider.of<MoviesProvider>(context);
    
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
                        // Movie recommendation overlay
                        if (_currentMovieRecommendation != null)
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
                                    // Movie poster image
                                    if (_currentMovieRecommendation != null)
                                      Positioned(
                                        top: 24,
                                        left: 26,
                                        child: Builder(
                                          builder: (context) {
                                            final info = extractMovieInfo(_currentMovieRecommendation!);
                                            return MoviePoster(
                                              title: info['title'] ?? '',
                                              year: info['year'] ?? '',
                                            );
                                          },
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
                                    // Movie title
                                    Positioned(
                                      top: 222,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractMovieInfo(_currentMovieRecommendation!);
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
                                    // Year and Genre info
                                    Positioned(
                                      top: 256,
                                      left: 37,
                                      child: Builder(
                                        builder: (context) {
                                          final info = extractMovieInfo(_currentMovieRecommendation!);
                                          return Text(
                                            'Film (${info['year']}) · ${info['genre']}',
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
                                          final info = extractMovieInfo(_currentMovieRecommendation!);
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
                                    // Movie recommendation text
                                    Positioned(
                                      top: 216,
                                      left: 24,
                                      right: 24,
                                      bottom: 24,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Text(
                                            _currentMovieRecommendation!.split('\n')
                                                .where((line) => 
                                                    !line.startsWith('Title:') && 
                                                    !line.startsWith('Year:') && 
                                                    !line.startsWith('Genre:') &&
                                                    !line.startsWith('Description:') &&
                                                    !line.startsWith('Poster:') &&
                                                    !line.startsWith('Trailer:'))
                                                .join('\n'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // YouTube Watch Button
                                    Positioned(
                                      top: 394, // Decreased from 404
                                      left: 45,
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Button pressed!');
                                          _launchTrailerUrl();
                                        },
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
                                    // Save Box Button
                                    Positioned(
                                      top: 394, // Decreased from 404
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
                            top: 0.h, // Adjust this value to move the bubble up/down
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
                  builder: (context) => HomescreenScreen.builder(context),
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

  String _extractPosterUrl(String response) {
    try {
      final posterLine = response.split('\n').firstWhere(
        (line) => line.startsWith('Poster:'),
        orElse: () => 'Poster: ',
      );
      final url = posterLine.replaceAll('Poster:', '').trim();
      debugPrint('Extracted poster URL: $url'); // Debug log
      return url;
    } catch (e) {
      debugPrint('Error extracting poster URL: $e'); // Debug log
      return '';
    }
  }

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      debugPrint('Invalid URL format: $url'); // Debug log
      return false;
    }
  }
}
