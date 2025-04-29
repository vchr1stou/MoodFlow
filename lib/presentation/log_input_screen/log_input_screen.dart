import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../emoji_log_one_screen/emoji_log_one_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';
import '../log_input_colors_screen/log_input_colors_screen.dart';

class LogInputScreen extends StatefulWidget {
  const LogInputScreen({Key? key}) : super(key: key);

  @override
  LogInputScreenState createState() => LogInputScreenState();

  static Widget builder(BuildContext context) {
    return LogInputScreen();
  }
}

class LogInputScreenState extends State<LogInputScreen> {
  // Text Log positioning
  final double textLogTitleLeft = 78.h;
  final double textLogTitleTop = 15.1.h;
  final double textLogDescLeft = 79.h;
  final double textLogDescTop = 0.h;

  // Emoji Log positioning
  final double emojiLogTitleLeft = 79.h;
  final double emojiLogTitleTop = 15.1.h;
  final double emojiLogDescLeft = 80.h;
  final double emojiLogDescTop = 0.h;

  // Camera Log positioning
  final double cameraLogTitleLeft = 78.h;
  final double cameraLogTitleTop = 15.1.h;
  final double cameraLogDescLeft = 79.h;
  final double cameraLogDescTop = 0.h;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
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
                        builder: (context) => HomescreenScreen.builder(context),
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
              top: 160.h,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Text(
                  "Let's unpack those feels!\nLog your mood using:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            // First Text Log
            Positioned(
              top: 300.h,
              left: 24.h,
              right: 24.h,
              child: SizedBox(
                width: double.infinity,
                height: 80.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmojiLogOneScreen.builder(context),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Text Log SVG as background
                      SvgPicture.asset(
                        'assets/images/text_log.svg',
                        width: 380.h,
                        height: 80.h,
                        fit: BoxFit.fill,
                      ),
                      // Image
                      Positioned(
                        left: 12.h,
                        top: -1.h,
                        child: Container(
                          width: 73.h,
                          height: 73.h,
                          child: Image.asset(
                            'assets/images/img_image.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Text Column for Text Log
                      Positioned(
                        left: textLogTitleLeft,
                        top: textLogTitleTop,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Text",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(textLogDescLeft - textLogTitleLeft,
                                  textLogDescTop),
                              child: Text(
                                "Chat your feels! MoodFlow AI listens and logs.",
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
            // Second Text Log
            Positioned(
              top: 400.h, // 321 + 80 + 20 = 421
              left: 24.h,
              right: 24.h,
              child: SizedBox(
                width: double.infinity,
                height: 80.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            EmojiLogOneScreen.builder(context),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'assets/images/text_log.svg',
                        width: 380.h,
                        height: 80.h,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        left: 24.h,
                        top: 12.h,
                        child: Container(
                          width: 48.h,
                          height: 48.h,
                          child: Image.asset(
                            'assets/images/emoji_star_struck.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Text Column for Emoji Log
                      Positioned(
                        left: emojiLogTitleLeft,
                        top: emojiLogTitleTop,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Emoji",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                  emojiLogDescLeft - emojiLogTitleLeft,
                                  emojiLogDescTop),
                              child: Text(
                                "Feeling emoji-nal? Express yourself using emojis!",
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
            // Third Text Log
            Positioned(
              top: 500.h, // 439 + 80 + 38 = 557
              left: 24.h,
              right: 24.h,
              child: SizedBox(
                width: double.infinity,
                height: 80.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LogInputColorsScreen.builder(context),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'assets/images/text_log.svg',
                        width: 380.h,
                        height: 80.h,
                        fit: BoxFit.fill,
                      ),
                      // Image for Camera Log
                      Positioned(
                        left: 20.h,
                        top: 5.h,
                        child: Container(
                          width: 60.h,
                          height: 60.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent),
                          child: Center(
                            child: Container(
                              width: 43.h,
                              height: 43.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  center: Alignment.center,
                                  startAngle: 0.0,
                                  endAngle: 6.28319, // 2 * pi
                                  colors: [
                                    Color(0xFFE7E040), // 0%
                                    Color(0xFFEEAA3C), // 12%
                                    Color(0xFFE8403B), // 25%
                                    Color(0xFFB33ED5), // 37%
                                    Color(0xFF694AE8), // 51%
                                    Color(0xFF3CCAE7), // 64%
                                    Color(0xFF3CE885), // 75%
                                    Color(0xFF89E743), // 87%
                                    Color(0xFFE7E040), // 100% (back to start)
                                  ],
                                  stops: [
                                    0.0,
                                    0.12,
                                    0.25,
                                    0.37,
                                    0.51,
                                    0.64,
                                    0.75,
                                    0.87,
                                    1.0
                                  ],
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                    stops: [0.0, 0.6],
                                    focal: Alignment(0.1, 0.1),
                                    center: Alignment(0.1, 0.1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text Column for Camera Log
                      Positioned(
                        left: cameraLogTitleLeft,
                        top: cameraLogTitleTop,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Colour",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                  cameraLogDescLeft - cameraLogTitleLeft,
                                  cameraLogDescTop),
                              child: Text(
                                "Paint your mood—choose your colour!",
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
          ],
        ),
      ),
    );
  }
}
