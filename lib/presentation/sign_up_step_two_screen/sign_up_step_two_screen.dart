import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/sign_up_step_two_model.dart';
import 'provider/sign_up_step_two_provider.dart';

class SignUpStepTwoScreen extends StatefulWidget {
  const SignUpStepTwoScreen({Key? key}) : super(key: key);

  @override
  SignUpStepTwoScreenState createState() => SignUpStepTwoScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepTwoProvider(),
      child: SignUpStepTwoScreen(),
    );
  }
}

class SignUpStepTwoScreenState extends State<SignUpStepTwoScreen> {
  bool _dailyCheckInEnabled = true;
  bool _quoteEnabled = true;

  @override
  void initState() {
    super.initState();
  }

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
                  color: Color(0xFFBCBCBC).withOpacity(0.04),
                ),
              ),
            ),
            // Top blur box
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, left: 24.h, right: 24.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                        child: Text(
                          "Gentle Reminders",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: Text(
                          "We'll nudge you with two simple things:",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "📝 A daily check-in to reflect on your mood",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "💬 A quote of the day to lift or ground your thoughts",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        children: [
                          Container(
                            width: 340.h,
                            height: _dailyCheckInEnabled ? 283.h : 79.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  _dailyCheckInEnabled 
                                    ? 'assets/images/daily_checkin.svg'
                                    : 'assets/images/daily_toggle_off.svg',
                                ),
                                Positioned(
                                  top: 12.h,
                                  left: 0,
                                  right: 0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/daily_toggle.svg',
                                      ),
                                      Positioned(
                                        left: 30.h,
                                        child: Text(
                                          "Daily Check-in",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 30.h,
                                        child: Transform.scale(
                                          scale: 0.9,
                                          child: CupertinoSwitch(
                                            value: _dailyCheckInEnabled,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _dailyCheckInEnabled = value;
                                              });
                                            },
                                            activeColor: CupertinoColors.systemGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_dailyCheckInEnabled)
                                  Positioned(
                                    top: 12.h + 55.h + 7.h,
                                    child: SvgPicture.asset(
                                      'assets/images/times_daily_checkin.svg',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: _dailyCheckInEnabled ? 7.h : 0),
                          Container(
                            width: 340.h,
                            height: _quoteEnabled ? 155.h : 79.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  _quoteEnabled 
                                    ? 'assets/images/quote_daily.svg'
                                    : 'assets/images/daily_toggle_off.svg',
                                  width: 340.h,
                                  height: _quoteEnabled ? 155.h : 79.h,
                                ),
                                Positioned(
                                  top: 12.h,
                                  left: 0,
                                  right: 0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/daily_toggle.svg',
                                      ),
                                      Positioned(
                                        left: 30.h,
                                        child: Text(
                                          "Quote of the Day",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 30.h,
                                        child: Transform.scale(
                                          scale: 0.9,
                                          child: CupertinoSwitch(
                                            value: _quoteEnabled,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _quoteEnabled = value;
                                              });
                                            },
                                            activeColor: CupertinoColors.systemGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_quoteEnabled)
                                  Positioned(
                                    top: 12.h + 55.h + 7.h,
                                    child: SvgPicture.asset(
                                      'assets/images/daily_toggle.svg',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: _dailyCheckInEnabled || _quoteEnabled ? 17.h : 12.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                // Handle next step
                              },
                              child: Container(
                                width: 130.h,
                                height: 60.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/next.svg',
                                      width: 109.h,
                                      height: 48.h,
                                    ),
                                    Text(
                                      "Next",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
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

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: _buildBackButton(),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
