import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_delete_pin_model.dart';
import 'provider/profile_delete_pin_provider.dart';

class ProfileDeletePinScreen extends StatefulWidget {
  const ProfileDeletePinScreen({Key? key}) : super(key: key);

  @override
  ProfileDeletePinScreenState createState() => ProfileDeletePinScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileDeletePinProvider(),
      child: ProfileDeletePinScreen(),
    );
  }
}

class ProfileDeletePinScreenState extends State<ProfileDeletePinScreen> {
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
              padding: EdgeInsets.only(
                left: 16.h,
                top: 26.h,
                right: 16.h,
              ),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconButton(
                    height: 30.h,
                    width: 30.h,
                    padding: EdgeInsets.all(6.h),
                    decoration: IconButtonStyleHelper.none,
                    alignment: Alignment.centerLeft,
                    onTap: () => onTapBtnArrowleftone(context),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowLeft,
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgGroupOnprimary108x98,
                    height: 108.h,
                    width: 88.h,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "lbl_delete_pin".tr,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(
                    width: 224.h,
                    child: Text(
                      "msg_you_have_to_confirm2".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _buildAlert(context),
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

  /// Alert-style glass panel section
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
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

  /// Handles back navigation
  void onTapBtnArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
