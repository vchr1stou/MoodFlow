import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/meditation_model.dart';
import 'provider/meditation_provider.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  MeditationScreenState createState() => MeditationScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeditationProvider(),
      child: MeditationScreen(),
    );
  }
}

class MeditationScreenState extends State<MeditationScreen> {
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
                padding: EdgeInsets.only(left: 14.h, top: 8.h, right: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleCard(),
                    SizedBox(height: 32.h),
                    _buildBlurredCard(context),
                    SizedBox(height: 32.h),
                    _buildTextField(context),
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

  /// App bar section
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

  /// Top card with image and text
  Widget _buildTitleCard() {
    return SizedBox(
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
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.h),
            decoration: AppDecoration.fillGray.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  "msg_sink_into_silence".tr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      CustomTextStyles.titleMediumSecondaryContainer.copyWith(
                    height: 1.29,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Blurred glass UI card with image and description
  Widget _buildBlurredCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.h),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.h),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgAnyoneButYou11,
                  height: 176.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(16.h),
                  margin: EdgeInsets.symmetric(horizontal: 8.h),
                ),
                SizedBox(height: 20.h),
                _buildSettingsone(context),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Description and action buttons
  Widget _buildSettingsone(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.h),
          decoration: AppDecoration.windowsGlassBlur.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "lbl_a_gentle_reset".tr,
                style: CustomTextStyles.headlineSmallRobotoOnPrimarySemiBold,
              ),
              Text(
                "msg_soft_breath_quiet".tr,
                style: CustomTextStyles.labelLargeRobotoOnPrimary13,
              ),
              SizedBox(height: 2.h),
              Text(
                "lbl_about".tr,
                style: CustomTextStyles.labelLargeRobotoOnPrimary13,
              ),
              SizedBox(height: 2.h),
              Text(
                "msg_this_calming_10_minute".tr,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                    .copyWith(
                  height: 2.0,
                ),
              ),
              SizedBox(height: 6.h),
              _buildActionButtons(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Action buttons (YouTube and Save)
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomElevatedButton(
          height: 42.h,
          width: 154.h,
          text: "msg_watch_it_on_youtube".tr,
          leftIcon: Padding(
            padding: EdgeInsets.only(right: 4.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgPlayRectangleFill,
              height: 16.h,
              width: 20.h,
              fit: BoxFit.contain,
            ),
          ),
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
          buttonTextStyle: CustomTextStyles.labelMediumRobotoSemiBold,
        ),
        SizedBox(width: 8.h),
        CustomElevatedButton(
          height: 42.h,
          width: 78.h,
          text: "lbl_save".tr,
          leftIcon: Padding(
            padding: EdgeInsets.only(right: 4.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgBookmarkOnprimary,
              height: 20.h,
              width: 20.h,
              fit: BoxFit.contain,
            ),
          ),
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
          buttonTextStyle: CustomTextStyles.labelMediumRobotoSemiBold,
        ),
      ],
    );
  }

  /// Search input field
  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Selector<MeditationProvider, TextEditingController?>(
        selector: (context, provider) => provider.searchfieldoneController,
        builder: (context, searchfieldoneController, child) {
          return CustomTextFormField(
            controller: searchfieldoneController,
            hintText: "lbl_ask_me_anything".tr,
            textInputAction: TextInputAction.done,
            prefix: Padding(
              padding: EdgeInsets.only(left: 14.57.h, right: 30.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgMic,
                    height: 24.h,
                    width: 14.84.h,
                    margin: EdgeInsets.fromLTRB(
                      14.57.h,
                      9.49.h,
                      14.59.h,
                      10.51.h,
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
            prefixConstraints: BoxConstraints(maxHeight: 44.h),
            suffix: Container(
              padding: EdgeInsets.all(10.h),
              margin: EdgeInsets.only(left: 30.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                gradient: LinearGradient(
                  begin: Alignment(0.5, 1),
                  end: Alignment(0.5, 0),
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withAlpha(0),
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
            suffixConstraints: BoxConstraints(maxHeight: 44.h),
          );
        },
      ),
    );
  }
}
