import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/appbar_trailing_button.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/homescreen_model.dart';
import 'provider/homescreen_provider.dart';

class HomescreenScreen extends StatefulWidget {
  const HomescreenScreen({Key? key}) : super(key: key);

  @override
  HomescreenScreenState createState() => HomescreenScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomescreenProvider(),
      child: HomescreenScreen(),
    );
  }
}

class HomescreenScreenState extends State<HomescreenScreen> {
  @override
  void initState() {
    super.initState();
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
            margin: EdgeInsets.only(top: 56.h),
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 30.h,
                  top: 30.h,
                  right: 30.h,
                ),
                child: Column(
                  spacing: 12,
                  children: [
                    _buildAlert(context),
                    _buildAlertone(context),
                    _buildAlerttwo(context),
                    _buildAlertthree(context),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnblursone(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 25.h),
        child: Column(
          children: [
            AppbarSubtitleTwo(
              text: "lbl_welcome_back".tr.toUpperCase(),
            ),
            AppbarSubtitle(
              text: "lbl_vasilis".tr,
              margin: EdgeInsets.only(
                left: 3.h,
                right: 9.h,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppbarTrailingButton(),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgSettings,
          height: 40.h,
          width: 40.h,
          margin: EdgeInsets.only(left: 5.h),
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgMusic,
          height: 36.h,
          width: 36.h,
          margin: EdgeInsets.only(
            left: 4.h,
            right: 19.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildAlert(BuildContext context) {
    return Container(
      decoration: AppDecoration.windowsGlassBlur.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100,
            sigmaY: 100,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 8.h,
            ),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgContrast,
                  height: 32.h,
                  width: 52.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "msg_quote_of_the_day".tr,
                        style: CustomTextStyles.titleMediumOnPrimaryBold,
                      ),
                      Text(
                        "msg_every_step_toward".tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.labelMediumRobotoMedium
                            .copyWith(height: 1.09),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAlertone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100,
            sigmaY: 100,
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              spacing: 26,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "msg_how_are_you_feeling".tr,
                  style: CustomTextStyles.titleMediumSFProOnPrimaryBold,
                ),
                CustomIconButton(
                  height: 72.h,
                  width: 72.h,
                  padding: EdgeInsets.all(20.h),
                  decoration: IconButtonStyleHelper.outlineBlack,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgButton,
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAlerttwo(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100,
            sigmaY: 100,
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 22.h,
            ),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              spacing: 22,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(
                    children: [
                      Text(
                        "lbl_statistics".tr,
                        style: CustomTextStyles.titleMediumSFProOnPrimaryBold,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowRight,
                        height: 12.h,
                        width: 8.h,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(
                          left: 4.h,
                          bottom: 4.h,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgThumbsUp,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgTelevision,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSettingsPink800,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSettingsOrange30001,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSettingsPink80090x30,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSettingsPink80090x30,
                            height: 90.h,
                            width: 30.h,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgInbox,
                            height: 90.h,
                            width: 30.h,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "lbl_mon".tr,
                            style: CustomTextStyles
                                .titleSmallRobotoOnPrimarySemiBold_1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.h),
                            child: Text(
                              "lbl_tue".tr,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.h),
                            child: Text(
                              "lbl_wed".tr,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.h),
                            child: Text(
                              "lbl_thu".tr,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 22.h),
                            child: Text(
                              "lbl_fri".tr,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 26.h),
                            child: Text(
                              "lbl_sat".tr,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12.h),
                            padding: EdgeInsets.symmetric(horizontal: 8.h),
                            decoration: AppDecoration.outline.copyWith(
                              borderRadius: BorderRadiusStyle.circleBorder8,
                            ),
                            child: Text(
                              "lbl_sun".tr,
                              textAlign: TextAlign.left,
                              style: CustomTextStyles
                                  .titleSmallRobotoOnPrimarySemiBold_1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildShowhistory(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 40.h,
        text: "lbl_show_history".tr,
        buttonStyle: CustomButtonStyles.fillPrimary,
        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
      ),
    );
  }

  /// Section Widget
  Widget _buildDiscover(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 40.h,
        text: "lbl_discover".tr,
        buttonStyle: CustomButtonStyles.fillPrimary,
        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
      ),
    );
  }

  /// Section Widget
  Widget _buildAlertthree(BuildContext context) {
    return Container(
      decoration: AppDecoration.windowsGlassBlur.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100,
            sigmaY: 100,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 12.h,
            ),
            child: Row(
              children: [
                _buildShowhistory(context),
                _buildDiscover(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHome(BuildContext context) {
    return CustomOutlinedButton(
      height: 36.h,
      text: "lbl_home".tr,
      leftIcon: Container(
        margin: EdgeInsets.only(right: 2.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgHousefill1,
          height: 14.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.outlineTL18Decoration,
      buttonTextStyle: CustomTextStyles.labelLarge13,
    );
  }

  /// Section Widget
  Widget _buildColumnblursone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(4.h),
            decoration: AppDecoration.viewsRecessedMaterialView.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder24,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildHome(context)],
                  ),
                ),
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    margin: EdgeInsets.only(left: 2.h),
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: 0.18,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.5.h),
                      borderRadius: BorderRadiusStyle.circleBorder18,
                    ),
                    child: Container(
                      height: 36.h,
                      decoration: AppDecoration.outline.copyWith(
                        borderRadius: BorderRadiusStyle.circleBorder18,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgImage3,
                            height: 36.h,
                            width: double.maxFinite,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgBlurS,
                            height: 36.h,
                            width: double.maxFinite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgThumbsUpPink100,
                  height: 16.h,
                  width: 16.h,
                  margin: EdgeInsets.only(left: 20.h),
                ),
                Container(
                  width: 64.h,
                  margin: EdgeInsets.only(
                    left: 2.h,
                    right: 16.h,
                  ),
                  child: Text(
                    "lbl_little_lifts".tr,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelLargeOnPrimary13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
