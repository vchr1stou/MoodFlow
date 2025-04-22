import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import 'models/saved_preview_model.dart';
import 'provider/saved_preview_provider.dart';

class SavedPreviewScreen extends StatefulWidget {
  const SavedPreviewScreen({Key? key}) : super(key: key);

  @override
  SavedPreviewScreenState createState() => SavedPreviewScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavedPreviewProvider(),
      child: SavedPreviewScreen(),
    );
  }
}

class SavedPreviewScreenState extends State<SavedPreviewScreen> {
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
            padding: EdgeInsets.only(left: 18.h, top: 10.h, right: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        decoration: AppDecoration.outline12,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 100, sigmaY: 100),
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.only(
                                        left: 8.h, top: 24.h, right: 8.h),
                                    decoration:
                                        AppDecoration.windowsGlassBlur.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder32,
                                    ),
                                    child: Column(
                                      spacing: 12,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgAnyoneButYou1176x312,
                                          height: 176.h,
                                          width: double.maxFinite,
                                          radius: BorderRadius.circular(16.h),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.h),
                                        ),
                                        _buildSettingsone(context),
                                        SizedBox(height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_saved".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildSettingsone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.h),
                  child: Text(
                    "msg_italian_carbonara".tr,
                    style: CustomTextStyles.titleLargeRobotoOnPrimarySemiBold23,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.h),
                  child: Text(
                    "msg_20_mins_4_portions".tr,
                    style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.only(left: 6.h),
                  child: Text(
                    "lbl_about".tr,
                    style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.only(left: 6.h),
                  child: Text(
                    "msg_imagine_a_twirl".tr,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                        .copyWith(height: 2.00),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevatedButton(
                        height: 42.h,
                        width: 120.h,
                        text: "lbl_get_the_recipe".tr,
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 8.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgUserOnprimary18x20,
                            height: 18.h,
                            width: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientPrimaryToPrimaryDecoration,
                        buttonTextStyle: CustomTextStyles.labelSmallRoboto,
                      ),
                      CustomElevatedButton(
                        height: 42.h,
                        width: 78.h,
                        text: "lbl_saved".tr,
                        margin: EdgeInsets.only(left: 10.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 2.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgBookmarkOnprimary30x30,
                            height: 30.h,
                            width: 30.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientPrimaryToPrimaryDecoration,
                        buttonTextStyle:
                            CustomTextStyles.labelMediumRobotoSemiBold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
