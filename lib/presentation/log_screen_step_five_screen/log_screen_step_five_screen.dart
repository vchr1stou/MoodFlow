import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/log_screen_step_five_model.dart';
import 'provider/log_screen_step_five_provider.dart';

class LogScreenStepFiveScreen extends StatefulWidget {
  const LogScreenStepFiveScreen({Key? key}) : super(key: key);

  @override
  LogScreenStepFiveScreenState createState() => LogScreenStepFiveScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStepFiveProvider(),
      child: LogScreenStepFiveScreen(),
    );
  }
}

class LogScreenStepFiveScreenState extends State<LogScreenStepFiveScreen> {
  @override
  void initState() {
    super.initState();
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
            child: SingleChildScrollView(
              child: Container(
                height: 936.h,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8.h,
                          top: 202.h,
                          right: 8.h,
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4,
                              sigmaY: 4,
                            ),
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(horizontal: 6.h),
                              decoration: AppDecoration.gradientBlackToGray,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 22.h),
                                  Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(
                                      left: 30.h,
                                      right: 18.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 138.h,
                                          margin: EdgeInsets.only(bottom: 24.h),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.maxFinite,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgForward,
                                                      height: 14.h,
                                                      width: 14.h,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                    ),
                                                    CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgSettingsPinkA100,
                                                      height: 18.h,
                                                      width: 12.h,
                                                      margin: EdgeInsets.only(
                                                        right: 28.h,
                                                        bottom: 12.h,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.maxFinite,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 6.h),
                                                child: Row(
                                                  children: [
                                                    CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgTelevisionPinkA100,
                                                      height: 22.h,
                                                      width: 24.h,
                                                    ),
                                                    CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgTelevisionCyan400,
                                                      height: 10.h,
                                                      width: 12.h,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgBookmarkPurple500,
                                          height: 24.h,
                                          width: 30.h,
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.only(left: 2.h),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgSettingsPurple700,
                                          height: 22.h,
                                          width: 22.h,
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.only(
                                            left: 18.h,
                                            bottom: 14.h,
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgUserCyan400,
                                          height: 10.h,
                                          width: 12.h,
                                          margin: EdgeInsets.only(
                                            left: 2.h,
                                            top: 32.h,
                                          ),
                                        ),
                                        Spacer(),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionCyan40014x22,
                                          height: 14.h,
                                          width: 24.h,
                                          alignment: Alignment.center,
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionPinkA10012x10,
                                          height: 12.h,
                                          width: 12.h,
                                          margin: EdgeInsets.only(
                                            left: 4.h,
                                            top: 30.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 28.h),
                                  _buildRowallthefeels(context),
                                  SizedBox(height: 6.h),
                                  Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(
                                      left: 48.h,
                                      right: 52.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgUserPurple500,
                                          height: 12.h,
                                          width: 14.h,
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionCyan40016x18,
                                          height: 16.h,
                                          width: 20.h,
                                          margin: EdgeInsets.only(left: 26.h),
                                        ),
                                        Spacer(flex: 38),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionPinkA10018x16,
                                          height: 18.h,
                                          width: 18.h,
                                          alignment: Alignment.topCenter,
                                        ),
                                        Spacer(flex: 61),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionPurple500,
                                          height: 14.h,
                                          width: 28.h,
                                          margin: EdgeInsets.only(bottom: 10.h),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(
                                      left: 30.h,
                                      right: 24.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgContrastPurple700,
                                          height: 18.h,
                                          width: 26.h,
                                        ),
                                        Spacer(flex: 75),
                                        Container(
                                          height: 26.h,
                                          width: 38.h,
                                          margin: EdgeInsets.only(top: 2.h),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgThumbsUpPurple500,
                                                height: 14.h,
                                                width: 14.h,
                                                alignment:
                                                    Alignment.bottomRight,
                                              ),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgTelevisionPurple700,
                                                height: 24.h,
                                                width: double.maxFinite,
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant
                                              .imgTelevisionPurple50018x22,
                                          height: 18.h,
                                          width: 24.h,
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.only(left: 10.h),
                                        ),
                                        Spacer(flex: 24),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgVector,
                                          height: 14.h,
                                          width: 26.h,
                                          alignment: Alignment.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  _buildRowthumbsup(context),
                                  SizedBox(height: 10.h),
                                  _buildRowspacersix(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildHorizontalscrol(context),
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
  Widget _buildRowallthefeels(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "msg_all_the_feels_captured".tr,
                    style: CustomTextStyles.headlineSmall24,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgSort,
                      height: 16.h,
                      width: 12.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          "msg_another_step_in".tr,
                          style: CustomTextStyles.titleMediumSFProBold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgBookmarkPurple700,
            height: 34.h,
            width: 26.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 6.h),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRowthumbsup(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpPurple50020x14,
            height: 20.h,
            width: 16.h,
            alignment: Alignment.topCenter,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgTelevisionPinkA10014x16,
            height: 14.h,
            width: 18.h,
            margin: EdgeInsets.only(left: 6.h),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgSettingsPinkA10032x12,
            height: 32.h,
            width: 14.h,
            margin: EdgeInsets.only(
              left: 6.h,
              top: 2.h,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpPurple50016x14,
            height: 16.h,
            width: 16.h,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 2.h),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgBookmarkCyan400,
            height: 30.h,
            width: 24.h,
            margin: EdgeInsets.only(
              left: 24.h,
              right: 110.h,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRowspacersix(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 24),
          CustomImageView(
            imagePath: ImageConstant.imgBookmarkPurple70030x32,
            height: 30.h,
            width: 34.h,
            alignment: Alignment.bottomCenter,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgVectorPurple500,
            height: 26.h,
            width: 12.h,
            margin: EdgeInsets.only(
              left: 6.h,
              top: 4.h,
            ),
          ),
          Spacer(flex: 34),
          CustomImageView(
            imagePath: ImageConstant.imgBookmarkPurple50024x24,
            height: 24.h,
            width: 26.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10.h),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpCyan400,
            height: 10.h,
            width: 14.h,
            margin: EdgeInsets.only(
              left: 4.h,
              top: 2.h,
            ),
          ),
          Spacer(flex: 21),
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpCyan40012x14,
            height: 12.h,
            width: 16.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20.h),
          ),
          Spacer(flex: 19),
          CustomImageView(
            imagePath: ImageConstant.imgTelevisionPurple50010x16,
            height: 10.h,
            width: 18.h,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHorizontalscrol(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: SizedBox(
          height: 936.h,
          width: 608.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // ... remaining children ...
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
