import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/glassmorphic_container.dart';
import '../workout_screen/workout_screen.dart';
import '../meditation_screen/meditation_screen.dart';
import '../breathingmain_screen/breathingmain_screen.dart';
import '../movies_screen/movies_screen.dart';
import '../music_screen/music_screen.dart';
import '../book_screen/book_screen.dart';
import '../positiveaffirmations_screen/positiveaffirmations_screen.dart';
import '../cooking_screen/cooking_screen.dart';
import '../traveling_screen/traveling_screen.dart';
import '../safetynetlittlelifts_screen/safetynetlittlelifts_screen.dart';
import '../softthanks_screen/softthanks_screen.dart';
import '../saved_screen/saved_screen.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'models/little_lifts_initial_model.dart';
import 'models/little_lifts_item_model.dart';
import 'provider/little_lifts_provider.dart';
import 'widgets/little_lifts_item_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'dart:async';

class GradientStop {
  final Color color;
  final double location;

  GradientStop({required this.color, required this.location});
}

class GlowEffect extends StatefulWidget {
  const GlowEffect({Key? key}) : super(key: key);

  @override
  State<GlowEffect> createState() => _GlowEffectState();
}

class _GlowEffectState extends State<GlowEffect>
    with SingleTickerProviderStateMixin {
  List<GradientStop> gradientStops = [];
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  Timer? _timer4;
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    gradientStops = _generateBreathingGradientStops();
    _startAnimations();
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    _timer4?.cancel();
    super.dispose();
  }

  void _startAnimations() {
    // First layer: 4.0s interval
    _timer1 = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (mounted) {
        setState(() {
          _animationValue += 0.03;
          if (_animationValue > 2 * math.pi) {
            _animationValue = 0;
          }
          gradientStops = _generateBreathingGradientStops();
        });
      }
    });
  }

  List<GradientStop> _generateBreathingGradientStops() {
    final baseStops = [
      const Color(0xFFBC82F3),
      const Color(0xFFF5B9EA),
      const Color(0xFF8D9FFF),
      const Color(0xFFFF6778),
      const Color(0xFFFFBA71),
      const Color(0xFFC686FF),
    ];

    // Create continuous circular flow
    final flowOffset =
        (_animationValue % (2 * math.pi)) / (2 * math.pi); // 0 to 1

    // Create a list that's twice the size to ensure continuous flow
    final extendedStops = [...baseStops, ...baseStops];

    return List.generate(baseStops.length, (index) {
      final baseLocation = index / (baseStops.length - 1);
      // Create a continuous circular flow
      final adjustedLocation = (baseLocation + flowOffset);
      return GradientStop(
        color: extendedStops[index % baseStops.length],
        location: adjustedLocation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 269,
      top: 85,
      child: Container(
        width: 108,
        height: 36,
        child: Stack(
          children: [
            _buildEffect(width: 1, blur: 0),
            _buildEffect(width: 3, blur: 2),
            _buildEffect(width: 5, blur: 6),
            _buildEffect(width: 7, blur: 8),
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Surprise me",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4), // Space between text and icon
                  Transform.translate(
                    offset: Offset(0, 1), // Move down 1 pixel
                    child: SvgPicture.asset(
                      'assets/images/shuffle.svg',
                      width: 15,
                      height: 12,
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

  Widget _buildEffect({required double width, required double blur}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      curve: Curves.easeInOut,
      child: CustomPaint(
        painter: GradientBorderPainter(
          gradientStops: gradientStops,
          width: width,
          blur: blur,
        ),
        size: Size(112, 37),
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final List<GradientStop> gradientStops;
  final double width;
  final double blur;

  GradientBorderPainter({
    required this.gradientStops,
    required this.width,
    required this.blur,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final colors = gradientStops.map((stop) => stop.color).toList();
    final stops = gradientStops.map((stop) => stop.location).toList();

    paint.shader = SweepGradient(
      colors: colors,
      stops: stops,
      center: Alignment.center,
    ).createShader(rect);

    if (blur > 0) {
      paint.imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(18.5)),
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) {
    return oldDelegate.gradientStops != gradientStops ||
        oldDelegate.width != width ||
        oldDelegate.blur != blur;
  }
}

class LittleLiftsInitialPage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  
  const LittleLiftsInitialPage({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  LittleLiftsInitialPageState createState() => LittleLiftsInitialPageState();
  
  static Widget builder(BuildContext context, GlobalKey<NavigatorState> navigatorKey) {
    return ChangeNotifierProvider(
      create: (context) => LittleLiftsProvider(),
      child: LittleLiftsInitialPage(navigatorKey: navigatorKey),
    );
  }
}

class LittleLiftsInitialPageState extends State<LittleLiftsInitialPage> {
  Widget _buildBoxContent(
    String iconPath,
    String text, {
    double iconLeft = 27.5,
    double iconTop = 20,
    double textTop = 65,
    double iconWidth = 43,
    double iconHeight = 44,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/littl_lifts_box.svg',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          Positioned(
            left: iconLeft,
            top: iconTop,
            child: SvgPicture.asset(
              iconPath,
              width: iconWidth,
              height: iconHeight,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: textTop,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlowEffect(),
        Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 38.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildAppbar(context),
                      ),
                      _buildRowalertone(context),
                      SizedBox(height: 30.h),
                      _buildLittlelifts(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 50.h,
      title: AppbarTitle(
        text: "Little Lifts",
        margin: EdgeInsets.only(left: 28.h),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Add your info button action here
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: 6.h,
              right: 22.h,
              bottom: 13.h,
            ),
            child: SvgPicture.asset(
              'assets/images/info.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildRowalertone(BuildContext context) {
    // Define spacing constants for better maintainability
    const double boxWidth = 100.0; // Width of each box
    const double horizontalSpacing = 121.0; // Space between boxes
    const double startLeft = 25.5; // Starting position for first box
    const double rowSpacing = 136.0; // Vertical space between rows

    return Container(
      width: double.maxFinite,
      height: 568,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 0,
            child: Container(
              width: 250,
              height: 39,
              child: SvgPicture.asset(
                'assets/images/little_lifts_desc.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 6,
            child: Text(
              "Tiny acts of care, for wherever you are.",
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 269,
            top: 0,
            child: SvgPicture.asset(
              'assets/images/surprise_me.svg',
              fit: BoxFit.contain,
              width: 112,
              height: 37,
            ),
          ),
          // First row
          Positioned(
            left: startLeft,
            top: 60,
            child: _buildBoxContent(
              'assets/images/workout.svg',
              'Workout',
              iconLeft: 27.5,
              iconTop: 20,
              textTop: 65,
              iconWidth: 41.38,
              iconHeight: 43.85,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + horizontalSpacing,
            top: 60,
            child: _buildBoxContent(
              'assets/images/meditation.svg',
              'Meditation',
              iconLeft: 29.5,
              iconTop: 18,
              textTop: 65,
              iconWidth: 37,
              iconHeight: 44,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MeditationScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + (horizontalSpacing * 2),
            top: 60,
            child: _buildBoxContent(
              'assets/images/breathing_icon.svg',
              'Breathing',
              iconLeft: 27.5,
              iconTop: 20,
              textTop: 65,
              iconWidth: 44.32,
              iconHeight: 39,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BreathingmainScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          // Second row
          Positioned(
            left: startLeft,
            top: 60 + rowSpacing,
            child: _buildBoxContent(
              'assets/images/movie_time.svg',
              'Movie Time',
              iconLeft: 32.5,
              iconTop: 20,
              textTop: 65,
              iconWidth: 35,
              iconHeight: 44,
              onTap: () {
                _navigateToMovies();
              },
            ),
          ),
          Positioned(
            left: startLeft + horizontalSpacing,
            top: 60 + rowSpacing,
            child: _buildBoxContent(
              'assets/images/music.svg',
              'Music',
              iconLeft: 30,
              iconTop: 20,
              textTop: 65,
              iconWidth: 38,
              iconHeight: 40,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MusicScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + (horizontalSpacing * 2),
            top: 60 + rowSpacing,
            child: _buildBoxContent(
              'assets/images/book.svg',
              'Read a Book',
              iconLeft: 30,
              iconTop: 25,
              textTop: 65,
              iconWidth: 42,
              iconHeight: 32,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BookScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          // Third row
          Positioned(
            left: startLeft,
            top: 60 + (rowSpacing * 2),
            child: _buildBoxContent(
              'assets/images/affirmations.svg',
              'Affirmations',
              iconLeft: 33,
              iconTop: 24,
              textTop: 65,
              iconWidth: 34,
              iconHeight: 34,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => PositiveaffirmationsScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + horizontalSpacing,
            top: 60 + (rowSpacing * 2),
            child: _buildBoxContent(
              'assets/images/cooking.svg',
              'Cooking',
              iconLeft: 27.5,
              iconTop: 25,
              textTop: 65,
              iconWidth: 47.46,
              iconHeight: 28.83,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => CookingScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + (horizontalSpacing * 2),
            top: 60 + (rowSpacing * 2),
            child: _buildBoxContent(
              'assets/images/travel_plans.svg',
              'Travel Plans',
              iconLeft: 26.5,
              iconTop: 24,
              textTop: 65,
              iconWidth: 47,
              iconHeight: 33,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => TravelingScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          // Fourth row
          Positioned(
            left: startLeft,
            top: 60 + (rowSpacing * 3),
            child: _buildBoxContent(
              'assets/images/safety_net.svg',
              'Safety Net',
              iconLeft: 21,
              iconTop: 24,
              textTop: 65,
              iconWidth: 58,
              iconHeight: 32,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SafetynetlittleliftsScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + horizontalSpacing,
            top: 60 + (rowSpacing * 3),
            child: _buildBoxContent(
              'assets/images/soft_thanks.svg',
              'Soft Thanks',
              iconLeft: 29.5,
              iconTop: 23,
              textTop: 65,
              iconWidth: 39,
              iconHeight: 36,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SoftthanksScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          Positioned(
            left: startLeft + (horizontalSpacing * 2),
            top: 60 + (rowSpacing * 3),
            child: _buildBoxContent(
              'assets/images/saved.svg',
              'Saved',
              iconLeft: 36.5,
              iconTop: 20,
              textTop: 65,
              iconWidth: 26,
              iconHeight: 40,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SavedScreen.builder(context),
                    fullscreenDialog: true,
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLittlelifts(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Consumer<LittleLiftsProvider>(
          builder: (context, provider, child) {
            return ResponsiveGridListBuilder(
              minItemWidth: 1,
              minItemsPerRow: 3,
              maxItemsPerRow: 3,
              horizontalGridSpacing: 24.h,
              verticalGridSpacing: 24.h,
              builder: (context, items) => ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: items,
              ),
              gridItems: List.generate(
                provider.littleLiftsInitialModelObj.littleLiftsItemList.length,
                (index) {
                  LittleLiftsItemModel model = provider
                      .littleLiftsInitialModelObj.littleLiftsItemList[index];
                  return LittleLiftsItemWidget(
                    model: model,
                  );
                },
              ),
            );
          },
        ),
      ),
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
          Transform.translate(
            offset: Offset(0, -23),
            child: Stack(
              children: [
                // The entire bottom bar SVG
                SvgPicture.asset(
                  'assets/images/bottom_bar_little_lifts_pressed.svg',
                  fit: BoxFit.fitWidth,
                ),

                // Left side - Home text (navigates to Home screen)
                // Increased width to make it easier to press
                Positioned(
                  left: -20, // Extend touch area to the left
                  top: -10, // Extend touch area upward
                  bottom: -10, // Extend touch area downward
                  width:
                      200, // Increased from 150 to 200 for a wider touch target
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),

                // Right side - Little Lifts text (no navigation)
                // Increased width to make it easier to press
                Positioned(
                  right: -20, // Extend touch area to the right
                  top: -10, // Extend touch area upward
                  bottom: -10, // Extend touch area downward
                  width:
                      200, // Increased from 150 to 200 for a wider touch target
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    // No onTap handler - tapping does nothing
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -25),
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

  void _navigateToMovies() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MoviesScreen.builder(context),
        fullscreenDialog: true,
      ),
      (route) => false,
    );
  }
}
