import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_export.dart';
import '../log_input_screen/log_input_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';

import 'models/history_empty_model.dart';
import 'provider/history_empty_provider.dart';

class HistoryEmptyScreen extends StatefulWidget {
  const HistoryEmptyScreen({Key? key}) : super(key: key);

  @override
  HistoryEmptyScreenState createState() => HistoryEmptyScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryEmptyProvider(),
      child: const HistoryEmptyScreen(),
    );
  }
}

class HistoryEmptyScreenState extends State<HistoryEmptyScreen> {
  final String mainText = 'Bright stories start on blank pages.';
  final String subText = 'When you\'re ready, press record on how you feel.';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    HomescreenScreen.builder(context),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/chevron.backward.svg',
                                width: 9,
                                height: 17,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Home',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'History',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(4, 0.3),
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/chevronl.svg',
                          width: 7,
                          height: 13,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(1),
                            BlendMode.srcIn,
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SUN, MARCH 30',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Transform.translate(
                      offset: Offset(-4, 0.3),
                      child: Container(
                        child: Transform.rotate(
                          angle: 3.14159, // 180 degrees in radians
                          child: SvgPicture.asset(
                            'assets/images/chevronl.svg',
                            width: 7,
                            height: 13,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(1),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, -10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -30,
                          child: Container(
                            width: 340,
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.02),
                                  Color(0xFF666666).withOpacity(0.02),
                                ],
                                stops: [0.0, 0.54],
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/history_add.svg',
                          width: 340,
                          height: 342,
                        ),
                        Positioned(
                          top: 60,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                mainText,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                subText,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogInputScreen.builder(
                                    context,
                                    source: 'history'),
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
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
