import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';

import 'models/beneathlittlelifts_one_model.dart';
import 'provider/beneathlittlelifts_one_provider.dart';

class BeneathlittleliftsOneScreen extends StatefulWidget {
  const BeneathlittleliftsOneScreen({Key? key}) : super(key: key);

  @override
  BeneathlittleliftsOneScreenState createState() => BeneathlittleliftsOneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeneathlittleliftsOneProvider(),
      child: Builder(
        builder: (context) => BeneathlittleliftsOneScreen(),
      ),
    );
  }
}

class BeneathlittleliftsOneScreenState extends State<BeneathlittleliftsOneScreen> {
  @override
  void initState() {
    super.initState();
    // any initialization logic here
  }

  // Method to launch URL in in-app browser
  Future<void> _launchInAppBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Helper method to create a box widget with fully customizable content and layout
  Widget _createBoxWithContent({
    required String iconPath,
    required String title,
    required String description,
    required String sourceText,
    required String url,
    double iconWidth = 24,
    double iconHeight = 25,
    double iconLeft = 16,
    double iconTop = 11,
    double titleLeft = 44,
    double titleTop = 20,
    double titleFontSize = 13,
    double descriptionLeft = 16,
    double descriptionTop = 39,
    double descriptionWidth = 341,
    double descriptionHeight = 1.2,
    double descriptionFontSize = 11,
    double linkLeft = 13,
    double linkBottom = 19,
    double linkWidth = 347,
    double linkHeight = 25,
    double sourceLeft = 22,
    double sourceBottom = 26,
    double sourceFontSize = 8.5,
  }) {
    return Center(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/btll_box.svg',
            width: 373,
            height: 157,
            fit: BoxFit.contain,
          ),
          // Icon and text
          Positioned(
            left: iconLeft,
            top: iconTop,
            child: SvgPicture.asset(
              iconPath,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
          Positioned(
            left: titleLeft,
            top: titleTop,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: descriptionLeft,
            top: descriptionTop,
            width: descriptionWidth,
            child: Text(
              description,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: descriptionFontSize,
                fontWeight: FontWeight.w600,
                height: descriptionHeight,
              ),
            ),
          ),
          // bll_box_link.svg centered
          Positioned(
            left: linkLeft,
            bottom: linkBottom,
            child: GestureDetector(
              onTap: () async {
                await _launchInAppBrowser(url);
              },
              child: SvgPicture.asset(
                'assets/images/bll_box_link.svg',
                width: linkWidth,
                height: linkHeight,
              ),
            ),
          ),
          // Source text on bll_box_link
          Positioned(
            left: sourceLeft,
            bottom: sourceBottom,
            child: GestureDetector(
              onTap: () async {
                await _launchInAppBrowser(url);
              },
              child: Text(
                sourceText,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: sourceFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: _buildAppbar(context),
        body: Stack(
          children: [
            // Background container
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.h, top: 0.h),
                    child: Text(
                      'Beneath the Little Lifts',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 11.h, top: 6.h),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/beneath_desc.svg',
                          width: 383,
                          height: 35,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          left: 11,
                          top: 5,
                          child: Text(
                            'What the research says about your feel-good rituals.',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              // Box 1 - Workout
                              _createBoxWithContent(
                                iconPath: 'assets/images/workout_bll.svg',
                                title: 'Workout',
                                description: 'Exercise is a powerful, natural way to improve mental health. It boosts mood by releasing endorphins and can be as effective as antidepressants for some people with mild depression. Regular movement also strengthens the brain\'s emotional resilience and reduces anxiety, stress, and sleep problems.',
                                sourceText: 'Source: Exercise is an all-natural treatment to fight depression – Harvard Health',
                                url: 'https://www.health.harvard.edu/mind-and-mood/exercise-is-an-all-natural-treatment-to-fight-depression',
                                iconWidth: 24,
                                iconHeight: 25,
                                iconLeft: 16,
                                iconTop: 11,
                                titleLeft: 44,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 19,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 22,
                                sourceBottom: 26,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 2 - Mindfulness
                              _createBoxWithContent(
                                iconPath: 'assets/images/mindfulness_bll.svg',
                                title: 'Mindfulness',
                                description: 'Meditation supports mental health by calming the body\'s stress response, lowering cortisol, and promoting emotional balance. Research from Harvard Medical School found that mindfulness meditation can ease anxiety, depression, and even physical pain with effects comparable to antidepressants in some cases.',
                                sourceText: 'Source: What meditation can do for your mind, mood, and health – Harvard Health',
                                url: 'https://www.health.harvard.edu/staying-healthy/what-meditation-can-do-for-your-mind-mood-and-health-',
                                iconWidth: 26,
                                iconHeight: 26,
                                iconLeft: 15,
                                iconTop: 10,
                                titleLeft: 43,
                                titleTop: 19,
                                titleFontSize: 13,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 17,
                                sourceLeft: 20,
                                sourceBottom: 24,
                                sourceFontSize: 8,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 3 - Breathing
                              _createBoxWithContent(
                                iconPath: 'assets/images/breathing_bll.svg',
                                title: 'Breathing',
                                description: 'Deep, mindful breathing activates the body\'s natural relaxation response, quickly calming the mind and reducing stress. Even a few minutes of breath-focused attention can lower heart rate, ease anxiety, and support better sleep over time.',
                                sourceText: 'Source: Breath meditation: A great way to relieve stress – Harvard Health',
                                url: 'https://www.health.harvard.edu/mind-and-mood/breath-meditation-a-great-way-to-relieve-stress',
                                iconWidth: 26,
                                iconHeight: 22,
                                iconLeft: 16,
                                iconTop: 12,
                                titleLeft: 46,
                                titleTop: 19,
                                descriptionHeight: 1.3,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 8.2,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 4 - Movie Time
                              _createBoxWithContent(
                                iconPath: 'assets/images/movie_bll.svg', // Replace with nutrition icon
                                title: 'Movie Time',
                                description: 'Movies can offer emotional release, lower stress hormones, and reduce feelings of loneliness. Whether laughing at a comedy or crying with a character, films help regulate emotions and remind us we\'re not alone.',
                                sourceText: 'Source: How Watching Movies Can Benefit Our Mental Health – Psych Central',
                                url: 'https://psychcentral.com/blog/how-watching-movies-can-benefit-our-mental-health', // Replace with actual nutrition URL
                                iconWidth: 24,
                                iconHeight: 25,
                                iconLeft: 16,
                                iconTop: 11,
                                titleLeft: 44,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 29,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 36,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 5 - Music
                              _createBoxWithContent(
                                iconPath: 'assets/images/music_bll.svg', // Replace with social icon
                                title: 'Music',
                                description: 'Music soothes the nervous system, uplifts mood, and helps process emotions. Whether calming or energizing, it reduces anxiety, improves mental clarity, and supports healing - which is why it\'s often called medicine for the mind.',
                                sourceText: 'Source: Can music improve our health and quality of life? – Harvard Health',
                                url: 'https://www.health.harvard.edu/blog/can-music-improve-our-health-and-quality-of-life-202207252786', // Replace with actual social URL
                                iconWidth: 24,
                                iconHeight: 25,
                                iconLeft: 16,
                                iconTop: 11,
                                titleLeft: 44,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 29,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 36,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 6 - Nature
                              _createBoxWithContent(
                                iconPath: 'assets/images/book_bll.svg', // Replace with nature icon
                                title: 'Read a book',
                                description: 'Reading is a gentle way to calm the mind and ease stress — even a few minutes can lower stress levels by up to 68%. Immersing in a story helps you unwind, improves sleep, and builds empathy, especially through fiction.',
                                sourceText: 'Source: Health Benefits of Reading Books – WebMD',
                                url: 'https://www.webmd.com/balance/health-benefits-of-reading-books', // Replace with actual nature URL
                                iconWidth: 18,
                                iconHeight: 19,
                                iconLeft: 16,
                                iconTop: 15,
                                titleLeft: 44,
                                titleTop: 20,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 29,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 36,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 7 - Affirmations
                              _createBoxWithContent(
                                iconPath: 'assets/images/affirmation_bll.svg',
                                title: 'Affirmations',
                                description: 'Affirmations are positive statements that promote self-belief and motivation. Scientific studies suggest they can improve self-esteem, resilience, and overall well-being. By replacing negative thought patterns, affirmations encourage productive responses to challenges and may reduce stress-related health issues.',
                                sourceText: 'Source: The Science Of Affirmations: The Brain\'s Response To Positive Thinking - MentalHealth.com',
                                url: 'https://www.mentalhealth.com/tools/science-of-affirmations',
                                iconWidth: 22,
                                iconHeight: 22,
                                iconLeft: 16,
                                iconTop: 12,
                                titleLeft: 42,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 6.8,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 8 - Creative Expression
                              _createBoxWithContent(
                                iconPath: 'assets/images/cooking_bll.svg', // Replace with creativity icon
                                title: 'Cooking',
                                description: 'Cooking your own meals offers significant mental health benefits. It fosters creativity, builds self-esteem, and encourages routine. Preparing food can reduce stress, support brain health, and enhance social connections. Embracing cooking can lead to improved overall well-being.',
                                sourceText: 'Source: Cooking Your Own Food Can Make a Big Difference to Your Mental Health – Verywell Mind',
                                url: 'https://www.verywellmind.com/mental-health-benefits-of-cooking-your-own-food-5248624', // Replace with actual creativity URL
                                iconWidth: 21,
                                iconHeight: 22,
                                iconLeft: 16,
                                iconTop: 12,
                                titleLeft: 47,
                                titleTop: 20,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 7,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 9 - Learning
                              _createBoxWithContent(
                                iconPath: 'assets/images/travel_bll.svg', // Replace with learning icon
                                title: 'Travel Plans',
                                description: 'Traveling offers mental health benefits by reducing stress, enhancing creativity, and improving cognitive function. It provides a break from routine, allowing the mind to relax and reset. Exposure to new environments stimulates mental well-being and can alleviate symptoms of anxiety and depression.',
                                sourceText: 'Source: How Travel Affects Mental Health – WebMD',
                                url: 'https://www.webmd.com/mental-health/how-travel-affects-mental-health', // Replace with actual learning URL
                                iconWidth: 19,
                                iconHeight: 20,
                                iconLeft: 16,
                                iconTop: 13,
                                titleLeft: 45,
                                titleTop: 20,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 10 - Volunteering
                              _createBoxWithContent(
                                iconPath: 'assets/images/safety_net_bll.svg', // Replace with volunteering icon
                                title: 'Safety Net',
                                description: 'Social connection is vital for mental and physical health. It enhances longevity, strengthens immunity, and reduces anxiety. Feeling connected boosts self-esteem and empathy, creating a positive loop of well-being. Conversely, loneliness increases health risks and distress.',
                                sourceText: 'Source: Connectedness & Health: The Science of Social Connection – Stanford',
                                url: 'https://ccare.stanford.edu/uncategorized/connectedness-health-the-science-of-social-connection-infographic/', // Replace with actual volunteering URL
                                iconWidth: 20,
                                iconHeight: 21,
                                iconLeft: 16,
                                iconTop: 14,
                                titleLeft: 57,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 8.5,
                              ),
                              SizedBox(height: 15.h),
                              
                              // Box 11 - Journaling
                              _createBoxWithContent(
                                iconPath: 'assets/images/soft_thanks_bll.svg',
                                title: 'Soft Thanks',
                                description: 'Keeping a gratitude log boosts mental well-being by fostering optimism, easing depression, and strengthening emotional resilience. Regularly noting small positives helps shift focus from stress to joy, training the mind to recognize and appreciate the good more often.',
                                sourceText: 'Source: Giving thanks can make you happier – Harvard Health',
                                url: 'https://www.health.harvard.edu/healthbeat/giving-thanks-can-make-you-happier',
                                iconWidth: 22,
                                iconHeight: 23,
                                iconLeft: 16,
                                iconTop: 12,
                                titleLeft: 45,
                                titleTop: 20,
                                titleFontSize: 13,
                                descriptionLeft: 16,
                                descriptionTop: 39, 
                                descriptionWidth: 341,
                                descriptionHeight: 1.2,
                                descriptionFontSize: 11,
                                linkLeft: 13,
                                linkBottom: 27,
                                linkWidth: 347,
                                linkHeight: 25,
                                sourceLeft: 20,
                                sourceBottom: 34,
                                sourceFontSize: 7.5,
                              ),
                            ],
                          ),
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
    );
  }
  
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
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
          ),
        ],
      ),
    );
  }
}
