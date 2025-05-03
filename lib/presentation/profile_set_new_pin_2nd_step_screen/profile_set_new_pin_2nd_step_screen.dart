import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_set_new_pin_2nd_step_model.dart';
import 'provider/profile_set_new_pin_2nd_step_provider.dart';

class ProfileSetNewPin2ndStepScreen extends StatefulWidget {
  const ProfileSetNewPin2ndStepScreen({Key? key}) : super(key: key);

  @override
  ProfileSetNewPin2ndStepScreenState createState() =>
      ProfileSetNewPin2ndStepScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSetNewPin2ndStepProvider(),
      child: const ProfileSetNewPin2ndStepScreen(),
    );
  }
}

class ProfileSetNewPin2ndStepScreenState
    extends State<ProfileSetNewPin2ndStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 26.h),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppbar(context),
                  SizedBox(height: 16.h),
                  _buildPinTitleSection(),
                  SizedBox(height: 6.h),
                  Text(
                    "msg_set_your_new_pin".tr,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 22.h),
                  _buildPinEntryPlaceholder(context),
                  SizedBox(height: 22.h),
                  CustomOutlinedButton(
                    width: 182.h,
                    text: "lbl_set_pin".tr,
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

  /// AppBar with back button
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => onTapArrowLeft(context),
      ),
    );
  }

  /// Visual PIN title and icons
  Widget _buildPinTitleSection() {
    return SizedBox(
      width: 110.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgVectorOnprimary72x60,
                  height: 72.h,
                  width: 62.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgVectorOnprimary50x26,
                  height: 50.h,
                  width: 28.h,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
          ),
          Text(
            "lbl_set_pin".tr,
            style: theme.textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }

  /// PIN entry area placeholder (can be replaced with actual PIN field)
  Widget _buildPinEntryPlaceholder(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Center(
          child: Text(
            "lbl4".tr,
            style: theme.textTheme.displayMedium,
          ),
        ),
      ),
    );
  }

  /// Navigate back
  void onTapArrowLeft(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
