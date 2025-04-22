import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/base_button.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'little_lifts_initial_page.dart';
import 'models/little_lifts_model.dart';
import 'provider/little_lifts_provider.dart';

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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            decoration: AppDecoration.gradientAmberToRed,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Navigator(
                    key: navigatorKey,
                    initialRoute: AppRoutes.littleLiftsInitialPage,
                    onGenerateRoute: (routeSetting) => PageRouteBuilder(
                      pageBuilder: (ctx, ani, ani1) =>
                          getCurrentPage(context, routeSetting.name!),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  ),
                ),
                SizedBox(height: 14.h)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          left: 14.h,
          right: 14.h,
          bottom: 14.h,
        ),
        child: _buildBottombar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {},
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
