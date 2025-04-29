import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypeToSiri extends StatefulWidget {
  const TypeToSiri({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const TypeToSiri();
  }

  @override
  State<TypeToSiri> createState() => _TypeToSiriState();
}

class _TypeToSiriState extends State<TypeToSiri> {
  final TextEditingController _textController = TextEditingController();
  int _gradientIndex = 0;
  Timer? _timer;

  final List<List<Color>> _gradientsPill = [
    [
      Color(0xFFFF6778), // PINK
      Color(0xFFFFBA71), // YELLOW
    ],
    [
      Color(0xFFFFBA71), // YELLOW
      Color(0xFF8D99FF), // BLUE
    ],
    [
      Color(0xFF8D99FF), // BLUE
      Color(0xFFF5B9EA), // WHITE
    ],
    [
      Color(0xFFF5B9EA), // WHITE
      Color(0xFFFF6778), // PINK
    ],
  ];

  final List<List<Color>> _gradientsKeyboard = [
    [
      Color(0xFFA0414B), // Further Darkened Pink
      Color(0xFFA07749), // Further Darkened Yellow
    ],
    [
      Color(0xFFA07749), // Further Darkened Yellow
      Color(0xFF5A6299), // Further Darkened Blue
    ],
    [
      Color(0xFF5A6299), // Further Darkened Blue
      Color(0xFF9E7296), // Further Darkened White
    ],
    [
      Color(0xFF9E7296), // Further Darkened White
      Color(0xFFA0414B), // Further Darkened Pink
    ],
  ];

  @override
  void initState() {
    super.initState();
    _startGradientTimer();
  }

  void _startGradientTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _gradientIndex = (_gradientIndex + 1) % _gradientsPill.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/Wallpaper.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            // Keyboard Gradient Background
            Positioned(
              top: screenHeight / 2,
              child: Container(
                width: screenWidth + 50,
                height: screenHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _gradientsKeyboard[_gradientIndex],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // Main Content
            Positioned(
              top: screenHeight / 2 + 50,
              left: 40,
              right: 40,
              child: Column(
                children: [
                  // Siri Icon and Text Field Container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF483838).withOpacity(0.6),
                      border: Border.all(
                        width: 5,
                        color: Colors.transparent,
                      ),
                      gradient: LinearGradient(
                        colors: _gradientsPill[_gradientIndex],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Siri Icon
                        Positioned(
                          left: 10,
                          top: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/images/Siri_Icon.png',
                            height: 24,
                          ),
                        ),
                        // Text Field
                        TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Ask Siri...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 30,
                              right: 20,
                              top: 15,
                              bottom: 15,
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
}
