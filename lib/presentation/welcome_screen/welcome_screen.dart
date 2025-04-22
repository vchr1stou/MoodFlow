import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/welcome_model.dart';
import 'provider/welcome_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeProvider(),
      child: WelcomeScreen(),
    );
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      NavigatorService.popAndPushNamed(
        AppRoutes.loginScreen,
      );
    });
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
            child: Column(
              children: [
                Spacer(),
                SizedBox(
                  width: double.maxFinite,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 30.h),
                        decoration: AppDecoration.outline6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgImage,
                              height: 152.h,
                              width: 154.h,
                              radius: BorderRadius.circular(76.h),
                            ),
                            SizedBox(height: 18.h),
                            Text(
                              "lbl_moodflow".tr,
                              style: CustomTextStyles.displayMediumWhiteA700,
                            ),
                            SizedBox(height: 6.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.h),
                              child: Text(
                                "msg_let_your_feelings".tr,
                                style: CustomTextStyles.titleMediumWhiteA700,
                              ),
                            ),
                            SizedBox(height: 156.h),
                            CustomOutlinedButton(
                              text: "lbl_login".tr,
                              buttonStyle: CustomButtonStyles.none,
                              decoration:
                                  CustomButtonStyles.outlineTL241Decoration,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "lbl_or".tr,
                              style:
                                  CustomTextStyles.labelMediumRobotoOnPrimary11,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "msg_create_a_new_account".tr,
                              style: CustomTextStyles
                                  .labelLargeRobotoOnPrimaryBold13_1,
                            ),
                            SizedBox(height: 56.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 34.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
