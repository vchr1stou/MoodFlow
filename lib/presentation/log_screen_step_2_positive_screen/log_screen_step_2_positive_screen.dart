import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_screen/log_screen.dart';

class LogScreenStep2PositiveScreen extends StatefulWidget {
  const LogScreenStep2PositiveScreen({Key? key}) : super(key: key);

  @override
  LogScreenStep2PositiveScreenState createState() =>
      LogScreenStep2PositiveScreenState();

  static Widget builder(BuildContext context) {
    return const LogScreenStep2PositiveScreen();
  }
}

class LogScreenStep2PositiveScreenState
    extends State<LogScreenStep2PositiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Background blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xFF808080).withOpacity(0.2),
                          ),
                        ),
                      ),
            // Content
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 97.h),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Select Feelings",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "No feeling is too big or too small — if it speaks to your soul, tap it!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SvgPicture.asset(
                              'assets/images/positive-selected.svg',
                              width: 276.h,
                              height: 44.h,
                            ),
                            SizedBox(height: 25.h),
                            Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/positive_box.svg',
                                  width: 364.h,
                                  height: 566.h,
                                ),
                                // First row
                                Positioned(
                                  top: 10.h,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Second row
                                Positioned(
                                  top: 10.h + 36.h + 10.h,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + 36.h + 10.h,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + 36.h + 10.h,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Third row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 2,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 2,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 2,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Fourth row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 3,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 3,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 3,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Fifth row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 4,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 4,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 4,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Sixth row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 5,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 5,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 5,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Seventh row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 6,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 6,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 6,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Eighth row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 7,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 7,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 7,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                // Ninth row
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 8,
                                  left: 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 8,
                                  left: 10.h + 108.h + 10.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                                Positioned(
                                  top: 10.h + (36.h + 10.h) * 8,
                                  left: 364.h - 10.h - 108.h,
                                  child: SvgPicture.asset(
                                    'assets/images/positive_button.svg',
                                    width: 108.h,
                                    height: 36.h,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            // Your content will go here
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
        onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27.h,
                height: 27.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
