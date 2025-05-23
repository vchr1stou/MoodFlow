import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodflow/presentation/homescreen_screen/homescreen_screen.dart';
import 'package:moodflow/presentation/emoji_log_four_screen/emoji_log_four_screen.dart';
import '../../core/services/storage_service.dart';
import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
import '../log_screen/log_screen.dart';
import 'package:provider/provider.dart';

class EmojiLogFiveScreen extends StatefulWidget {
  final String source;
  const EmojiLogFiveScreen({Key? key, required this.source}) : super(key: key);

  @override
  State<EmojiLogFiveScreen> createState() => _EmojiLogFiveScreenState();
}

class _EmojiLogFiveScreenState extends State<EmojiLogFiveScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Offset parameters for manual positioning
  double imageTopOffset = 35.h;
  double imageLeftOffset = -5.h;
  double titleTopOffset = 30.h;
  double titleLeftOffset = -12.h;
  double descriptionTopOffset = 10.h;
  double descriptionLeftOffset = -2.h;
  double closeButtonTopOffset = 62.h;
  double closeButtonRightOffset = 15.h;
  double matchesTextTopOffset = -2.5.h;
  double matchesTextLeftOffset = 0.h;
  // Navigation circles parameters
  double circlesTopOffset = 11.h;
  double circlesLeftOffset = 1.h;
  double circlesSpacing = 7.h;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe down - provide haptic feedback
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    EmojiLogFourScreen(source: 'homescreen'),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 400),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xFFFFBC42),
          extendBody: true,
          extendBodyBehindAppBar: true,
          drawerEnableOpenDragGesture: false,
          body: Stack(
            children: [
              // Background with blur and overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFFFBC42).withOpacity(0.5),
                  ),
                ),
              ),
              // Main Content Container with manual positioning
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Navigation Number with circles
                    Positioned(
                      left: 13.h,
                      top: MediaQuery.of(context).size.height / 2 - 20.h,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/navigation_number.svg',
                            width: 20.h,
                            height: 90.h,
                          ),
                          Positioned(
                            top: circlesTopOffset,
                            left: circlesLeftOffset,
                            child: Container(
                              width: 20.h,
                              height: 90.h,
                              child: Column(
                                children: List.generate(5, (index) {
                                  return Transform.translate(
                                    offset: Offset(0, index * circlesSpacing),
                                    child: Container(
                                      width: 8.h,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == 4
                                            ? Colors.white
                                            : Colors.black12.withOpacity(0.2),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Emoji Image with offset
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 -
                          120.h +
                          imageTopOffset,
                      left: MediaQuery.of(context).size.width / 2 -
                          200.h +
                          imageLeftOffset,
                      child: Container(
                        width: 400.h,
                        height: 120.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120.h,
                              height: 120.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 150,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: FadeTransition(
                                  opacity: _opacityAnimation,
                                  child: Image.asset(
                                    'assets/images/emoji5.png',
                                    width: 100.h,
                                    height: 100.h,
                                    filterQuality: FilterQuality.high,
                                    isAntiAlias: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Title Text with offset
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 +
                          titleTopOffset,
                      left: MediaQuery.of(context).size.width / 2 -
                          25.h +
                          titleLeftOffset,
                      child: Text(
                        "Bright",
                        style: GoogleFonts.roboto(
                          fontSize: 22,
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
                    // Description Text with offset
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 +
                          titleTopOffset +
                          30.h +
                          descriptionTopOffset,
                      left: MediaQuery.of(context).size.width / 2 -
                          150.h +
                          descriptionLeftOffset,
                      child: SizedBox(
                        width: 300.h,
                        child: Text(
                          "This spark in you?\nIt's real. Let it shine without shrinking.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
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
                    ),
                    // This Matches Me button
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
                                    offset: Offset(matchesTextLeftOffset,
                                        matchesTextTopOffset),
                                    child: GestureDetector(
                                      onTap: () async {
                                        // Clear saved data before navigating
                                        await StorageService.clearAll();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LogScreen.builder(
                                              context,
                                              source: widget.source,
                                              feeling: "Bright 😊",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "This Matches Me",
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
              // Close Button with offset
              Positioned(
                top: closeButtonTopOffset,
                right: closeButtonRightOffset,
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
                          builder: (context) => LogInputScreen.builder(context),
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
            ],
          ),
        ),
      ),
    );
  }
}
