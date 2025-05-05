import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../breathingmain_screen/breathingmain_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';

class BreathingdoneScreen extends StatefulWidget {
  const BreathingdoneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  BreathingdoneScreenState createState() => BreathingdoneScreenState();
  static Widget builder(BuildContext context) {
    return const BreathingdoneScreen();
  }
}

class BreathingdoneScreenState extends State<BreathingdoneScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 209),
              Image.asset(
                'assets/images/breathing.png',
                width: 148,
                height: 160,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                'Well Done',
                style: GoogleFonts.roboto(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 22/40,
                ),
              ),
              SizedBox(height: 18),
              Text(
                'The world can wait. You just chose you.',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.41,
                  height: 22/20,
                ),
              ),
              SizedBox(height: 200),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomescreenScreen.builder(context),
                    ),
                    (route) => false,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/return_breathing.svg',
                      width: 128.67,
                      height: 46,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: -5,
                      bottom: 0,
                      left: 0,
                      right: 1,
                      child: Center(
                        child: Text(
                          'Return',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }
}
