import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_my_account_model.dart';
import 'provider/profile_my_account_provider.dart';

class ProfileMyAccountScreen extends StatefulWidget {
  const ProfileMyAccountScreen({Key? key}) : super(key: key);

  @override
  ProfileMyAccountScreenState createState() => ProfileMyAccountScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileMyAccountProvider(),
      child: ProfileMyAccountScreen(),
    );
  }
}

class ProfileMyAccountScreenState extends State<ProfileMyAccountScreen> {
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
              padding: EdgeInsets.only(top: 26.h),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: _buildAppbar(context),
                  ),
                  SizedBox(height: 44.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 30.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.h,
                      vertical: 30.h,
                    ),
                    decoration: AppDecoration.windowsGlass.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup1,
                          height: 102.h,
                          width: 104.h,
                          radius: BorderRadius.circular(50.h),
                        ),
                        SizedBox(height: 12.h),
                        CustomOutlinedButton(
                          height: 30.h,
                          width: 126.h,
                          text: "lbl_edit".tr,
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles.outlineTL14Decoration,
                        ),
                        SizedBox(height: 36.h),
                        Container(
                          decoration: AppDecoration.outline7.copyWith(
                            borderRadius: BorderRadiusStyle.customBorderTL30,
                          ),
                          width: double.maxFinite,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.h,
                                  vertical: 16.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "lbl_name".tr,
                                      style: CustomTextStyles
                                          .titleMediumSemiBold_1,
                                    ),
                                    Spacer(),
                                    Text(
                                      "msg_vasilis_christou".tr,
                                      style: CustomTextStyles
                                          .titleSmallRobotoOnPrimarySemiBold,
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgArrowRight,
                                      height: 14.h,
                                      width: 14.h,
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.only(
                                        left: 4.h,
                                        right: 6.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: AppDecoration.outline7,
                          width: double.maxFinite,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.h,
                                  vertical: 16.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "lbl_pronouns".tr,
                                      style: CustomTextStyles
                                          .titleMediumSemiBold_1,
                                    ),
                                    Spacer(),
                                    Text(
                                      "lbl_he_him".tr,
                                      style: CustomTextStyles
                                          .titleSmallRobotoOnPrimarySemiBold,
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgArrowRight,
                                      height: 14.h,
                                      width: 14.h,
                                      margin: EdgeInsets.only(
                                        left: 4.h,
                                        right: 6.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: AppDecoration.outline7,
                          width: double.maxFinite,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.h,
                                  vertical: 14.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        "lbl_e_mail".tr,
                                        style: CustomTextStyles
                                            .titleMediumSemiBold_1,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "msg_vchristou_gmail_com".tr,
                                      style: CustomTextStyles
                                          .titleSmallRobotoOnPrimarySemiBold,
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgArrowRight,
                                      height: 14.h,
                                      width: 14.h,
                                      margin: EdgeInsets.only(
                                        left: 4.h,
                                        right: 6.h,
                                        bottom: 2.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: AppDecoration.outline7.copyWith(
                            borderRadius: BorderRadiusStyle.customBorderBL30,
                          ),
                          width: double.maxFinite,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.h,
                                  vertical: 14.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        "lbl_password".tr,
                                        style: CustomTextStyles
                                            .titleMediumSemiBold_1,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "lbl".tr,
                                      style:
                                          CustomTextStyles.titleSmallGray700_1,
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgArrowRight,
                                      height: 14.h,
                                      width: 12.h,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        left: 4.h,
                                        right: 6.h,
                                      ),
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
                  SizedBox(height: 148.h),
                  CustomOutlinedButton(
                    width: 190.h,
                    text: "lbl_sign_out".tr,
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL241Decoration,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
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

  /// Navigates to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
