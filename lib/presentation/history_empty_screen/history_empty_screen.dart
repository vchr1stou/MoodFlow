import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';

import 'models/history_empty_model.dart';
import 'provider/history_empty_provider.dart';

class HistoryEmptyScreen extends StatefulWidget {
  const HistoryEmptyScreen({Key? key}) : super(key: key);

  @override
  HistoryEmptyScreenState createState() => HistoryEmptyScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryEmptyProvider(),
      child: const HistoryEmptyScreen(),
    );
  }
}

class HistoryEmptyScreenState extends State<HistoryEmptyScreen> {
  @override
  void initState() {
    super.initState();
    // any initialization logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 36.h, left: 14.h, right: 14.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "lbl_history".tr,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "msg_sun_march_30".tr.toUpperCase(),
                  style: CustomTextStyles.labelLargeOnPrimary13_2,
                ),
                Spacer(flex: 46),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 186.h,
                          width: 354.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 0),
                              end: Alignment(0.5, 0.53),
                              colors: [
                                appTheme.black900.withAlpha(25), // 10%
                                appTheme.gray70019,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 166.h,
                        width: 340.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.5, 0),
                            end: Alignment(0.5, 0.53),
                            colors: [
                              appTheme.black900.withAlpha(25),
                              appTheme.gray70019,
                            ],
                          ),
                        ),
                      ),
                      _buildEmptyAlert(context),
                    ],
                  ),
                ),
                Spacer(flex: 53),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 36.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  Widget _buildEmptyAlert(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 6.h),
        padding: EdgeInsets.symmetric(vertical: 62.h),
        decoration: AppDecoration.windowsGlass.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "msg_bright_stories_start".tr,
              style: CustomTextStyles.titleMediumSFPro,
            ),
            SizedBox(height: 2.h),
            Text(
              "msg_when_you_re_ready".tr,
              style: CustomTextStyles.labelLargeOnPrimary_1,
            ),
            SizedBox(height: 28.h),
            CustomIconButton(
              height: 72.h,
              width: 72.h,
              padding: EdgeInsets.all(20.h),
              decoration: IconButtonStyleHelper.outlineBlack,
              child: CustomImageView(imagePath: ImageConstant.imgButton),
            ),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
