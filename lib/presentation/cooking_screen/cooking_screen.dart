import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';

import 'models/cooking_model.dart';
import 'provider/cooking_provider.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({Key? key}) : super(key: key);

  @override
  CookingScreenState createState() => CookingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CookingProvider(),
      child: const CookingScreen(),
    );
  }
}

class CookingScreenState extends State<CookingScreen> {
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
            padding: EdgeInsets.only(top: 56.h),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.h,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowContrastOne(context),
                    const SizedBox(height: 20),
                    _buildGlassCard(context),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                      ),
                      child: Selector<CookingProvider, TextEditingController?>(
                        selector: (context, provider) =>
                            provider.searchfieldoneController,
                        builder: (context, searchController, child) {
                          return CustomTextFormField(
                            controller: searchController,
                            hintText: "lbl_ask_me_anything".tr(),
                            textInputAction: TextInputAction.done,
                            prefix: Padding(
                              padding: EdgeInsets.only(
                                left: 14.58.h,
                                right: 30.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgMic,
                                    height: 24.h,
                                    width: 14.83.h,
                                    margin: EdgeInsets.fromLTRB(
                                        14.58.h, 9.49.h, 14.59.h, 10.51.h),
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
                            suffixConstraints: BoxConstraints(
                              maxHeight: 44.h,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 56.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  Widget _buildRowContrastOne(BuildContext context) {
    return Container(
      width: 324.h,
      decoration: AppDecoration.fillIndigo.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgContrastIndigo50,
            height: 14.h,
            width: 20.h,
            alignment: Alignment.bottomCenter,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "msg_a_warm_kitchen".tr(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.titleSmallRobotoSecondaryContainer
                  .copyWith(height: 1.47),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: AppDecoration.outline12,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 24.h,
                      ),
                      decoration: AppDecoration.windowsGlassBlur.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgAnyoneButYou1176x312,
                            height: 176.h,
                            width: double.maxFinite,
                            radius: BorderRadius.circular(16.h),
                            margin: EdgeInsets.symmetric(horizontal: 10.h),
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsOne(context),
                          SizedBox(height: 14.h),
                        ],
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

  Widget _buildSettingsOne(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4.h,
            vertical: 6.h,
          ),
          decoration: AppDecoration.windowsGlassBlur.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6.h),
                child: Text(
                  "msg_italian_carbonara".tr(),
                  style: CustomTextStyles.titleLargeRobotoOnPrimarySemiBold23,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.h),
                child: Text(
                  "msg_20_mins_4_portions".tr(),
                  style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.only(left: 6.h),
                child: Text(
                  "lbl_about".tr(),
                  style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.only(left: 6.h),
                child: Text(
                  "msg_imagine_a_twirl".tr(),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                      .copyWith(height: 2.0),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomElevatedButton(
                    height: 42.h,
                    width: 120.h,
                    text: "lbl_get_the_recipe".tr(),
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
                    decoration:
                        CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
                    buttonTextStyle: CustomTextStyles.labelSmallRoboto,
                  ),
                  SizedBox(width: 8.h),
                  CustomElevatedButton(
                    height: 42.h,
                    width: 78.h,
                    text: "lbl_save".tr(),
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
                    decoration:
                        CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
                    buttonTextStyle: CustomTextStyles.labelMediumRobotoSemiBold,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
