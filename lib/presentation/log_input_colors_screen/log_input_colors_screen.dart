import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/log_input_colors_model.dart';
import 'provider/log_input_colors_provider.dart';

class LogInputColorsScreen extends StatefulWidget {
  const LogInputColorsScreen({Key? key}) : super(key: key);

  @override
  LogInputColorsScreenState createState() => LogInputColorsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInputColorsProvider(),
      child: const LogInputColorsScreen(),
    );
  }
}

class LogInputColorsScreenState extends State<LogInputColorsScreen> {
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
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 18.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "msg_what_color_is_your".tr,
                          style: CustomTextStyles.headlineSmallOnPrimary,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.h,
                            right: 6.h,
                          ),
                          child: Text(
                            "msg_dip_into_the_rainbow".tr,
                            style: CustomTextStyles.labelMediumOnPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "msg_bright_and_beaming".tr,
                          style: CustomTextStyles.labelMediumOnPrimary,
                        ),
                        SizedBox(height: 48.h),
                        SizedBox(
                          height: 490.h,
                          width: double.maxFinite,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 406.h,
                                  width: 366.h,
                                  decoration: BoxDecoration(
                                    color: appTheme.gray5019,
                                  ),
                                ),
                              ),
                              Container(
                                height: 488.h,
                                margin: EdgeInsets.symmetric(horizontal: 2.h),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgSpectrum,
                                      height: 488.h,
                                      width: double.maxFinite,
                                      radius: BorderRadius.circular(32.h),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        height: 32.h,
                                        width: 32.h,
                                        margin: EdgeInsets.only(top: 4.h),
                                        decoration: BoxDecoration(
                                          color: appTheme.deepOrangeA400,
                                          borderRadius:
                                              BorderRadius.circular(16.h),
                                          border: Border.all(
                                            color: theme.colorScheme.onPrimary
                                                .withValues(alpha: 0.8),
                                            width: 2.h,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: appTheme.black900
                                                  .withValues(alpha: 0.2),
                                              spreadRadius: 2.h,
                                              blurRadius: 2.h,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnpaintthe(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(
            top: 13.h,
            right: 24.h,
            bottom: 13.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildColumnpaintthe(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlinedButton(
            height: 36.h,
            width: 180.h,
            text: "lbl_paint_the_mood".tr,
            margin: EdgeInsets.only(bottom: 12.h),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.outlineTL18Decoration,
            buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
          ),
        ],
      ),
    );
  }
}
