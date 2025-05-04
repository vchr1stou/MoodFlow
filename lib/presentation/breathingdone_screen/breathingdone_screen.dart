import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/breathingdone_model.dart';
import 'provider/breathingdone_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BreathingdoneScreen extends StatefulWidget {
  const BreathingdoneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  BreathingdoneScreenState createState() => BreathingdoneScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BreathingdoneProvider(),
      child: const BreathingdoneScreen(),
    );
  }
}

class BreathingdoneScreenState extends State<BreathingdoneScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            padding: EdgeInsets.symmetric(vertical: 126.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 18.h),
                CustomImageView(
                  imagePath: ImageConstant.imgScreenshot20250329,
                  height: 160.h,
                  width: 150.h,
                ),
                Text(
                  "lbl_well_done".tr(),
                  style: CustomTextStyles.displayMediumOnPrimaryContainer,
                ),
                Text(
                  "msg_the_world_can_wait".tr(),
                  style: CustomTextStyles
                      .titleLargeRobotoOnPrimaryContainerSemiBold_1,
                ),
                const Spacer(),
                CustomOutlinedButton(
                  width: 118.h,
                  text: "lbl_return".tr(),
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineTL18Decoration,
                )
              ],
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

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
