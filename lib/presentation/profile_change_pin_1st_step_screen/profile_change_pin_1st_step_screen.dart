import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_change_pin_1st_step_model.dart';
import 'provider/profile_change_pin_1st_step_provider.dart';

class ProfileChangePin1stStepScreen extends StatefulWidget {
  const ProfileChangePin1stStepScreen({Key? key}) : super(key: key);

  @override
  ProfileChangePin1stStepScreenState createState() =>
      ProfileChangePin1stStepScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileChangePin1stStepProvider(),
      child: ProfileChangePin1stStepScreen(),
    );
  }
}

class ProfileChangePin1stStepScreenState
    extends State<ProfileChangePin1stStepScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 20.h),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppbar(context),
                  SizedBox(height: 6.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgGroupOnprimary108x98,
                    height: 108.h,
                    width: 88.h,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "lbl_change_pin".tr,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: 292.h,
                    child: Text(
                      "msg_you_have_to_confirm".tr,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _buildAlert(context),
                  SizedBox(height: 22.h),
                  CustomOutlinedButton(
                    width: 182.h,
                    text: "msg_confirm_previous".tr,
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL241Decoration,
                  ),
                  SizedBox(height: 386.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget: Custom AppBar
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Section Widget: Alert UI
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 32.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 6.h),
          Text(
            "lbl4".tr,
            style: theme.textTheme.displayMedium,
          ),
        ],
      ),
    );
  }

  /// Back navigation
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
