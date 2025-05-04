import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/reset_password_model.dart';
import 'provider/reset_password_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordProvider(),
      child: const ResetPasswordScreen(),
    );
  }
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(top: 44.h, bottom: 214.h),
              child: SingleChildScrollView(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.h, vertical: 22.h),
                      decoration: AppDecoration.outline14,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Reset Password",
                              style: CustomTextStyles.displayMediumWhiteA700,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Center(
                            child: Text(
                              AppStrings.enterYourNewPassword,
                              style: CustomTextStyles.titleMediumSemiBold16,
                            ),
                          ),
                          SizedBox(height: 102.h),
                          Padding(
                            padding: EdgeInsets.only(left: 6.h),
                            child: Text(
                              AppStrings.enterYourNewPassword2,
                              style: CustomTextStyles.titleMediumWhiteA700,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.only(right: 22.h),
                            child: Selector<ResetPasswordProvider,
                                TextEditingController?>(
                              selector: (context, provider) =>
                                  provider.newPasswordController,
                              builder: (context, controller, _) {
                                return CustomFloatingTextField(
                                  controller: controller,
                                  labelText: "•••••••",
                                  labelStyle: CustomTextStyles
                                      .displayMediumSFProGray700,
                                  hintText: "lbl".tr(),
                                  textInputType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.h, vertical: 12.h),
                                  validator: (value) {
                                    if (value == null ||
                                        !isValidPassword(value,
                                            isRequired: true)) {
                                      return "err_msg_please_enter_valid_password"
                                          .tr();
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 26.h),
                          Padding(
                            padding: EdgeInsets.only(left: 6.h),
                            child: Text(
                              "msg_re_enter_your_new".tr(),
                              style: CustomTextStyles.titleMediumWhiteA700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.only(right: 22.h),
                            child: Selector<ResetPasswordProvider,
                                TextEditingController?>(
                              selector: (context, provider) =>
                                  provider.newPasswordOneController,
                              builder: (context, controller, _) {
                                return CustomFloatingTextField(
                                  controller: controller,
                                  labelText: "lbl".tr(),
                                  labelStyle: CustomTextStyles
                                      .displayMediumSFProGray700,
                                  hintText: "lbl".tr(),
                                  textInputType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.h, vertical: 12.h),
                                  validator: (value) {
                                    if (value == null ||
                                        !isValidPassword(value,
                                            isRequired: true)) {
                                      return "err_msg_please_enter_valid_password"
                                          .tr();
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30.h),
                          CustomOutlinedButton(
                            text: "lbl_continue".tr(),
                            margin: EdgeInsets.symmetric(horizontal: 62.h),
                            buttonStyle: CustomButtonStyles.none,
                            decoration:
                                CustomButtonStyles.outlineTL241Decoration,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Add logic for submission
                              }
                            },
                          ),
                          CustomElevatedButton(
                            height: 42.h,
                            width: 78.h,
                            text: "lbl_save".tr(),
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
                            onPressed: () {
                              // Add action for saving
                              print("Save tapped");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
      leadingWidth: 60.h,
      leading: AppbarLeadingIconbuttonOne(
        imagePath: ImageConstant.imgBack,
        height: 44.h,
        width: 44.h,
        margin: EdgeInsets.only(left: 16.h),
      ),
    );
  }
}
