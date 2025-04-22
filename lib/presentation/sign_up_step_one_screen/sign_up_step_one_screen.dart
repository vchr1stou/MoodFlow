import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/sign_up_step_one_model.dart';
import 'provider/sign_up_step_one_provider.dart';

class SignUpStepOneScreen extends StatefulWidget {
  const SignUpStepOneScreen({Key? key}) : super(key: key);

  @override
  SignUpStepOneScreenState createState() => SignUpStepOneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepOneProvider(),
      child: SignUpStepOneScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class SignUpStepOneScreenState extends State<SignUpStepOneScreen> {
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
                    alignment: Alignment.bottomLeft,
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
                              decoration: AppDecoration.outline6,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 12.h,
                                        right: 8.h,
                                      ),
                                      child: Text(
                                        "msg_we_re_glad_you_re".tr,
                                        style: theme.textTheme.headlineLarge,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "msg_let_s_set_up_your".tr,
                                      style: CustomTextStyles
                                          .titleLargeRobotoOnPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "lbl_name".tr,
                                      style:
                                          CustomTextStyles.titleMediumWhiteA700,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildNametwo(context),
                                  SizedBox(height: 18.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "lbl_pronoums".tr,
                                      style:
                                          CustomTextStyles.titleMediumWhiteA700,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildRowvalue(context),
                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "lbl_email2".tr,
                                      style:
                                          CustomTextStyles.titleMediumWhiteA700,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildEmailtwo(context),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "lbl_password".tr,
                                      style:
                                          CustomTextStyles.titleMediumWhiteA700,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildPasswordtwo(context),
                                  SizedBox(height: 74.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildColumnconfirm(context),
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

  Widget _buildNametwo(BuildContext context) {
    return Selector<SignUpStepOneProvider, TextEditingController?>(
      selector: (context, provider) => provider.nametwoController,
      builder: (context, nametwoController, child) {
        return CustomTextFormField(
          controller: nametwoController,
          hintText: "lbl_john_appleseed".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.h,
            vertical: 10.h,
          ),
        );
      },
    );
  }

  Widget _buildRowvalue(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.viewsRecessedMaterialView.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder24,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 176.h,
            child: Text(
              "msg_select_your_pronouns".tr,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.titleMediumSFProGray700,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightRed100,
            height: 16.h,
            width: 12.h,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailtwo(BuildContext context) {
    return Selector<SignUpStepOneProvider, TextEditingController?>(
      selector: (context, provider) => provider.emailtwoController,
      builder: (context, emailtwoController, child) {
        return CustomTextFormField(
          controller: emailtwoController,
          hintText: "msg_johnappleseed_exaple_com".tr,
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.h,
            vertical: 10.h,
          ),
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildPasswordtwo(BuildContext context) {
    return Consumer<SignUpStepOneProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          controller: provider.passwordtwoController,
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
                borderRadius: BorderRadius.circular(10.h),
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
    );
  }

  Widget _buildConfirmpassword(BuildContext context) {
    return Consumer<SignUpStepOneProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          width: 340.h,
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
                borderRadius: BorderRadius.circular(10.h),
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
    );
  }

  Widget _buildNext(BuildContext context) {
    return CustomOutlinedButton(
      width: 108.h,
      text: "lbl_next".tr,
      margin: EdgeInsets.only(right: 20.h),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.outlineTL241Decoration,
      alignment: Alignment.centerRight,
    );
  }

  Widget _buildColumnconfirm(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 30.h,
        bottom: 32.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "msg_confirm_password".tr,
              style: CustomTextStyles.titleMediumWhiteA700,
            ),
          ),
          SizedBox(height: 12.h),
          _buildConfirmpassword(context),
          SizedBox(height: 32.h),
          _buildNext(context),
        ],
      ),
    );
  }

  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
