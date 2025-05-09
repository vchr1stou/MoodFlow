import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
import '../log_screen/log_screen.dart';
import 'models/log_input_colors_model.dart';
import 'provider/log_input_colors_provider.dart';

class LogInputColorsScreen extends StatefulWidget {
  const LogInputColorsScreen({Key? key}) : super(key: key);

  @override
  LogInputColorsScreenState createState() => LogInputColorsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInputColorsProvider(),
      child: const LogInputColorsScreen(),
    );
  }
}

class LogInputColorsScreenState extends State<LogInputColorsScreen> {
  // Offset parameters for text positioning
  double paintTextTopOffset = -2.5.h;
  double paintTextLeftOffset = -2.h;

  // Color picker position
  double colorPickerTopOffset = 220.h;
  late Offset _currentPosition;
  Color _selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    // Initialize position at the center of the color wheel
    _currentPosition = Offset(170.h, 170.h);
  }

  // Reference colors for mood determination
  final Map<String, Map<String, dynamic>> _moodColors = {
    'Heavy': {
      'color': Color(0xFF8C2C2A),
      'emojiSource': 'emoji_five',
      'feeling': 'Heavy 😔'
    },
    'Low': {
      'color': Color(0xFFA3444F),
      'emojiSource': 'emoji_four',
      'feeling': 'Low 😕'
    },
    'Neutral': {
      'color': Color(0xFFD78F5D),
      'emojiSource': 'emoji_three',
      'feeling': 'Neutral 😐'
    },
    'Light': {
      'color': Color(0xFFFFBE5B),
      'emojiSource': 'emoji_two',
      'feeling': 'Light 😀'
    },
    'Bright': {
      'color': Color(0xFFFFBC42),
      'emojiSource': 'emoji_one',
      'feeling': 'Bright 😊'
    },
  };

  // Calculate color distance using RGB values
  double _calculateColorDistance(Color color1, Color color2) {
    return sqrt(
      pow(color1.red - color2.red, 2) +
      pow(color1.green - color2.green, 2) +
      pow(color1.blue - color2.blue, 2)
    );
  }

  // Determine mood based on color proximity
  Map<String, String> _determineMood(Color selectedColor) {
    String closestMood = 'Neutral'; // Default mood
    double minDistance = double.infinity;

    _moodColors.forEach((mood, data) {
      double distance = _calculateColorDistance(selectedColor, data['color'] as Color);
      if (distance < minDistance) {
        minDistance = distance;
        closestMood = mood;
      }
    });

    return {
      'emojiSource': _moodColors[closestMood]!['emojiSource']!,
      'feeling': _moodColors[closestMood]!['feeling']!
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        drawerEnableOpenDragGesture: false,
        body: Stack(
          children: [
            // Background Image
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
            // Main Content Container
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Close Button
                  Positioned(
                    top: 62.h,
                    right: 15.h,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 35,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LogInputScreen.builder(context),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/close_button.svg',
                          width: 39.h,
                          height: 39.h,
                        ),
                      ),
                    ),
                  ),
                  // Title Text
                  Positioned(
                    top: 120.h,
                    left: 0,
                    right: 0,
                    child: Text(
                      "What Color Is Your Vibe?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Description Text
                  Positioned(
                    top: 160.h,
                    left: 24.h,
                    right: 24.h,
                    child: Text(
                      "Dip into the rainbow and choose the hue that matches your mood.\nBright and beaming? Cloudy and cozy? Your color knows.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Color Spectrum Picker
                  Positioned(
                    top: colorPickerTopOffset,
                    left: 24.h,
                    right: 24.h,
                    child: _buildColorPicker(),
                  ),
                  // Color Button
                  Positioned(
                    bottom: 60.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 150,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Map<String, String> moodData = _determineMood(_selectedColor);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogScreen.builder(
                                  context,
                                  source: 'colorscreen',
                                  emojiSource: moodData['emojiSource']!,
                                  feeling: moodData['feeling']!,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/this_matches_me.svg',
                                width: 180.h,
                                height: 44.h,
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Transform.translate(
                                    offset: Offset(
                                        paintTextLeftOffset, paintTextTopOffset),
                                    child: Text(
                                      "Paint the Mood",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      width: 360.h,
      height: 489.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.h),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.h,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Color wheel background
            Container(
              width: 360.h,
              height: 489.h,
              child: CustomPaint(
                painter: ColorWheelPainter(),
              ),
            ),
            // Selection area
            GestureDetector(
              onPanStart: (details) {
                _handleColorSelection(details.localPosition);
              },
              onPanUpdate: (details) {
                _handleColorSelection(details.localPosition);
              },
              onPanEnd: (details) {
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: 360.h,
                height: 489.h,
                color: Colors.transparent,
              ),
            ),
            // Selection indicator
            Positioned(
              left: _currentPosition.dx - 15.h,
              top: _currentPosition.dy - 15.h,
              child: Container(
                width: 30.h,
                height: 30.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 24.h,
                    height: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.h,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleColorSelection(Offset localPosition) {
    // Ensure position is within bounds
    final x = localPosition.dx.clamp(0.0, 360.h).toDouble();
    final y = localPosition.dy.clamp(0.0, 489.h).toDouble();
    
    setState(() {
      _currentPosition = Offset(x, y);
      
      // Calculate hue (0-360) based on x position
      final hue = (x / 360.h) * 360;
      
      // Calculate saturation (0-1) based on y position
      final saturation = 1.0 - (y / 489.h);
      
      // Create color from HSV
      _selectedColor = HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();
    });
  }
}

class ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a horizontal gradient for hue with more color variety
    final huePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFFF0000), // Red
          Color(0xFFFF4000), // Orange-Red
          Color(0xFFFF8000), // Orange
          Color(0xFFFFBF00), // Amber
          Color(0xFFFFFF00), // Yellow
          Color(0xFFBFFF00), // Lime
          Color(0xFF80FF00), // Chartreuse
          Color(0xFF40FF00), // Spring Green
          Color(0xFF00FF00), // Green
          Color(0xFF00FF40), // Mint
          Color(0xFF00FF80), // Aquamarine
          Color(0xFF00FFBF), // Turquoise
          Color(0xFF00FFFF), // Cyan
          Color(0xFF00BFFF), // Sky Blue
          Color(0xFF0080FF), // Azure
          Color(0xFF0040FF), // Blue
          Color(0xFF0000FF), // Pure Blue
          Color(0xFF4000FF), // Indigo
          Color(0xFF8000FF), // Violet
          Color(0xFFBF00FF), // Purple
          Color(0xFFFF00FF), // Magenta
          Color(0xFFFF00BF), // Rose
          Color(0xFFFF0080), // Pink
          Color(0xFFFF0040), // Crimson
          Color(0xFFFF0000), // Back to Red
        ],
        stops: List.generate(25, (index) => index / 24),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw the base hue gradient
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), huePaint);

    // Add a vertical gradient for saturation with more contrast
    final saturationPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.0),
          Colors.black.withOpacity(0.7),
        ],
        stops: [0.0, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw the saturation gradient
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), saturationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
