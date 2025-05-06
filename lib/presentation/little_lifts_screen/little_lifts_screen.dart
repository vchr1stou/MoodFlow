import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../core/app_export.dart';
import '../../widgets/base_button.dart';
import '../../widgets/mood_flow_bottom_bar_svg.dart';
import '../homescreen_screen/homescreen_screen.dart';
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
import 'little_lifts_initial_page.dart';
import 'models/little_lifts_model.dart';
import 'provider/little_lifts_provider.dart';
import '../ai_screen/ai_screen.dart';

class NoSwipeBackRoute<T> extends MaterialPageRoute<T> {
  NoSwipeBackRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  bool get hasScopedWillPopCallback => true;

  @override
  bool get canPop => false;

  @override
  bool get gestureEnabled => false;
}

class LittleLiftsScreen extends StatefulWidget {
  const LittleLiftsScreen({Key? key}) : super(key: key);

  @override
  LittleLiftsScreenState createState() => LittleLiftsScreenState();
  
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LittleLiftsProvider(),
      child: const LittleLiftsScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LittleLiftsScreenState extends State<LittleLiftsScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Background container
            Container(
              width: double.maxFinite,
              height: SizeUtils.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content with navigation
            SafeArea(
              child: Navigator(
                key: navigatorKey,
                initialRoute: AppRoutes.littleLiftsInitialPage,
                onGenerateRoute: (routeSetting) => NoSwipeBackRoute(
                  builder: (context) => getCurrentPage(context, routeSetting.name!),
                ),
              ),
            ),
            // Bottom navigation bar - only show if not on breathing screen
            Builder(
              builder: (context) {
                final currentRoute = ModalRoute.of(context)?.settings.name;
                if (currentRoute == AppRoutes.breathingmainScreen) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                        // Swiped left
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                HomescreenScreen.builder(context),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: Platform.isAndroid ? 20 + MediaQuery.of(context).padding.bottom : 20,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -23),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/bottom_bar_little_lifts_pressed.svg',
                                  fit: BoxFit.fitWidth,
                                ),
                                // Home navigation
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 250,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            HomescreenScreen.builder(context),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOut,
                                                ),
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Little Lifts section (no navigation)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 250,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // AI button
                          Transform.translate(
                            offset: const Offset(0, -25),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ai_button.png',
                                  width: 118.667,
                                  height: 36,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  isAntiAlias: true,
                                ),
                                Positioned.fill(
                                  top: -22,
                                  bottom: -22,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            AiScreen.builder(context),
                                        transitionsBuilder:
                                            (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                                CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOut,
                                                ),
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    child: Container(
                                      color: Colors.transparent,
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getCurrentPage(BuildContext context, String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.littleLiftsInitialPage:
        return LittleLiftsInitialPage.builder(context, navigatorKey);
      case AppRoutes.workoutScreen:
        return WorkoutScreen.builder(context);
      case AppRoutes.meditationScreen:
        return MeditationScreen.builder(context);
      case AppRoutes.breathingmainScreen:
        return WillPopScope(
          onWillPop: () async => false,
          child: MaterialApp(
            home: BreathingmainScreen.builder(context),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
            ),
          ),
        );
      case AppRoutes.moviesScreen:
        return MoviesScreen.builder(context);
      case AppRoutes.musicScreen:
        return MusicScreen.builder(context);
      case AppRoutes.bookScreen:
        return BookScreen.builder(context);
      case AppRoutes.positiveaffirmationsScreen:
        return PositiveaffirmationsScreen.builder(context);
      case AppRoutes.cookingScreen:
        return CookingScreen.builder(context);
      case AppRoutes.travelingScreen:
        return TravelingScreen.builder(context);
      case AppRoutes.safetynetlittleliftsScreen:
        return SafetynetlittleliftsScreen.builder(context);
      case AppRoutes.softthanksScreen:
        return SoftthanksScreen.builder(context);
      case AppRoutes.savedScreen:
        return SavedScreen.builder(context);
      default:
        return LittleLiftsInitialPage.builder(context, navigatorKey);
    }
  }
}
