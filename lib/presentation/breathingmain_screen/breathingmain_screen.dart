import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/breathingmain_model.dart';
import 'provider/breathingmain_provider.dart';

class BreathingmainScreen extends StatefulWidget {
  const BreathingmainScreen({Key? key}) : super(key: key);

  @override
  BreathingmainScreenState createState() => BreathingmainScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BreathingmainProvider(),
      child: BreathingmainScreen(),
    );
  }
}

class BreathingmainScreenState extends State<BreathingmainScreen> {
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
            padding: EdgeInsets.only(left: 16.h, top: 56.h, right: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgScreenshot20250329,
                  height: 160.h,
                  width: 150.h,
                ),
                Text(
                  "lbl_breathing".tr,
                  style: CustomTextStyles.displayMediumSemiBold,
                ),
                SizedBox(height: 6.h),
                _buildColumndescripti(context),
                SizedBox(height: 32.h),
                Text(
                  "lbl_set_duration".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryMedium,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 202.h,
                  decoration: AppDecoration.gradientPrimaryToPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<BreathingmainProvider>()
                              .decrementQuantity();
                        },
                        child: Container(
                          height: 42.h,
                          width: 44.h,
                          decoration: AppDecoration.outline13.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder18,
                          ),
                          child: Center(
                            child: CustomImageView(
                              imagePath: ImageConstant.imgMinus1,
                              height: 2.h,
                              width: 18.h,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40.h,
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: Selector<BreathingmainProvider, int?>(
                            selector: (context, provider) =>
                                provider.lblQuantity,
                            builder: (context, lblQuantity, child) {
                              return Text(
                                (lblQuantity ?? "").toString(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: CustomTextStyles.titleSmallSemiBold,
                              );
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<BreathingmainProvider>()
                              .incrementQuantity();
                        },
                        child: Container(
                          height: 42.h,
                          width: 44.h,
                          decoration: AppDecoration.outline13.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder18,
                          ),
                          child: Center(
                            child: CustomImageView(
                              imagePath: ImageConstant.imgPlus1,
                              height: 16.h,
                              width: 18.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                CustomOutlinedButton(
                  height: 36.h,
                  width: 118.h,
                  text: "lbl_begin".tr,
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineTL18Decoration,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar section
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_saved".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Description box section
  Widget _buildColumndescripti(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 20.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "msg_find_a_quiet_cozy".tr,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style:
                CustomTextStyles.titleSmallRobotoOnPrimarySemiBold14.copyWith(
              height: 1.79,
            ),
          ),
        ],
      ),
    );
  }
}
