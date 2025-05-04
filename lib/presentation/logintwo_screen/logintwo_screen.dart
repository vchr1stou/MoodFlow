import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/logintwo_model.dart';
import 'provider/logintwo_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LogintwoScreen extends StatefulWidget {
  const LogintwoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogintwoScreenState createState() => LogintwoScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogintwoProvider(),
      child: LogintwoScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LogintwoScreenState extends State<LogintwoScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(top: 56.h),
              child: SingleChildScrollView(
                child: Container(
                  height: 760.h,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4,
                              sigmaY: 4,
                            ),
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.h,
                                vertical: 14.h,
                              ),
                              decoration: AppDecoration.outline,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 12.h,
                                      right: 8.h,
                                    ),
                                    child: Text(
                                      "msg_we_re_glad_you_re".tr(),
                                      style: theme.textTheme.headlineLarge,
                                    ),
                                  ),
                                  Text(
                                    "msg_let_s_set_up_your".tr(),
                                    style: CustomTextStyles
                                        .titleLargeRobotoOnPrimaryContainer,
                                  ),
                                  SizedBox(height: 40.h),
                                  _buildColumnname(context),
                                  SizedBox(height: 18.h),
                                  _buildColumnpronoums(context),
                                  SizedBox(height: 16.h),
                                  _buildEmailone(context),
                                  SizedBox(height: 20.h),
                                  _buildPasswordone(context),
                                  SizedBox(height: 74.h)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildColumnconfirm(context)
                    ],
                  ),
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
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 13.h,
          bottom: 13.h,
        ),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnname(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_name".tr(),
              style: CustomTextStyles.titleMediumRobotoWhiteA700,
            ),
          ),
          Selector<LogintwoProvider, TextEditingController?>(
            selector: (context, provider) => provider.nametwoController,
            builder: (context, nametwoController, child) {
              return CustomTextFormField(
                controller: nametwoController,
                hintText: "lbl_john_appleseed".tr(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.h,
                  vertical: 10.h,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnpronoums(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_pronoums".tr(),
              style: CustomTextStyles.titleMediumRobotoWhiteA700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.h,
              vertical: 10.h,
            ),
            decoration: AppDecoration.recessed.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder22,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 176.h,
                  child: Text(
                    "msg_select_your_pronouns".tr(),
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumGray70001,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRightRed100,
                  height: 16.h,
                  width: 12.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_email".tr(),
              style: CustomTextStyles.titleMediumRobotoWhiteA700,
            ),
          ),
          Selector<LogintwoProvider, TextEditingController?>(
            selector: (context, provider) => provider.emailthreeController,
            builder: (context, emailthreeController, child) {
              return CustomTextFormField(
                controller: emailthreeController,
                hintText: "msg_johnappleseed_exaple_com".tr(),
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.h,
                  vertical: 10.h,
                ),
                validator: (value) {
                  if (value == null ||
                      (!isValidEmail(value, isRequired: true))) {
                    return "err_msg_please_enter_valid_email".tr();
                  }
                  return null;
                },
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_password".tr(),
              style: CustomTextStyles.titleMediumRobotoWhiteA700,
            ),
          ),
          Consumer<LogintwoProvider>(
            builder: (context, provider, child) {
              return CustomTextFormField(
                controller: provider.passwordthreeController,
                suffix: InkWell(
                  onTap: () {
                    provider.changePasswordVisibility();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.h,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgEye,
                      height: 20.h,
                      width: 20.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                suffixConstraints: BoxConstraints(
                  maxHeight: 44.h,
                ),
                obscureText: provider.isShowPassword,
                contentPadding: EdgeInsets.fromLTRB(18.h, 10.h, 16.h, 10.h),
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordfour(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "msg_confirm_password".tr(),
              style: CustomTextStyles.titleMediumRobotoWhiteA700,
            ),
          ),
          Consumer<LogintwoProvider>(
            builder: (context, provider, child) {
              return CustomTextFormField(
                controller: provider.confirmpasswordController,
                textInputAction: TextInputAction.done,
                suffix: InkWell(
                  onTap: () {
                    provider.changePasswordVisibility1();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.h,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgEye,
                      height: 20.h,
                      width: 20.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                suffixConstraints: BoxConstraints(
                  maxHeight: 44.h,
                ),
                obscureText: provider.isShowPassword1,
                contentPadding: EdgeInsets.fromLTRB(18.h, 10.h, 16.h, 10.h),
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnconfirm(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        spacing: 32,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPasswordfour(context),
          CustomOutlinedButton(
            height: 48.h,
            width: 108.h,
            text: "lbl_next".tr(),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.outlineDecoration,
            buttonTextStyle:
                CustomTextStyles.labelLargeRobotoOnPrimaryContainerBold13_1,
            alignment: Alignment.centerRight,
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack(context);
  }
}
