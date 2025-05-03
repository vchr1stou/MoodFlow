import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../log_screen_step_3_no_negative_page/log_screen_step_3_no_negative_page.dart';
import '../log_screen_step_3_positive_one_page/log_screen_step_3_positive_one_page.dart';
import 'logscreenstep_tab_page.dart';
import 'models/log_screen_step_2_positive_model.dart';
import 'provider/log_screen_step_2_positive_provider.dart';

class LogScreenStep2PositiveScreen extends StatefulWidget {
  const LogScreenStep2PositiveScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStep2PositiveScreenState createState() =>
      LogScreenStep2PositiveScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep2PositiveProvider(),
      child: LogScreenStep2PositiveScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LogScreenStep2PositiveScreenState
    extends State<LogScreenStep2PositiveScreen> with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Container(
                  height: 830.h,
                  decoration: AppDecoration.gradientAmberToRed4001,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 418.h,
                        width: 382.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.5, 0),
                            end: Alignment(0.5, 0.53),
                            colors: [
                              appTheme.black900.withValues(
                                alpha: 0.1,
                              ),
                              appTheme.gray70019
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: _buildAppbar(context),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "lbl_select_feelings".tr,
                              style: theme.textTheme.headlineSmall,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "msg_no_feeling_is_too".tr,
                              style: CustomTextStyles.labelMediumOnPrimary,
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 62.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  22.h,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: appTheme.black900.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  BoxShadow(
                                    color: appTheme.blueGray1007f,
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(
                                      1,
                                      1.5,
                                    ),
                                  )
                                ],
                              ),
                              width: double.maxFinite,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  22.h,
                                ),
                                child: TabBar(
                                  controller: tabviewController,
                                  labelPadding: EdgeInsets.zero,
                                  labelColor:
                                      theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.96,
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 15.fSize,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelColor: appTheme.gray700,
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: 15.fSize,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorPadding: EdgeInsets.all(
                                    4.0.h,
                                  ),
                                  indicator: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      18.h,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: appTheme.black900.withValues(
                                          alpha: 0.1,
                                        ),
                                        spreadRadius: 2.h,
                                        blurRadius: 2.h,
                                        offset: Offset(
                                          0,
                                          2,
                                        ),
                                      )
                                    ],
                                  ),
                                  dividerHeight: 0.0,
                                  tabs: [
                                    Tab(
                                      height: 36,
                                      child: Container(
                                        width: 90.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.h),
                                        child: Text(
                                          "lbl_positive".tr,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      height: 36,
                                      child: Container(
                                        width: 98.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.h),
                                        child: Text(
                                          "lbl_negative".tr,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                  controller: tabviewController,
                                  children: [
                                    LogscreenstepTabPage.builder(context),
                                    LogScreenStep3PositiveOnePage.builder(
                                        context)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
      centerTitle: true,
      title: SliderTheme(
        data: SliderThemeData(
          trackShape: RoundedRectSliderTrackShape(),
          activeTrackColor: theme.colorScheme.onPrimary.withValues(
            alpha: 0.6,
          ),
          inactiveTrackColor: appTheme.blueGray1007f,
          thumbShape: RoundSliderThumbShape(),
        ),
        child: Slider(
          value: 28.47,
          min: 0.0,
          max: 100.0,
          onChanged: (value) {},
        ),
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
