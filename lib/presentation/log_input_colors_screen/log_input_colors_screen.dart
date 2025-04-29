import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
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
  Offset? _currentPosition;
  Color _selectedColor = Colors.red;

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
                    child: Container(
                      height: 450.h, // Increased height further
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.h),
                          child: Stack(
                            children: [
                              // Color Spectrum
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: ColorSpectrumPainter(),
                                ),
                              ),
                              // Color Picker Indicator
                              if (_currentPosition != null)
                                Positioned(
                                  left: _currentPosition!.dx - 15,
                                  top: _currentPosition!.dy - 15,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Gesture Detector for color picking
                              Positioned.fill(
                                child: GestureDetector(
                                  onPanDown: (details) {
                                    _updateColorSelection(
                                        details.localPosition);
                                  },
                                  onPanUpdate: (details) {
                                    _updateColorSelection(
                                        details.localPosition);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateColorSelection(Offset position) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Size size = box.size;

    // Constrain the position within the bounds
    double dx = position.dx.clamp(0, size.width);
    double dy = position.dy.clamp(0, size.height);

    setState(() {
      _currentPosition = Offset(dx, dy);
      // Calculate color based on position
      _selectedColor = _getColorAtPosition(dx, dy, size);
    });
  }

  Color _getColorAtPosition(double dx, double dy, Size size) {
    final double hue = (dx / size.width) * 360;
    final double saturation = 1.0;
    final double value = 1.0 - (dy / size.height);

    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }
}

class ColorSpectrumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Create horizontal rainbow gradient
    final List<Color> rainbowColors = [
      Color(0xFFFF0000), // Pure Red
      Color(0xFFFF8000), // Orange
      Color(0xFFFFFF00), // Yellow
      Color(0xFF00FF00), // Pure Green
      Color(0xFF00FFFF), // Cyan
      Color(0xFF0000FF), // Pure Blue
      Color(0xFF8000FF), // Purple
      Color(0xFFFF00FF), // Magenta
    ];

    // Draw the base rainbow gradient
    final rainbowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: rainbowColors,
      ).createShader(rect);

    canvas.drawRect(rect, rainbowPaint);

    // Create and draw brightness/darkness overlay
    final brightnessPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.5), // Less white at top
          Colors.transparent, // Pure colors in middle
          Colors.black.withOpacity(0.7), // Darker black at bottom
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, brightnessPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
