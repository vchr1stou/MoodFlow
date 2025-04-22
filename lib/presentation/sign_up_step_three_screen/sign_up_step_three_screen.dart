import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/sign_up_step_three_model.dart';
import 'provider/sign_up_step_three_provider.dart';

class SignUpStepThreeScreen extends StatefulWidget {
  const SignUpStepThreeScreen({Key? key}) : super(key: key);

  @override
  SignUpStepThreeScreenState createState() => SignUpStepThreeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepThreeProvider(),
      child: SignUpStepThreeScreen(),
    );
  }
}

class SignUpStepThreeScreenState extends State<SignUpStepThreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 56.h),
              padding: EdgeInsets.only(top: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildIntroSection(context),
                  SizedBox(height: 40.h),
                  _buildAlert(context),
                  SizedBox(height: 148.h),
                  CustomOutlinedButton(
                    width: 108.h,
                    text: "lbl_next".tr,
                    margin: EdgeInsets.only(right: 20.h),
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL241Decoration,
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the app bar with a back arrow
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 13.h),
        onTap: () => onTapArrowleftone(context),
      ),
    );
  }

  /// Builds the introductory message and illustration
  Widget _buildIntroSection(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          decoration: AppDecoration.outline6,
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgGroupOnprimary,
                height: 84.h,
                width: 154.h,
              ),
              SizedBox(height: 10.h),
              Text(
                "lbl_your_safety_net".tr,
                style: theme.textTheme.headlineLarge,
              ),
              Text(
                "msg_we_all_have_people".tr,
                style: CustomTextStyles.titleSmallRobotoOnPrimary14,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Text(
                  "msg_save_them_here".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.titleSmallRobotoOnPrimary14
                      .copyWith(height: 1.57),
                ),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the trusted contact section with add button
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        children: [
          Text(
            "msg_add_a_trusted_contact".tr,
            style: CustomTextStyles.titleMediumSFProOnPrimaryBold_1,
          ),
          SizedBox(height: 18.h),
          CustomIconButton(
            height: 56.h,
            width: 58.h,
            padding: EdgeInsets.all(16.h),
            decoration: IconButtonStyleHelper.fillPrimaryTL28,
            child: CustomImageView(imagePath: ImageConstant.imgPlus1),
          ),
        ],
      ),
    );
  }

  /// Navigates back
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
