import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/music_model.dart';
import 'provider/music_provider.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  MusicScreenState createState() => MusicScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: MusicScreen(),
    );
  }
}

class MusicScreenState extends State<MusicScreen> {
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
                  spacing: 28,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 4.h,
                            ),
                            decoration: AppDecoration.fillGray.copyWith(
                              borderRadius: BorderRadiusStyle.circleBorder18,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.hitPlayClose,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles
                                      .titleMediumSecondaryContainer
                                      .copyWith(
                                    height: 1.29,
                                  ),
                                ),
                                SizedBox(height: 2.h)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                              vertical: 20.h,
                            ),
                            decoration: AppDecoration.windowsGlassBlur.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder32,
                            ),
                            child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2.h),
                                CustomImageView(
                                  imagePath: ImageConstant.imgAnyoneButYou13,
                                  height: 176.h,
                                  width: double.maxFinite,
                                  radius: BorderRadius.circular(16.h),
                                  margin: EdgeInsets.only(
                                    left: 10.h,
                                    right: 8.h,
                                  ),
                                ),
                                _buildSettingsOne(context)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: Selector<MusicProvider, TextEditingController?>(
                        selector: (context, provider) =>
                            provider.searchfieldoneController,
                        builder: (context, searchfieldoneController, child) {
                          return CustomTextFormField(
                            controller: searchfieldoneController,
                            hintText: "Ask me anything",
                            textInputAction: TextInputAction.done,
                            prefix: Padding(
                              padding: EdgeInsets.only(
                                left: 14.580002.h,
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
                                      14.580002.h,
                                      9.48999.h,
                                      14.579998.h,
                                      10.51001.h,
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgHighlightFrame,
                                    height: 44.h,
                                    width: 8.h,
                                  )
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
                    SizedBox(height: 58.h)
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
        text: "Little Lifts",
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildSettingsOne(BuildContext context) {
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
              vertical: 4.h,
            ),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    "Reset",
                    style:
                        CustomTextStyles.headlineSmallRobotoOnPrimarySemiBold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    "Selection Quote",
                    style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    "About",
                    style: CustomTextStyles.labelLargeRobotoOnPrimary13,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    AppStrings.selectionParagraph,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                        .copyWith(
                      height: 2.00,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevatedButton(
                        height: 42.h,
                        width: 130.h,
                        text: "Play on Spotify",
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgIconsPrimary18x18,
                            height: 18.h,
                            width: 18.h,
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
                        text: "Save",
                        margin: EdgeInsets.only(left: 8.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 2.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgBookmarkOnPrimary,
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
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
