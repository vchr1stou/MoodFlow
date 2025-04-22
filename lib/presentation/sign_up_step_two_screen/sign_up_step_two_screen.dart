import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/sign_up_step_two_model.dart';
import 'provider/sign_up_step_two_provider.dart';

class SignUpStepTwoScreen extends StatefulWidget {
  const SignUpStepTwoScreen({Key? key}) : super(key: key);

  @override
  SignUpStepTwoScreenState createState() => SignUpStepTwoScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepTwoProvider(),
      child: SignUpStepTwoScreen(),
    );
  }
}

class SignUpStepTwoScreenState extends State<SignUpStepTwoScreen> {
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
                height: 760.h,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.h, vertical: 8.h),
                            decoration: AppDecoration.outline6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "msg_gentle_reminders".tr,
                                  style: theme.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "msg_we_ll_nudge_you".tr,
                                  style: CustomTextStyles
                                      .titleLargeRobotoOnPrimary_1,
                                ),
                                SizedBox(height: 6.h),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 6.h),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "lbl2".tr,
                                            style: CustomTextStyles
                                                .titleMediumBold,
                                          ),
                                          TextSpan(
                                            text: "msg_a_daily_check_in".tr,
                                            style: CustomTextStyles
                                                .titleSmallRobotoOnPrimary_2,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 6.h, right: 4.h),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "lbl3".tr,
                                          style:
                                              CustomTextStyles.titleMediumBold,
                                        ),
                                        TextSpan(
                                          text: "msg_a_quote_of_the_day".tr,
                                          style: CustomTextStyles
                                              .titleSmallRobotoOnPrimary_2,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                _buildAlert(context),
                                SizedBox(height: 138.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildColumnQuoteOfThe(context),
                  ],
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
        margin: EdgeInsets.only(left: 16.h, top: 13.h, bottom: 13.h),
        onTap: () => onTapArrowleftone(context),
      ),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder28,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "msg_daily_check_in".tr,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Selector<SignUpStepTwoProvider, bool?>(
                        selector: (context, provider) =>
                            provider.isSelectedSwitch,
                        builder: (context, isSelectedSwitch, child) {
                          return CustomSwitch(
                            value: isSelectedSwitch,
                            onChange: (value) {
                              context
                                  .read<SignUpStepTwoProvider>()
                                  .changeSwitchBox(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(10.h),
                  decoration: AppDecoration.outline7.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder32,
                  ),
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.h, right: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "lbl_9_30".tr,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgTrashFill1,
                              height: 24.h,
                              width: 20.h,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgPencil1,
                              height: 16.h,
                              width: 20.h,
                              margin: EdgeInsets.only(left: 6.h),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Divider(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.h, right: 6.h),
                        child: _buildRowSpacerTwo(context,
                            timeThree: "lbl_14_30".tr),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Divider(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.h, right: 6.h),
                        child: _buildRowSpacerTwo(context,
                            timeThree: "lbl_20_30".tr),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Divider(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.h, right: 6.h),
                        child: _buildRowSpacerTwo(context,
                            timeThree: "lbl_23_30".tr),
                      ),
                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnQuoteOfThe(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 14.h),
            decoration: AppDecoration.windowsGlass.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: AppDecoration.outline7.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder28,
                  ),
                  width: double.maxFinite,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                      child: Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Text(
                                "msg_quote_of_the_day2".tr,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            Selector<SignUpStepTwoProvider, bool?>(
                              selector: (context, provider) =>
                                  provider.isSelectedSwitch1,
                              builder: (context, isSelectedSwitch1, child) {
                                return CustomSwitch(
                                  value: isSelectedSwitch1,
                                  onChange: (value) {
                                    context
                                        .read<SignUpStepTwoProvider>()
                                        .changeSwitchBox1(value);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomOutlinedButton(
            width: 108.h,
            text: "lbl_next".tr,
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.outlineTL241Decoration,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Widget _buildRowSpacerTwo(BuildContext context, {required String timeThree}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          timeThree,
          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.96),
          ),
        ),
        Spacer(),
        CustomImageView(
          imagePath: ImageConstant.imgTrashFill1,
          height: 24.h,
          width: 20.h,
        ),
        CustomImageView(
          imagePath: ImageConstant.imgPencil1,
          height: 16.h,
          width: 20.h,
          margin: EdgeInsets.only(left: 6.h),
        ),
      ],
    );
  }

  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
