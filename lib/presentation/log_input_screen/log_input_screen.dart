import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
            top: 131.h,
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
            top: 240.h,
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
                    offset: Offset(16.h, -4.h),
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
                  // Second Text Log SVG
                  Transform.translate(
                    offset: Offset(0, 108.h),
                    child: SizedBox(
                      height: 80.h,
                      child: SvgPicture.asset(
                        'assets/images/text_log.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Emoji Circle for second text_log
                  Transform.translate(
                    offset: Offset(-125.h, 104.h),
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
                  // Second Text elements
                  Transform.translate(
                    offset: Offset(23.h,
                        104.h), // Adjusted to match second text_log position
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
                        ),
                      ],
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
