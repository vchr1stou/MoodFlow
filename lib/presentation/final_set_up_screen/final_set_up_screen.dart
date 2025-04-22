import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/final_set_up_model.dart';
import 'provider/final_set_up_provider.dart';

class FinalSetUpScreen extends StatefulWidget {
  const FinalSetUpScreen({Key? key}) : super(key: key);

  @override
  FinalSetUpScreenState createState() => FinalSetUpScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalSetUpProvider(),
      child: const FinalSetUpScreen(),
    );
  }
}

class FinalSetUpScreenState extends State<FinalSetUpScreen> {
  @override
  void initState() {
    super.initState();
    // initialization logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: SizedBox(
            height: 830.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(top: 26.h),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.only(top: 32.h),
                          decoration: AppDecoration.outline6,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 96.h),
                              CustomImageView(
                                imagePath: ImageConstant.imgImage176x176,
                                height: 176.h,
                                width: 178.h,
                                radius: BorderRadius.circular(88.h),
                              ),
                              SizedBox(height: 36.h),
                              Text(
                                "msg_you_ve_planted_the".tr,
                                style: CustomTextStyles
                                    .headlineSmallRobotoOnPrimary,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "msg_your_space_is_ready".tr,
                                style: CustomTextStyles.titleMediumSemiBold,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.h),
                                child: Text(
                                  "msg_some_days_will_bloom".tr,
                                  style: CustomTextStyles.titleMediumSemiBold,
                                ),
                              ),
                              Text(
                                "msg_you_ve_started_something".tr,
                                style: CustomTextStyles.titleMediumSemiBold,
                              ),
                              SizedBox(height: 58.h),
                              CustomOutlinedButton(
                                width: 108.h,
                                text: "lbl_step_inside".tr,
                                buttonStyle: CustomButtonStyles.none,
                                decoration:
                                    CustomButtonStyles.outlineTL241Decoration,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildAppBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => NavigatorService.goBack(),
      ),
    );
  }
}
