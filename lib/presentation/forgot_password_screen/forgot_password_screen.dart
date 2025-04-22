import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';

import 'models/forgot_password_model.dart';
import 'provider/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: const ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(top: 44.h),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(26.h),
                    decoration: AppDecoration.outline14,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          child: Text(
                            "msg_forgot_password".tr,
                            style: CustomTextStyles.displayMediumWhiteA700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "msg_enter_your_email".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.titleMediumSemiBold16
                              .copyWith(height: 1.38),
                        ),
                        SizedBox(height: 78.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "msg_enter_your_email2".tr,
                            style: CustomTextStyles.titleMediumWhiteA700,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.only(right: 12.h),
                          child: Selector<ForgotPasswordProvider,
                              TextEditingController?>(
                            selector: (_, provider) => provider.emailController,
                            builder: (_, emailController, __) {
                              return CustomTextFormField(
                                controller: emailController,
                                hintText: "msg_johnappleseed_example_com".tr,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.emailAddress,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 18.h,
                                  vertical: 10.h,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      !isValidEmail(value, isRequired: true)) {
                                    return "err_msg_please_enter_valid_email"
                                        .tr;
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomOutlinedButton(
                          text: "lbl_continue".tr,
                          margin: EdgeInsets.symmetric(horizontal: 56.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles.outlineTL241Decoration,
                        ),
                        SizedBox(height: 4.h),
                      ],
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
      leadingWidth: 60.h,
      leading: AppbarLeadingIconbuttonOne(
        imagePath: ImageConstant.imgBack,
        height: 44.h,
        width: 44.h,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => NavigatorService.goBack(),
      ),
    );
  }
}
