import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_button_one.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';

import 'models/log_input_ai_model.dart';
import 'provider/log_input_ai_provider.dart';

class LogInputAiScreen extends StatefulWidget {
  const LogInputAiScreen({Key? key}) : super(key: key);

  @override
  LogInputAiScreenState createState() => LogInputAiScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInputAiProvider(),
      child: LogInputAiScreen(),
    );
  }
}

class LogInputAiScreenState extends State<LogInputAiScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray6004c,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 830.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Selector<LogInputAiProvider, TextEditingController?>(
                    selector: (context, provider) => provider.miconeController,
                    builder: (context, miconeController, child) {
                      return CustomTextFormField(
                        controller: miconeController,
                        hintText: "lbl_ask_me_anything".tr(),
                        textInputAction: TextInputAction.done,
                        alignment: Alignment.bottomCenter,
                        prefix: Padding(
                          padding: EdgeInsets.fromLTRB(
                            29.58.h,
                            30.h,
                            30.h,
                            30.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgMic,
                                height: 24.h,
                                width: 14.83.h,
                                margin: EdgeInsets.fromLTRB(
                                  29.58.h,
                                  30.h,
                                  14.59.h,
                                  30.h,
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
                        prefixConstraints: BoxConstraints(
                          maxHeight: 234.h,
                        ),
                        suffix: Container(
                          padding: EdgeInsets.all(10.h),
                          margin: EdgeInsets.fromLTRB(
                            30.h,
                            30.h,
                            14.h,
                            30.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.h),
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 1),
                              end: Alignment(0.5, 0),
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(alpha: 0),
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
                          maxHeight: 234.h,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 106.h),
                        boxDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.5, 0),
                            end: Alignment(0.5, 0.53),
                            colors: [
                              appTheme.black900.withValues(alpha: 0.1),
                              appTheme.gray70019,
                            ],
                          ),
                        ),
                        borderDecoration:
                            TextFormFieldStyleHelper.gradientBlackToGray,
                        filled: false,
                      );
                    },
                  ),
                  _buildStackhelp(context),
                  CustomImageView(
                    imagePath: ImageConstant.imgSirianimationshakyphone15pro,
                    height: 830.h,
                    width: double.maxFinite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStackhelp(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 162.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: AppDecoration.outline2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        height: 30.h,
                        actions: [
                          AppbarTrailingButtonOne(),
                          AppbarTrailingIconbuttonOne(
                            imagePath: ImageConstant.imgClose,
                            margin: EdgeInsets.only(
                              left: 13.h,
                              right: 25.h,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "msg_how_are_you_feeling2".tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineLargeSFPro.copyWith(
                  height: 1.19,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
