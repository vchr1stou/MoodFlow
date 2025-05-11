import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:html/parser.dart' as parser;
import 'dart:io';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_export.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';

import 'models/cooking_model.dart';
import 'provider/cooking_provider.dart';

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
      Radius.circular(isKeyboardOpen ? 0 : 47.33),
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
  final List<double> _fixedStops = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 8), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
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

Map<String, String> extractRecipeInfo(String response) {
  final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(response);
  final timeMatch = RegExp(r'Time:\s*(.*)').firstMatch(response);
  final servingsMatch = RegExp(r'Servings:\s*(.*)').firstMatch(response);
  final descriptionMatch = RegExp(r'Description:\s*(.*?)(?=\n|$)').firstMatch(response);
  final recipeMatch = RegExp(r'Recipe:\s*(.*)').firstMatch(response);
  final imageMatch = RegExp(r'Image:\s*(.*)').firstMatch(response);

  return {
    'title': titleMatch?.group(1)?.trim() ?? '',
    'time': timeMatch?.group(1)?.trim() ?? '',
    'servings': servingsMatch?.group(1)?.trim() ?? '',
    'description': descriptionMatch?.group(1)?.trim() ?? '',
    'recipeUrl': recipeMatch?.group(1)?.trim() ?? '',
    'imageUrl': imageMatch?.group(1)?.trim() ?? '',
  };
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
    // Error handling without debug print
  }
  return null;
}

class RecipeImage extends StatelessWidget {
  final String imageUrl;

  const RecipeImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        width: 313,
        height: 176,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    // Check if the image is a local file path
    if (imageUrl.startsWith('/')) {
      return Container(
        width: 313,
        height: 176,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imageUrl),
            width: 313,
            height: 176,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 313,
                height: 176,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      );
    }

    // Handle network image
    return Container(
      width: 313,
      height: 176,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
          errorWidget: (context, url, error) {
            return Container(
              width: 313,
              height: 176,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CookingScreen extends StatefulWidget {
  const CookingScreen({Key? key}) : super(key: key);

  @override
  CookingScreenState createState() => CookingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CookingProvider(),
      child: const CookingScreen(),
    );
  }
}

class CookingScreenState extends State<CookingScreen> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  String? _currentRecipe;
  bool _isSaved = false;
  final ScrollController _scrollController = ScrollController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isManualStop = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
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

    final provider = Provider.of<CookingProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        if (provider.messages.isNotEmpty) {
          final lastMessage = provider.messages.last;
          if (lastMessage['role'] == 'assistant') {
            _currentRecipe = lastMessage['content'];
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
            
            final provider = Provider.of<CookingProvider>(context, listen: false);
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
    final provider = Provider.of<CookingProvider>(context, listen: false);
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

  Future<void> _launchRecipeUrl() async {
    if (_currentRecipe == null) return;
    final recipeInfo = extractRecipeInfo(_currentRecipe!);
    final recipeUrl = recipeInfo['recipeUrl'];
    if (recipeUrl != null && recipeUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(recipeUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (e) {}
    }
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
    final provider = Provider.of<CookingProvider>(context);
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
                      // Recipe recommendation overlay
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 366,
                            height: 491,
                            child: Stack(
                              children: [
                                // Recipe time box background
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/images/movie_time_box.svg',
                                    width: 366,
                                    height: 491,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                if (_currentRecipe != null) ...[
                                  // Recipe image
                                  Positioned(
                                    top: 24,
                                    left: 26,
                                    child: Builder(
                                      builder: (context) {
                                        final info = extractRecipeInfo(_currentRecipe!);
                                        return RecipeImage(
                                          imageUrl: info['imageUrl'] ?? '',
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
                                  // Recipe title
                                  Positioned(
                                    top: 229,
                                    left: 37,
                                    child: Builder(
                                      builder: (context) {
                                        final info = extractRecipeInfo(_currentRecipe!);
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              info['title'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${info['time']} · ${info['servings']}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
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
                                        final info = extractRecipeInfo(_currentRecipe!);
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
                                  // View Recipe Button
                                  Positioned(
                                    top: 394,
                                    left: 45,
                                    child: GestureDetector(
                                      onTap: _launchRecipeUrl,
                                      child: Container(
                                        width: 203,
                                        height: 42,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 97,
                                              top: 14,
                                              child: Text(
                                                'Get the Recipe',
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
                                ] else if (provider.isLoading)
                                  // Loading indicator
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 15,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Finding the perfect recipe...',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
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
                        ),
                      ),
                      // Chat messages (show only the welcome message)
                      if (provider.showChat && provider.messages.isNotEmpty)
                        Positioned(
                          top: 0,
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
                            : (provider.messages.isEmpty ? -30.0 : (provider.showChat ? -30.0 : -30.0)),
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
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/text_box.svg',
                                        width: 372,
                                        height: 44,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                      ),
                                    ),
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
