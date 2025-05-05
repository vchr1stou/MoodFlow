import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'models/breathingmain_model.dart';
import 'provider/breathingmain_provider.dart';
import '../little_lifts_screen/little_lifts_screen.dart';
import '../inhale_screen/inhale_screen.dart';

class BreathingmainScreen extends StatefulWidget {
  const BreathingmainScreen({Key? key}) : super(key: key);

  @override
  BreathingmainScreenState createState() => BreathingmainScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BreathingmainProvider(),
      child: const BreathingmainScreen(),
    );
  }
}

class BreathingmainScreenState extends State<BreathingmainScreen> {
  int duration = 1;

  void incrementDuration() {
    setState(() {
      duration++;
    });
  }

  void decrementDuration() {
    setState(() {
      if (duration > 1) {
        duration--;
      }
    });
  }

  void navigateToInhale() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InhaleScreen.builder(context),
        settings: RouteSettings(
          arguments: {'duration': duration},
        ),
      ),
    );
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LittleLiftsScreen.builder(context),
                          ),
                          (route) => false,
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
                            'Little Lifts',
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
              ),
              SizedBox(height: 64),
              Center(
                child: Image.asset(
                  'assets/images/breathing.png',
                  width: 150,
                  height: 178,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 0),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Text(
                    'Breathing',
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/breathing_desc.svg',
                      width: 354,
                      height: 163,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      left: 20,
                      right: 40,
                      child: Text(
                        'Find a quiet, cozy spot where you feel safe.\nClose your eyes if you\'d like, and let go of whatever\'s weighing on you...\nThis is your time to pause, breathe, and come back to yourself...',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.41,
                          height: 25/14, // line height of 25px relative to font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Set duration',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 364,
                          child: SvgPicture.asset(
                            'assets/images/set_duration.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          right: 95,
                          child: GestureDetector(
                            onTap: incrementDuration,
                            child: SvgPicture.asset(
                              'assets/images/set_duration_plus.svg',
                              width: 41,
                              height: 42,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 95,
                          child: GestureDetector(
                            onTap: decrementDuration,
                            child: SvgPicture.asset(
                              'assets/images/set_duration_minus.svg',
                              width: 41,
                              height: 42,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '$duration min',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: navigateToInhale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/start_breathing.svg',
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: const Offset(0, -5),
                          child: Center(
                            child: Text(
                              'Begin',
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
        ),
      ),
    );
  }
}
