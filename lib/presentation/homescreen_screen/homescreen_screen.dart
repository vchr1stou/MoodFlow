import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/appbar_trailing_button.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../breathingmain_screen/breathingmain_screen.dart';
import '../streak_screen/streak_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../history_empty_screen/history_empty_screen.dart';
import '../discover_screen/discover_screen.dart';
import '../statistics_mood_charts_screen/statistics_mood_charts_screen.dart';
import '../log_input_screen/log_input_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/homescreen_model.dart';
import 'provider/homescreen_provider.dart';

class HomescreenScreen extends StatefulWidget {
  const HomescreenScreen({Key? key}) : super(key: key);

  @override
  HomescreenScreenState createState() => HomescreenScreenState();

  static Widget builder(BuildContext context) {
    return HomescreenScreen();
  }
}

class HomescreenScreenState extends State<HomescreenScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            _buildHeader(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      _buildQuoteCard(),
                      SizedBox(height: 13),
                      _buildFeelingCard(),
                      SizedBox(height: 13),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatisticsCard(),
                            SizedBox(height: 13),
                            _buildActionButtons(),
                            SizedBox(height: 23),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME BACK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5),
            Text(
              'Vasilis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreakScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: SvgPicture.asset(
                          'assets/images/streak_flame.svg',
                          width: 66,
                          height: 34,
                        ),
                      ),
                      Positioned(
                        top: 9.5,
                        left: 40,
                        child: Text(
                          '7',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Press and hold to start SOS'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BreathingmainScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/images/sos_button.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: SvgPicture.asset(
                      'assets/images/person.crop.circle.fill.svg',
                      width: 37,
                      height: 37,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 69.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/quote.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace + 85,
                right: sideSpace + 40,
                top: 31,
                child: Text(
                  'Every step toward healing lights the path for someone else',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeelingCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 219.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/haf_box.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace,
                right: sideSpace,
                child: SizedBox(
                  height: cardHeight,
                  child: Padding(
                    padding: EdgeInsets.all(33),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 27),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInputScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatisticsMoodChartsScreen(),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = 340.0;
          double cardHeight = 205.0;
          double sideSpace = (constraints.maxWidth - cardWidth) / 2;

          return Container(
            width: constraints.maxWidth,
            height: cardHeight,
            child: Stack(
              children: [
                Positioned(
                  left: sideSpace,
                  child: SvgPicture.asset(
                    'assets/images/statistics_home_box.svg',
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: sideSpace,
                  right: sideSpace,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Statistics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatBar('Mon', 0.8),
                            _buildStatBar('Tue', 0.6),
                            _buildStatBar('Wed', 0.7),
                            _buildStatBar('Thu', 0.9),
                            _buildStatBar('Fri', 0.5),
                            _buildStatBar('Sat', 0.6),
                            _buildStatBar('Sun', 0.4, isSelected: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatBar(String day, double height, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 100,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 30,
                height: 100 * height,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: isSelected
              ? BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 340.0;
        double cardHeight = 69.0;
        double buttonWidth = 150.0;
        double buttonHeight = 40.0;
        double sideSpace = (constraints.maxWidth - cardWidth) / 2;

        return Container(
          width: constraints.maxWidth,
          height: cardHeight,
          child: Stack(
            children: [
              Positioned(
                left: sideSpace,
                child: SvgPicture.asset(
                  'assets/images/show_history_discovery_wrapper.svg',
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: sideSpace,
                right: sideSpace,
                top: (cardHeight - buttonHeight) / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryEmptyScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/show_history_wrapper.svg',
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Show History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(top: 0.8),
                                child: SvgPicture.asset(
                                  'assets/images/chevron_right.svg',
                                  width: 7,
                                  height: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverScreen(),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/show_history_wrapper.svg',
                            width: buttonWidth,
                            height: buttonHeight,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Discover',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(top: 0.8),
                                child: SvgPicture.asset(
                                  'assets/images/chevron_right.svg',
                                  width: 7,
                                  height: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
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
          SvgPicture.asset(
            'assets/images/bottom_bar_home_pressed.svg',
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            bottom: 4,
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

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassButton({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
