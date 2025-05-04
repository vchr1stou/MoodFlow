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

class GlowPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  final List<double> stops;

  GlowPainter({
    required this.animation,
    required this.colors,
    required this.stops,
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

    // Draw the main glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(-0.2),
        Radius.circular(47.33),
      ),
      gradientPaint,
    );

    // Draw an inner stroke for more visibility
    final innerPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: stops,
        transform: GradientRotation(animation * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(-0.2),
        Radius.circular(47.33),
      ),
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(GlowPainter oldDelegate) {
    return animation != oldDelegate.animation ||
           stops != oldDelegate.stops;
  }
}

class GlowEffect extends StatefulWidget {
  const GlowEffect({Key? key}) : super(key: key);

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
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class AiScreen extends StatefulWidget {
  const AiScreen({Key? key}) : super(key: key);

  @override
  AiScreenState createState() => AiScreenState();

  static Widget builder(BuildContext context) {
    return const AiScreen();
  }
}

class AiScreenState extends State<AiScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  String? _userName;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isManualStop = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
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

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isTyping = false;
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
            
            setState(() {
              _textController.text = result.recognizedWords;
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

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _breathingController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final defaultPosition = 104.0;
    final distanceFromKeyboard = 490.0;
    final keyboardPosition = MediaQuery.of(context).size.height - bottomPadding - distanceFromKeyboard;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          // Glow Effect - moved on top of background blur
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: GlowEffect(),
          ),
          // User greeting text
          if (!_isTyping) Positioned(
            top: 120,
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
                ),
              ),
            ),
          ),
          // Text input field
          Positioned(
            bottom: _isTyping ? keyboardPosition : defaultPosition,
            left: 0,
            right: 0,
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
                        child: SvgPicture.asset(
                          'assets/images/send_button.svg',
                          width: 49,
                          height: 49,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Text input field
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: _isTyping
                            ? TextField(
                                controller: _textController,
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
                                  contentPadding: EdgeInsets.only(left: 65, top: 12),
                                  hintText: '',
                                  isDense: true,
                                  isCollapsed: true,
                                ),
                                onSubmitted: (text) {
                                  _focusNode.unfocus();
                                },
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
                                _textController.text.isEmpty ? 'Ask me anything' : _textController.text,
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
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: Platform.isAndroid ? 20 + MediaQuery.of(context).padding.bottom : 20,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.translate(
              offset: const Offset(0, -23),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/bottom_bar_ai.svg',
                    fit: BoxFit.fitWidth,
                  ),
                  // Left side - Home navigation
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 250,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              HomescreenScreen.builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.95, end: 1.0)
                                    .animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Right side - Little Lifts navigation
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 250,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              LittleLiftsScreen.builder(context),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.95, end: 1.0)
                                    .animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/ai_button.png',
                    width: 118.667,
                    height: 36,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  ),
                  Positioned.fill(
                    top: -22,
                    bottom: -22,
                    child: Container(
                      color: Colors.transparent,
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
}
