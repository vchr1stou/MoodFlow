import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/workout_model.dart';
import 'provider/workout_provider.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  WorkoutScreenState createState() => WorkoutScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: WorkoutScreen(),
    );
  }
}

class WorkoutScreenState extends State<WorkoutScreen> {
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
                  left: 14.h,
                  top: 8.h,
                  right: 14.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80.h,
                      width: 280.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgBookmark,
                            height: 16.h,
                            width: 18.h,
                            alignment: Alignment.bottomLeft,
                          ),
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.only(
                              left: 12.h,
                              top: 4.h,
                              bottom: 4.h,
                            ),
                            decoration: AppDecoration.fillGray.copyWith(
                              borderRadius: BorderRadiusStyle.circleBorder18,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 222.h,
                                  child: Text(
                                    "msg_move_breathe".tr,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles
                                        .titleMediumSecondaryContainer
                                        .copyWith(height: 1.29),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 2.h),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 100,
                            sigmaY: 100,
                          ),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.h,
                              vertical: 24.h,
                            ),
                            decoration: AppDecoration.windowsGlassBlur.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder32,
                            ),
                            child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgAnyoneButYou14,
                                  height: 176.h,
                                  width: double.maxFinite,
                                  radius: BorderRadius.circular(16.h),
                                  margin: EdgeInsets.only(
                                    left: 10.h,
                                    right: 8.h,
                                  ),
                                ),
                                _buildSettingsone(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 54.h),
                    Padding(
                      padding: EdgeInsets.only(right: 2.h),
                      child: Selector<WorkoutProvider, TextEditingController?>(
                        selector: (context, provider) =>
                            provider.searchfieldoneController,
                        builder: (context, searchfieldoneController, child) {
                          return CustomTextFormField(
                            controller: searchfieldoneController,
                            hintText: "lbl_ask_me_anything".tr,
                            textInputAction: TextInputAction.done,
                            prefix: Padding(
                              padding: EdgeInsets.only(
                                left: 14.57.h,
                                right: 30.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgMic,
                                    height: 24.h,
                                    width: 14.84.h,
                                    margin: EdgeInsets.fromLTRB(
                                      14.57.h,
                                      9.48999.h,
                                      14.59.h,
                                      10.51001.h,
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgHighlightFrame,
                                    height: 44.h,
                                    width: 8.h,
                                  ),
                                ],
                              ),
                            ),
                            prefixConstraints: BoxConstraints(
                              maxHeight: 44.h,
                            ),
                            suffix: Container(
                              padding: EdgeInsets.all(10.h),
                              margin: EdgeInsets.only(
                                left: 30.h,
                                right: 2.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.h),
                                gradient: LinearGradient(
                                  begin: Alignment(0.5, 1),
                                  end: Alignment(0.5, 0),
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary
                                        .withValues(alpha: 0),
                                  ],
                                ),
                              ),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgPaperplanefill1,
                                height: 22.h,
                                width: 22.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            suffixConstraints: BoxConstraints(
                              maxHeight: 44.h,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 58.h),
                  ],
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

  /// Section Widget
  Widget _buildSettingsone(BuildContext context) {
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
              vertical: 6.h,
            ),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "msg_cardio_kickboxing".tr,
                  style: CustomTextStyles.headlineSmallRobotoOnPrimarySemiBold,
                ),
                Text(
                  "msg_punch_it_out_the".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                ),
                SizedBox(height: 2.h),
                Text(
                  "lbl_about".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                ),
                SizedBox(height: 2.h),
                Text(
                  "msg_this_energizing".tr,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                      .copyWith(height: 2.00),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevatedButton(
                        height: 42.h,
                        width: 154.h,
                        text: "msg_watch_it_on_youtube".tr,
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgPlayRectangleFill,
                            height: 16.h,
                            width: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientPrimaryToPrimaryDecoration,
                        buttonTextStyle:
                            CustomTextStyles.labelMediumRobotoSemiBold,
                      ),
                      CustomElevatedButton(
                        height: 42.h,
                        width: 78.h,
                        text: "lbl_save".tr,
                        margin: EdgeInsets.only(left: 8.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 2.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgBookmarkOnprimary,
                            height: 20.h,
                            width: 20.h,
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
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
