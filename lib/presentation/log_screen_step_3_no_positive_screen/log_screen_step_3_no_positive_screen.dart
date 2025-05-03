import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../log_screen_step_2_negative_page/log_screen_step_2_negative_page.dart';
import 'logscreenstep_tab2_page.dart';
import 'models/log_screen_step_3_no_positive_model.dart';
import 'provider/log_screen_step_3_no_positive_provider.dart';

class LogScreenStep3NoPositiveScreen extends StatefulWidget {
  const LogScreenStep3NoPositiveScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStep3NoPositiveScreenState createState() =>
      LogScreenStep3NoPositiveScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep3NoPositiveProvider(),
      child: LogScreenStep3NoPositiveScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LogScreenStep3NoPositiveScreenState
    extends State<LogScreenStep3NoPositiveScreen>
    with TickerProviderStateMixin {
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
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 48.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "msg_select_intensivity".tr,
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 6.h),
                Text(
                  "msg_is_your_mood_just".tr,
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
                      labelColor: theme.colorScheme.onPrimary.withValues(
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
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
                            child: Text(
                              "lbl_positive".tr,
                            ),
                          ),
                        ),
                        Tab(
                          height: 36,
                          child: Container(
                            width: 98.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.h),
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
                        LogscreenstepTab2Page.builder(context),
                        LogScreenStep2NegativePage.builder(context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 48.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 9.h,
          bottom: 9.h,
        ),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
