import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../homescreen_screen/homescreen_screen.dart';

import 'models/discover_model.dart';
import 'provider/discover_provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  DiscoverScreenState createState() => DiscoverScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscoverProvider(),
      child: Builder(
        builder: (context) => DiscoverScreen(),
      ),
    );
  }
}

class DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    // any initialization logic here
  }
  
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    
    // Use in-app browser mode for iOS, external application for others
    final LaunchMode mode = Platform.isIOS 
      ? LaunchMode.inAppWebView 
      : LaunchMode.externalApplication;
    
    if (!await launchUrl(uri, mode: mode)) {
      // If launching fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                      'Discover',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/discover_desc.svg',
                      width: 375,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      left: 23,
                      right: 23,
                      child: Text(
                        'Explore insights and guidance to help you reflect, reset, and move forward with clarity.',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://www.apa.org/monitor/2012/07-08/ce-corner?utm_source=chatgpt.com'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/discover_box.svg',
                                  width: 375,
                                  height: 102,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 22,
                                  right: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'What Are the Benefits of Mindfulness?',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Summary: ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'The American Psychological Association discusses how mindfulness can enhance self-control, objectivity, affect tolerance, flexibility, equanimity, concentration, and mental clarity.',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 22.12,
                                  child: SvgPicture.asset(
                                    'assets/images/right_chevron_disc.svg',
                                    width: 15.08,
                                    height: 18.77,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://www.healthline.com/health/sleep-deprivation/effects-on-body'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/discover_box.svg',
                                  width: 375,
                                  height: 102,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 22,
                                  right: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'How Sleep Deprivation Impacts Mental Health',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Summary: ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Columbia Psychiatry examines the effects of poor or insufficient sleep on emotional responses and stress levels, highlighting the importance of sleep for mental well-being.',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 22.12,
                                  child: SvgPicture.asset(
                                    'assets/images/right_chevron_disc.svg',
                                    width: 15.08,
                                    height: 18.77,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://www.healthline.com/health/stress-vs-burnout'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/discover_box.svg',
                                  width: 375,
                                  height: 102,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 22,
                                  right: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Coping with Stress vs. Burnout: What\'s the Difference?',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Summary: ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'This article differentiates between stress and burnout, noting that stress is typically short-term, while burnout results from prolonged stress and leads to emotional exhaustion and reduced performance.. ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 22.12,
                                  child: SvgPicture.asset(
                                    'assets/images/right_chevron_disc.svg',
                                    width: 15.08,
                                    height: 18.77,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://www.psychiatry.org/news-room/apa-blogs/preventing-burnout-protecting-your-well-being'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/discover_box.svg',
                                  width: 375,
                                  height: 102,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 22,
                                  right: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Preventing Burnout in the Workplace',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Summary: ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Columbia University research on workplace burnout prevention, offering evidence-based approaches for individuals and organizations.',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 22.12,
                                  child: SvgPicture.asset(
                                    'assets/images/right_chevron_disc.svg',
                                    width: 15.08,
                                    height: 18.77,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () => _launchURL('https://www.psychiatry.org/patients-families/coping-after-disaster-trauma'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/discover_box.svg',
                                  width: 375,
                                  height: 102,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 22,
                                  right: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Coping After Disaster',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Summary: ',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Provides guidance on coping with trauma after natural disasters, with specific techniques for managing emotional responses and building resilience.',
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 22.12,
                                  child: SvgPicture.asset(
                                    'assets/images/right_chevron_disc.svg',
                                    width: 15.08,
                                    height: 18.77,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
