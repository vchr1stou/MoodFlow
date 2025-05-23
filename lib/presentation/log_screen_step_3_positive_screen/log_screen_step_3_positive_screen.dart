import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../log_screen_step_four_screen/log_screen_step_four_screen.dart';
import '../log_screen_step_3_negative_screen/log_screen_step_3_negative_screen.dart';
import '../log_screen_step_2_negative_page/log_screen_step_2_negative_screen.dart';
import '../log_screen_step_2_positive_screen/log_screen_step_2_positive_screen.dart';

// ignore_for_file: must_be_immutable
class LogScreenStep3PositiveScreen extends StatefulWidget {
  const LogScreenStep3PositiveScreen({Key? key}) : super(key: key);

  @override
  LogScreenStep3PositiveScreenState createState() =>
      LogScreenStep3PositiveScreenState();

  static Widget builder(BuildContext context) {
    return const LogScreenStep3PositiveScreen();
  }

  // Add static method to reset all SVG types
  static void resetSvgTypes() {
    // Reset all SVG types to their default state
    LogScreenStep3PositiveScreenState.storedSliderValues.clear();
    print('Reset positive slider values');
  }
}

class LogScreenStep3PositiveScreenState
    extends State<LogScreenStep3PositiveScreen> {
  // Map to store slider values for each feeling
  final Map<String, double> sliderValues = {};
  final ScrollController _scrollController = ScrollController();
  bool _showGradient = true;

  // Static map to store slider values across screen switches
  static Map<String, double> storedSliderValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize slider values from stored values or default to 0.0
    for (var feeling in LogScreenStep2PositiveScreen.selectedPositiveFeelings) {
      sliderValues[feeling] = storedSliderValues[feeling] ?? 0.0;
    }

    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Store current slider values before disposing
    storedSliderValues = Map.from(sliderValues);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 0.1; // Threshold for considering we're at the bottom

    setState(() {
      _showGradient = currentScroll < maxScroll - delta;
    });
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      sliderValues[feeling] = value;
      // Update stored values immediately
      storedSliderValues[feeling] = value;
    });
    print('Updated intensity for $feeling: $value');
    print('Current stored slider values: $storedSliderValues');
  }

  void _handleNext() async {
    // Save all intensities before navigating
    for (var feeling in LogScreenStep2PositiveScreen.selectedPositiveFeelings) {
      if (sliderValues.containsKey(feeling)) {
        storedSliderValues[feeling] = sliderValues[feeling]!;
      }
    }
    print('Saving intensities before navigation: $storedSliderValues');
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LogScreenStepFourScreen.builder(context),
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
                  color: Color(0xFF808080).withOpacity(0.2),
                ),
              ),
            ),
            // Content
            SafeArea(
              top: false,
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
                              "Select Intensivity",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              "Is your mood just a tiny spark or a full-on emotional fireworks show?",
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
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => LogScreenStep3NegativeScreen(
                                              selectedFeelings: LogScreenStep2NegativePage.selectedNegativeFeelings,
                                            ),
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
                            SizedBox(
                              width: 364.h,
                              height: 486.h,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/positive_box.svg',
                                    width: 364.h,
                                    height: 486.h,
                                  ),
                                  // Display message when no feelings are selected
                                  if (LogScreenStep2PositiveScreen.selectedPositiveFeelings.isEmpty)
                                    Center(
                                      child: Text(
                                        "No positive feelings are selected.",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  // Display selected feelings
                                  SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: LogScreenStep2PositiveScreen.selectedPositiveFeelings.length > 5 
                                        ? const AlwaysScrollableScrollPhysics() 
                                        : const NeverScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: LogScreenStep2PositiveScreen.selectedPositiveFeelings.length > 5 
                                          ? 486.h + ((LogScreenStep2PositiveScreen.selectedPositiveFeelings.length - 5) * 100.h)
                                          : 486.h,
                                      child: Stack(
                                        children: [
                                          ...LogScreenStep2PositiveScreen.selectedPositiveFeelings.asMap().entries.map((entry) {
                                            final index = entry.key;
                                            final feeling = entry.value;
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  top: 20.h + (index * (80.h + 10.h)),
                                                  left: 38.h,
                                                  child: Text(
                                                    feeling,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // Percentage text
                                                Positioned(
                                                  top: 20.h + (index * (80.h + 10.h)),
                                                  right: 28.h,
                                                  child: Text(
                                                    '${sliderValues[feeling]?.round() ?? 0}%',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 55.h + (index * (80.h + 10.h)),
                                                  left: 38.h,
                                                  child: SizedBox(
                                                    width: 300.h,
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(context).copyWith(
                                                        trackHeight: 30,
                                                        overlayShape: SliderComponentShape.noOverlay,
                                                        thumbShape: SliderComponentShape.noThumb,
                                                        trackShape: const MyRoundedRectSliderTrackShape(),
                                                        activeTrackColor: const Color(0xFFFFFFFF).withOpacity(0.6),
                                                        inactiveTrackColor: const Color(0xFFE5E5E5).withOpacity(0.3),
                                                        disabledActiveTrackColor: const Color(0xFFE5E5E5).withOpacity(0.3),
                                                        disabledInactiveTrackColor: const Color(0xFFE5E5E5).withOpacity(0.3),
                                                      ),
                                                      child: Slider(
                                                        min: 0,
                                                        max: 100,
                                                        value: sliderValues[feeling] ?? 0.0,
                                                        onChanged: (value) {
                                                          _onIntensityChanged(feeling, value);
                                                        },
                                                        inactiveColor: const Color(0xFFE5E5E5).withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Gradient fade effect for scroll indication
                                  if (LogScreenStep2PositiveScreen.selectedPositiveFeelings.length > 5 && _showGradient)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(32.h),
                                            bottomRight: Radius.circular(32.h),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.4),
                                            ],
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
                  ],
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
                    onTap: _handleNext,
                    child: SvgPicture.asset(
                      'assets/images/next_log.svg',
                      width: 142.h,
                      height: 42.h,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    child: GestureDetector(
                      onTap: _handleNext,
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

// Add the custom slider track shape class at the end of the file
class MyRoundedRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const MyRoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final trackHeight = sliderTheme.trackHeight!;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    // Draw the inactive (background) track as a full bar
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, trackRadius),
      inactivePaint,
    );

    // Draw the active (foreground) track on top, up to the thumb
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor!;
    context.canvas.drawRRect(
      RRect.fromLTRBR(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
        trackRadius,
      ),
      activePaint,
    );
  }
}
