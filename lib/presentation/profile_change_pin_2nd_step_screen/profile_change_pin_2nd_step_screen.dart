import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_change_pin_2nd_step_model.dart';
import 'provider/profile_change_pin_2nd_step_provider.dart';

class ProfileChangePin2ndStepScreen extends StatefulWidget {
  const ProfileChangePin2ndStepScreen({Key? key}) : super(key: key);

  @override
  ProfileChangePin2ndStepScreenState createState() =>
      ProfileChangePin2ndStepScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileChangePin2ndStepProvider(),
      child: ProfileChangePin2ndStepScreen(),
    );
  }
}

class ProfileChangePin2ndStepScreenState
    extends State<ProfileChangePin2ndStepScreen> {
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
                    width: 148.h,
                    child: Text(
                      "msg_now_set_a_new_pin".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _buildColumn(context),
                  SizedBox(height: 22.h),
                  CustomOutlinedButton(
                    width: 182.h,
                    text: "lbl_set_new_pin".tr,
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

  /// Custom AppBar widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => onTapArrowleftone(context),
      ),
    );
  }

  /// Glass-like column for input/display
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 30.h, right: 34.h),
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

  /// Back button handler
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
