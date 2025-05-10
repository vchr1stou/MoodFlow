import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_screen/log_screen.dart';
import '../log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import '../log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';
import '../log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';

class LogScreenStep2NegativePage extends StatefulWidget {
  const LogScreenStep2NegativePage({Key? key}) : super(key: key);

  @override
  LogScreenStep2NegativePageState createState() =>
      LogScreenStep2NegativePageState();

  static Widget builder(BuildContext context) {
    return const LogScreenStep2NegativePage();
  }
}

class LogScreenStep2NegativePageState
    extends State<LogScreenStep2NegativePage> {
  // Add a Set to track selected button indices
  final Set<int> selectedButtons = {};
  
  // Static variable to store selected negative feelings
  static List<String> selectedNegativeFeelings = [];
  
  // Static variable to store selected button indices
  static Set<int> storedSelectedButtons = {};

  @override
  void initState() {
    super.initState();
    // Initialize selectedButtons from stored values
    selectedButtons.addAll(storedSelectedButtons);
    // Update the static variable
    selectedNegativeFeelings = getSelectedFeelings();
  }

  // Helper method to toggle button state
  void toggleButton(int index) {
    setState(() {
      if (selectedButtons.contains(index)) {
        selectedButtons.remove(index);
      } else {
        selectedButtons.add(index);
      }
      // Update the static variables
      storedSelectedButtons = Set.from(selectedButtons);
      selectedNegativeFeelings = getSelectedFeelings();
    });
  }

  // Helper method to get selected feelings
  List<String> getSelectedFeelings() {
    List<String> feelings = [];
    if (selectedButtons.contains(0)) feelings.add('Angry');
    if (selectedButtons.contains(1)) feelings.add('Afraid');
    if (selectedButtons.contains(2)) feelings.add('Annoyed');
    if (selectedButtons.contains(3)) feelings.add('Anxious');
    if (selectedButtons.contains(4)) feelings.add('Bored');
    if (selectedButtons.contains(5)) feelings.add('Confused');
    if (selectedButtons.contains(6)) feelings.add('Disgusted');
    if (selectedButtons.contains(7)) feelings.add('Ashamed');
    if (selectedButtons.contains(8)) feelings.add('Jealous');
    if (selectedButtons.contains(9)) feelings.add('Lonely');
    if (selectedButtons.contains(10)) feelings.add('Sad');
    if (selectedButtons.contains(11)) feelings.add('Stressed');
    if (selectedButtons.contains(12)) feelings.add('Empty');
    if (selectedButtons.contains(13)) feelings.add('Exhausted');
    if (selectedButtons.contains(14)) feelings.add('Worried');
    if (selectedButtons.contains(15)) feelings.add('Irritated');
    if (selectedButtons.contains(16)) feelings.add('Numb');
    if (selectedButtons.contains(17)) feelings.add('Tired');
    if (selectedButtons.contains(18)) feelings.add('Letharic');
    if (selectedButtons.contains(19)) feelings.add('Furious');
    if (selectedButtons.contains(20)) feelings.add('Guilty');
    if (selectedButtons.contains(21)) feelings.add('Insecure');
    if (selectedButtons.contains(22)) feelings.add('Depressed');
    if (selectedButtons.contains(23)) feelings.add('Embarassed');
    if (selectedButtons.contains(24)) feelings.add('Burnt out');
    if (selectedButtons.contains(25)) feelings.add('Resentful');
    if (selectedButtons.contains(26)) feelings.add('Worried');
    return feelings;
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
          fit: StackFit.expand,
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
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) { // Swipe from left to right
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep2PositiveScreen.builder(context),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          );
                          var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          );
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: ScaleTransition(
                              scale: scaleAnimation,
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 400),
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              SizedBox(
                                width: 276.h,
                                height: 44.h,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned.fill(
                                      child: SvgPicture.asset(
                                        'assets/images/negative-selected.svg',
                                        width: 276.h,
                                        height: 44.h,
                                      ),
                                    ),
                                    Positioned(
                                      left: 38.h,
                                      top: 11.h,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep2PositiveScreen.builder(context),
                                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                );
                                                var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                );
                                                return FadeTransition(
                                                  opacity: fadeAnimation,
                                                  child: ScaleTransition(
                                                    scale: scaleAnimation,
                                                    child: child,
                                                  ),
                                                );
                                              },
                                              transitionDuration: Duration(milliseconds: 400),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Positive",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 173.h,
                                      top: 11.h,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep3PositiveScreen(),
                                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                );
                                                var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                );
                                                return FadeTransition(
                                                  opacity: fadeAnimation,
                                                  child: ScaleTransition(
                                                    scale: scaleAnimation,
                                                    child: child,
                                                  ),
                                                );
                                              },
                                              transitionDuration: Duration(milliseconds: 400),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Negative",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(0.96),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Stack(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/positive_box.svg',
                                    width: 364.h,
                                    height: 486.h,
                                  ),
                                  // First row
                                  Positioned(
                                    top: 14.4.h,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(0),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(0)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(0),
                                            child: Center(
                                              child: Text(
                                                'Angry',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(1),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(1)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(1),
                                            child: Center(
                                              child: Text(
                                                'Afraid',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(2),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(2)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(2),
                                            child: Center(
                                              child: Text(
                                                'Annoyed',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Second row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h),
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(3),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(3)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(3),
                                            child: Center(
                                              child: Text(
                                                'Anxious',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h),
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(4),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(4)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(4),
                                            child: Center(
                                              child: Text(
                                                'Bored',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h),
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(5),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(5)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(5),
                                            child: Center(
                                              child: Text(
                                                'Confused',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Third row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 2,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(6),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(6)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(6),
                                            child: Center(
                                              child: Text(
                                                'Disgusted',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 2,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(7),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(7)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(7),
                                            child: Center(
                                              child: Text(
                                                'Ashamed',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 2,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(8),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(8)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(8),
                                            child: Center(
                                              child: Text(
                                                'Jealous',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Fourth row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 3,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(9),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(9)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(9),
                                            child: Center(
                                              child: Text(
                                                'Lonely',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 3,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(10),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(10)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(10),
                                            child: Center(
                                              child: Text(
                                                'Sad',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 3,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(11),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(11)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(11),
                                            child: Center(
                                              child: Text(
                                                'Stressed',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Fifth row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 4,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(12),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(12)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(12),
                                            child: Center(
                                              child: Text(
                                                'Empty',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 4,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(13),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(13)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(13),
                                            child: Center(
                                              child: Text(
                                                'Exhausted',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 4,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(14),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(14)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(14),
                                            child: Center(
                                              child: Text(
                                                'Worried',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Sixth row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 5,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(15),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(15)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(15),
                                            child: Center(
                                              child: Text(
                                                'Irritated',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 5,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(16),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(16)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(16),
                                            child: Center(
                                              child: Text(
                                                'Numb',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 5,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(17),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(17)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(17),
                                            child: Center(
                                              child: Text(
                                                'Tired',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Seventh row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 6,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(18),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(18)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(18),
                                            child: Center(
                                              child: Text(
                                                'Letharic',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 6,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(19),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(19)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(19),
                                            child: Center(
                                              child: Text(
                                                'Furious',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 6,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(20),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(20)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(20),
                                            child: Center(
                                              child: Text(
                                                'Guilty',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Eighth row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 7,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(21),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(21)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(21),
                                            child: Center(
                                              child: Text(
                                                'Insecure',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 7,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(22),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(22)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(22),
                                            child: Center(
                                              child: Text(
                                                'Depressed',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 7,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(23),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(23)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(23),
                                            child: Center(
                                              child: Text(
                                                'Embarassed',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Ninth row
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 8,
                                    left: 8.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(24),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(24)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(24),
                                            child: Center(
                                              child: Text(
                                                'Burnt out',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 8,
                                    left: 127.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(25),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(25)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(25),
                                            child: Center(
                                              child: Text(
                                                'Resentful',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 14.4.h + (38.h + 14.4.h) * 8,
                                    left: 245.5.h,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => toggleButton(26),
                                          child: SvgPicture.asset(
                                            selectedButtons.contains(26)
                                                ? 'assets/images/positive_button_2.svg'
                                                : 'assets/images/positive_button.svg',
                                            width: 110.h,
                                            height: 38.h,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => toggleButton(26),
                                            child: Center(
                                              child: Text(
                                                'Worried',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // Next button with absolute positioning
            Positioned(
              right: 12.h,
              bottom: 50.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogScreenStep3NegativeScreen(
                            selectedFeelings: selectedNegativeFeelings,
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/images/next_log.svg',
                      width: 142.h,
                      height: 42.h,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogScreenStep3NegativeScreen(
                              selectedFeelings: selectedNegativeFeelings,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: 'Roboto',
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
