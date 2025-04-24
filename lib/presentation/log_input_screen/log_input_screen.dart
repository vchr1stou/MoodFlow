import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../emoji_log_one_screen/emoji_log_one_screen.dart';

class LogInputScreen extends StatefulWidget {
  const LogInputScreen({Key? key}) : super(key: key);

  @override
  LogInputScreenState createState() => LogInputScreenState();

  static Widget builder(BuildContext context) {
    return LogInputScreen();
  }
}

class LogInputScreenState extends State<LogInputScreen> {
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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
            top: 60.h,
            right: 24.h,
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
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/images/close_button.svg',
                  width: 38.h,
                  height: 38.h,
                ),
              ),
            ),
          ),
          // Title Text
          Positioned(
            top: 160.h,
            left: 0,
            right: 0,
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
          // Text Log and Wave Image
          Positioned(
            top: 300.h,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // First Text Log SVG behind
                  SizedBox(
                    height: 80.h,
                    child: SvgPicture.asset(
                      'assets/images/text_log.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  // First Text elements
                  Transform.translate(
                    offset: Offset(13.h, -4.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Text",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.1.h),
                        Text(
                          "Chat your feels! MoodFlow AI listens and logs.",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second (Emoji) option shape with tap
                  Transform.translate(
                    offset: Offset(0, 108.h),
                    transformHitTests: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        print("Navigating to EmojiLogOneScreen...");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening Emoji Log Screen...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmojiLogOneScreen.builder(context),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 80.h,
                        child: SvgPicture.asset(
                          'assets/images/text_log.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  // Emoji icon for second option
                  Transform.translate(
                    offset: Offset(-125.h, 104.h),
                    transformHitTests: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmojiLogOneScreen.builder(context),
                          ),
                        );
                      },
                      child: Container(
                        width: 63.h,
                        height: 63.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 35,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/emoji_star_struck.png',
                            width: 45.h,
                            height: 45.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Emoji label for second option
                  Transform.translate(
                    offset: Offset(43.h, 104.h),
                    transformHitTests: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmojiLogOneScreen.builder(context),
                          ),
                        );
                      },
                      child: Container(
                        width: 270.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Emoji",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 0.1.h),
                            Text(
                              "Feeling emoji-nal? Express yourself using emojis!",
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Third Text Log SVG
                  Transform.translate(
                    offset: Offset(0, 218.h),
                    child: SizedBox(
                      height: 80.h,
                      child: SvgPicture.asset(
                        'assets/images/text_log.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Third Text elements
                  Transform.translate(
                    offset: Offset(-3.h, 214.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Colors",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 0.1.h),
                        Text(
                          "Paint your mood—choose your color!",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Emoji Circle for third text_log
                  Transform.translate(
                    offset: Offset(-120.h, 214.h),
                    child: Container(
                      width: 60.h,
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 35,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 45.h,
                          height: 45.h,
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
                  // Wave Image in front
                  Transform.translate(
                    offset: Offset(-125.h, -4),
                    child: Container(
                      width: 63.h,
                      height: 63.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/img_image.png'),
                          fit: BoxFit.cover,
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
    );
  }
}
