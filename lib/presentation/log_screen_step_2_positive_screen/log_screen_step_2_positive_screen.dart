import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_screen/log_screen.dart';
import '../log_screen_step_3_positive_screen/log_screen_step_3_positive_screen.dart';
import '../log_screen_step_2_negative_page/log_screen_step_2_negative_screen.dart';

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
  // Add a Set to track selected button indices
  final Set<int> selectedButtons = {};
  List<String> selectedFeelings = [];
  
  // Static variable to store selected positive feelings
  static List<String> selectedPositiveFeelings = [];
  
  // Static variable to store selected button indices
  static Set<int> storedSelectedButtons = {};

  @override
  void initState() {
    super.initState();
    // Initialize selectedButtons from stored values
    selectedButtons.addAll(storedSelectedButtons);
    // Update the static variable
    selectedPositiveFeelings = getSelectedFeelings();
  }

  @override
  void dispose() {
    // Save state when the screen is disposed
    storedSelectedButtons = Set.from(selectedButtons);
    selectedPositiveFeelings = getSelectedFeelings();
    super.dispose();
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
      selectedPositiveFeelings = getSelectedFeelings();
    });
  }

  // Helper method to get selected feelings
  List<String> getSelectedFeelings() {
    List<String> feelings = [];
    if (selectedButtons.contains(0)) feelings.add('Calm');
    if (selectedButtons.contains(1)) feelings.add('Confident');
    if (selectedButtons.contains(2)) feelings.add('Eager');
    if (selectedButtons.contains(3)) feelings.add('Ecstatic');
    if (selectedButtons.contains(4)) feelings.add('Engaged');
    if (selectedButtons.contains(5)) feelings.add('Excited');
    if (selectedButtons.contains(6)) feelings.add('Grateful');
    if (selectedButtons.contains(7)) feelings.add('Happy');
    if (selectedButtons.contains(8)) feelings.add('Hopeful');
    if (selectedButtons.contains(9)) feelings.add('Motivated');
    if (selectedButtons.contains(10)) feelings.add('Optimistic');
    if (selectedButtons.contains(11)) feelings.add('Peaceful');
    if (selectedButtons.contains(12)) feelings.add('Proud');
    if (selectedButtons.contains(13)) feelings.add('Relaxed');
    if (selectedButtons.contains(14)) feelings.add('Satisfied');
    if (selectedButtons.contains(15)) feelings.add('Cheerful');
    if (selectedButtons.contains(16)) feelings.add('Playful');
    if (selectedButtons.contains(17)) feelings.add('Refreshed');
    if (selectedButtons.contains(18)) feelings.add('Energized');
    if (selectedButtons.contains(19)) feelings.add('Joyful');
    if (selectedButtons.contains(20)) feelings.add('Lively');
    if (selectedButtons.contains(21)) feelings.add('Satisfied');
    if (selectedButtons.contains(22)) feelings.add('Content');
    if (selectedButtons.contains(23)) feelings.add('Grateful');
    if (selectedButtons.contains(24)) feelings.add('Lively');
    if (selectedButtons.contains(25)) feelings.add('Thrilled');
    if (selectedButtons.contains(26)) feelings.add('Wonderful');
    return feelings;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Save the current state before popping
        storedSelectedButtons = Set.from(selectedButtons);
        selectedPositiveFeelings = getSelectedFeelings();
        return true;
      },
      child: Scaffold(
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
                    if (details.primaryVelocity! < 0) { // Swipe from right to left
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep2NegativePage.builder(context),
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
                                          'assets/images/positive-selected.svg',
                                          width: 276.h,
                                          height: 44.h,
                                        ),
                                      ),
                                      Positioned(
                                        left: 38.h,
                                        top: 11.h,
                                        child: Text(
                                          "Positive",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(0.96),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 170.h,
                                        top: 11.h,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep2NegativePage.builder(context),
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
                                              color: Colors.white.withOpacity(0.8),
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(0),
                                              child: Center(
                                                child: Text(
                                                  'Calm',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(1),
                                              child: Center(
                                                child: Text(
                                                  'Confident',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(2),
                                              child: Center(
                                                child: Text(
                                                  'Eager',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(3),
                                              child: Center(
                                                child: Text(
                                                  'Ecstatic',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(4),
                                              child: Center(
                                                child: Text(
                                                  'Engaged',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(5),
                                              child: Center(
                                                child: Text(
                                                  'Excited',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(6),
                                              child: Center(
                                                child: Text(
                                                  'Grateful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(7),
                                              child: Center(
                                                child: Text(
                                                  'Happy',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(8),
                                              child: Center(
                                                child: Text(
                                                  'Hopeful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(9),
                                              child: Center(
                                                child: Text(
                                                  'Motivated',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(10),
                                              child: Center(
                                                child: Text(
                                                  'Optimistic',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(11),
                                              child: Center(
                                                child: Text(
                                                  'Peaceful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(12),
                                              child: Center(
                                                child: Text(
                                                  'Proud',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(13),
                                              child: Center(
                                                child: Text(
                                                  'Relaxed',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(14),
                                              child: Center(
                                                child: Text(
                                                  'Satisfied',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(15),
                                              child: Center(
                                                child: Text(
                                                  'Cheerful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(16),
                                              child: Center(
                                                child: Text(
                                                  'Playful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(17),
                                              child: Center(
                                                child: Text(
                                                  'Refreshed',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(18),
                                              child: Center(
                                                child: Text(
                                                  'Energized',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(19),
                                              child: Center(
                                                child: Text(
                                                  'Joyful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(20),
                                              child: Center(
                                                child: Text(
                                                  'Lively',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(21),
                                              child: Center(
                                                child: Text(
                                                  'Satisfied',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(22),
                                              child: Center(
                                                child: Text(
                                                  'Content',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(23),
                                              child: Center(
                                                child: Text(
                                                  'Grateful',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(24),
                                              child: Center(
                                                child: Text(
                                                  'Lively',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(25),
                                              child: Center(
                                                child: Text(
                                                  'Thrilled',
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
                                            top: 6.h,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => toggleButton(26),
                                              child: Center(
                                                child: Text(
                                                  'Wonderful',
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
                        // Save current state before navigating
                        storedSelectedButtons = Set.from(selectedButtons);
                        selectedPositiveFeelings = getSelectedFeelings();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogScreenStep3PositiveScreen(
                              selectedFeelings: getSelectedFeelings(),
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
                          // Save current state before navigating
                          storedSelectedButtons = Set.from(selectedButtons);
                          selectedPositiveFeelings = getSelectedFeelings();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogScreenStep3PositiveScreen(
                                selectedFeelings: getSelectedFeelings(),
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
              // Save the current state before navigating back
              storedSelectedButtons = Set.from(selectedButtons);
              selectedPositiveFeelings = getSelectedFeelings();
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
