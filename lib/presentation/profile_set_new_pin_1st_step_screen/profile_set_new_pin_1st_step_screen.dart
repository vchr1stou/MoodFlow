import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_set_new_pin_1st_step_model.dart';
import 'provider/profile_set_new_pin_1st_step_provider.dart';

class ProfileSetNewPin1stStepScreen extends StatefulWidget {
  const ProfileSetNewPin1stStepScreen({Key? key}) : super(key: key);

  @override
  ProfileSetNewPin1stStepScreenState createState() =>
      ProfileSetNewPin1stStepScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSetNewPin1stStepProvider(),
      child: ProfileSetNewPin1stStepScreen(),
    );
  }
}

class ProfileSetNewPin1stStepScreenState
    extends State<ProfileSetNewPin1stStepScreen> {
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
              padding: EdgeInsets.only(top: 26.h),
              decoration: AppDecoration.forBackgroundpinkyellowbggradient
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppbar(context),
                  SizedBox(height: 16.h),
                  _buildIconAndTitle(context),
                  SizedBox(height: 6.h),
                  SizedBox(
                    width: 294.h,
                    child: Text(
                      "msg_now_you_have_to".tr,
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
                    text: "lbl_confirm_pin".tr,
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

  /// AppBar with back navigation
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
    );
  }

  /// Custom visual section with PIN icon and title
  Widget _buildIconAndTitle(BuildContext context) {
    return SizedBox(
      width: 110.h,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.h),
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

  /// Placeholder for the PIN entry widget or layout
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
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
}
