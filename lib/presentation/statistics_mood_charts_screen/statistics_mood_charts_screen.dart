import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../statistics_mood_drivers_page/statistics_mood_drivers_page.dart';
import 'models/statistics_mood_charts_model.dart';
import 'provider/statistics_mood_charts_provider.dart';
import 'statisticsmood_tab_page.dart';

class StatisticsMoodChartsScreen extends StatefulWidget {
  const StatisticsMoodChartsScreen({Key? key}) : super(key: key);

  @override
  StatisticsMoodChartsScreenState createState() =>
      StatisticsMoodChartsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodChartsProvider(),
      child: StatisticsMoodChartsScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class StatisticsMoodChartsScreenState extends State<StatisticsMoodChartsScreen>
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
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 28.h),
            child: Column(
              spacing: 14,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.h),
                  child: Text(
                    "lbl_statistics".tr,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 660.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 6.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(bottom: 14.h),
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 186.h,
                                  width: 354.h,
                                  margin: EdgeInsets.only(right: 4.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.5, 0),
                                      end: Alignment(0.5, 0.53),
                                      colors: [
                                        appTheme.black900
                                            .withValues(alpha: 0.1),
                                        appTheme.gray70019
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 166.h,
                                  width: 340.h,
                                  margin:
                                      EdgeInsets.only(left: 6.h, right: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.5, 0),
                                      end: Alignment(0.5, 0.53),
                                      colors: [
                                        appTheme.black900
                                            .withValues(alpha: 0.1),
                                        appTheme.gray70019
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: AppDecoration.windowsGlass.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 18.h),
                              _buildTabview(context),
                              Expanded(
                                child: Container(
                                  child: TabBarView(
                                    controller: tabviewController,
                                    children: [
                                      StatisticsmoodTabPage.builder(context),
                                      StatisticsMoodDriversPage.builder(context)
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 28.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_back".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  Widget _buildTabview(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
          ),
          BoxShadow(
            color: appTheme.blueGray1007f,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(1, 1.5),
          )
        ],
      ),
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.h),
        child: TabBar(
          controller: tabviewController,
          labelPadding: EdgeInsets.zero,
          labelColor: theme.colorScheme.onPrimary.withValues(alpha: 0.96),
          labelStyle: TextStyle(
            fontSize: 15.fSize,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor:
              theme.colorScheme.onPrimary.withValues(alpha: 0.96),
          unselectedLabelStyle: TextStyle(
            fontSize: 15.fSize,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(4.0.h),
          indicator: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(18.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(alpha: 0.1),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(0, 2),
              )
            ],
          ),
          dividerHeight: 0.0,
          tabs: [
            Tab(
              height: 36,
              child: Container(
                width: 126.h,
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Text("lbl_mood_charts".tr),
              ),
            ),
            Tab(
              height: 36,
              child: Container(
                width: 130.h,
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Text("lbl_mood_drivers".tr),
              ),
            )
          ],
        ),
      ),
    );
  }
}
