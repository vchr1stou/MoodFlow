import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_set_pin_first_time_model.dart';
import 'provider/profile_set_pin_first_time_provider.dart';

class ProfileSetPinFirstTimeScreen extends StatefulWidget {
  const ProfileSetPinFirstTimeScreen({Key? key}) : super(key: key);

  @override
  ProfileSetPinFirstTimeScreenState createState() =>
      ProfileSetPinFirstTimeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSetPinFirstTimeProvider(),
      child: const ProfileSetPinFirstTimeScreen(),
    );
  }
}

class ProfileSetPinFirstTimeScreenState
    extends State<ProfileSetPinFirstTimeScreen> {
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
                  SizedBox(height: 176.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgGroupOnprimary108x98,
                    height: 108.h,
                    width: 100.h,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "lbl_set_pin".tr,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "msg_create_a_pin_to".tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        CustomTextStyles.titleSmallRobotoOnPrimary_1.copyWith(
                      height: 1.47,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomOutlinedButton(
                    width: 182.h,
                    text: "lbl_set_a_new_pin".tr,
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL241Decoration,
                  ),
                  SizedBox(height: 274.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// App bar with back button
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

  /// Handles back navigation
  void onTapArrowLeft(BuildContext context) {
    NavigatorService.goBack();
  }
}
