import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_export.dart';
import '../presentation/homescreen_screen/homescreen_screen.dart';

class MoodFlowBottomBarSvg extends StatelessWidget {
  const MoodFlowBottomBarSvg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if running on Android and has system navigation bar
    final bottomPadding =
        Platform.isAndroid ? MediaQuery.of(context).padding.bottom : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: bottomPadding > 0 ? 20 + bottomPadding : 20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Transform.translate(
            offset: Offset(0, -23),
            child: Stack(
              children: [
                // The entire bottom bar SVG
                SvgPicture.asset(
                  'assets/images/bottom_bar_little_lifts_pressed.svg',
                  fit: BoxFit.fitWidth,
                ),

                // Left side - Home text (navigates to Home screen)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width:
                      250, // Increased from 220 to 250 for a wider touch target
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            HomescreenScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 0.95, end: 1.0).animate(
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

                // Right side - Little Lifts text (no navigation)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width:
                      250, // Increased from 186 to 250 for a wider touch target
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    // No onTap handler - tapping does nothing
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -25),
            child: Image.asset(
              'assets/images/ai_button.png',
              width: 118.667,
              height: 36,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
            ),
          ),
        ],
      ),
    );
  }
}
