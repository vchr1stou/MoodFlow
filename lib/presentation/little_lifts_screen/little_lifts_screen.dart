import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../widgets/base_button.dart';
import '../../widgets/mood_flow_bottom_bar_svg.dart';
import '../homescreen_screen/homescreen_screen.dart';
import 'little_lifts_initial_page.dart';
import 'models/little_lifts_model.dart';
import 'provider/little_lifts_provider.dart';

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
  const LittleLiftsScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LittleLiftsScreenState createState() => LittleLiftsScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LittleLiftsProvider(),
      child: LittleLiftsScreen(),
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
            Container(
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Navigator(
                        key: navigatorKey,
                        initialRoute: AppRoutes.littleLiftsInitialPage,
                        onGenerateRoute: (routeSetting) => NoSwipeBackRoute(
                          builder: (context) =>
                              getCurrentPage(context, routeSetting.name!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: Platform.isAndroid
                        ? 20 + MediaQuery.of(context).padding.bottom
                        : 20),
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
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width:
                                250, // Increased width for better touch target
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      HomescreenScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale:
                                            Tween<double>(begin: 0.95, end: 1.0)
                                                .animate(
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

                          // Right side - Little Lifts text (no navigation)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width:
                                250, // Increased width for better touch target
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Handling page based on route
  Widget getCurrentPage(
    BuildContext context,
    String currentRoute,
  ) {
    switch (currentRoute) {
      case AppRoutes.littleLiftsInitialPage:
        return LittleLiftsInitialPage.builder(context);
      default:
        return LittleLiftsInitialPage.builder(context);
    }
  }
}
