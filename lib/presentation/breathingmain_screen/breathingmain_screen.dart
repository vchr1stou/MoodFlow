import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'models/breathingmain_model.dart';
import 'provider/breathingmain_provider.dart';
import '../little_lifts_screen/little_lifts_screen.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
