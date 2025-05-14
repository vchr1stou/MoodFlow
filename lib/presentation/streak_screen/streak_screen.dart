import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/streak_model.dart';
import 'provider/streak_provider.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({Key? key}) : super(key: key);

  @override
  StreakScreenState createState() => StreakScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StreakProvider(),
      child: Builder(
        builder: (context) => StreakScreen(),
      ),
    );
  }
}

class StreakScreenState extends State<StreakScreen> {
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

  void _handleCloseButton() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  onTap: _handleCloseButton,
                  child: SvgPicture.asset(
                    'assets/images/close_button.svg',
                    width: 39.h,
                    height: 39.h,
                  ),
                ),
              ),
            ),
            // Streak Flame - 29 pixels down from close button, centered
            Positioned(
              top: 130.h, // 62 + 39 + 29 = 130
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/flame.svg',
                      width: 112.h,
                      height: 154.h,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: Text(
                      "A streak is your mood-tracking winning spree! 🤩\nEach day you log your mood, you keep the chain alive,\nthink of it as collecting little victories for your mind!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Streak Bubbles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left bubble
                      Container(
                        width: 157.h,
                        height: 67.h,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/bubble_streak.svg',
                              width: 157.h,
                              height: 67.h,
                            ),
                            Positioned(
                              top: 8.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    "Longest Streak",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "20 days",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right bubble
                      Container(
                        width: 157.h,
                        height: 67.h,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/bubble_streak.svg',
                              width: 157.h,
                              height: 67.h,
                            ),
                            Positioned(
                              top: 8.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    "Current Streak",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "20 days",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
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
                  // Alert streak
                  SizedBox(height: 15.h), // 10 pixels down from bubbles
                  Center(
                    child: Container(
                      width: 340.h,
                      height: 51.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/alert_streak.svg',
                            width: 340.h,
                            height: 51.h,
                          ),
                          Text(
                            "⏰ Quick! 7 hours left to save your streak!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
}
