import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import '../homescreen_screen/homescreen_screen.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _isTyping = false;
        if (mounted) setState(() {});
      } else {
        // When keyboard opens, scroll to the latest message
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
    
    // Initialize breathing animation controller
    _breathingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    // Create breathing animation
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5)
      .animate(CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ));
    
    // Make the animation repeat in both directions
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    // Set up message listener
    final provider = Provider.of<MoviesProvider>(context, listen: false);
    provider.onMessageAdded = () {
      setState(() {
        _showChat = true;
      });
      // Scroll to bottom after adding message
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

    // Dismiss keyboard
    _focusNode.unfocus();

    // Send message to Gemini
    provider.sendMessage(userMessage);

    // Scroll to bottom after adding message
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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardVisible = bottomPadding > 0;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay with blur
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Color(0xFF000000).withOpacity(0.15),
              ),
            ),
          ),
          // Glow Effect
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: GlowEffect(isKeyboardOpen: _focusNode.hasFocus),
          ),
          // Main content
          SafeArea(
            child: Stack(
              children: [
                // Chat messages
                if (provider.showChat)
                  Positioned(
                    top: 56.h,
                    left: 0,
                    right: 0,
                    bottom: 104.0,
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
                          children: provider.messages.map((message) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Column(
                                children: [
                                  message['isSender']
                                      ? BubbleSpecialThree(
                                          text: message['text'],
                                          color: message['color'].withOpacity(0.3),
                                          tail: message['tail'],
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        )
                                      : BubbleSpecialThree(
                                          text: message['text'],
                                          color: message['color'].withOpacity(0.3),
                                          tail: message['tail'],
                                          isSender: false,
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                ],
                              ),
                            );
                          }).toList(),
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
    );
  }
}
