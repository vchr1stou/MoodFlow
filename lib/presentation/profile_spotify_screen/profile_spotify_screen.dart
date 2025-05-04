import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_spotify_model.dart';
import 'provider/profile_spotify_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileSpotifyScreen extends StatefulWidget {
  const ProfileSpotifyScreen({Key? key}) : super(key: key);

  @override
  ProfileSpotifyScreenState createState() => ProfileSpotifyScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSpotifyProvider(),
      child: const ProfileSpotifyScreen(),
    );
  }
}

class ProfileSpotifyScreenState extends State<ProfileSpotifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 80.h),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(40.h),
                  decoration: AppDecoration.outline6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSpotifyHeader(context),
                      SizedBox(height: 8.h),
                      _buildSignedInInfo(context),
                      SizedBox(height: 20.h),
                      CustomOutlinedButton(
                        width: 190.h,
                        text: "lbl_sign_out".tr(),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles.outlineTL241Decoration,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
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
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h, top: 13.h, bottom: 13.h),
        onTap: () => onTapArrowLeft(context),
      ),
    );
  }

  /// Spotify icon and title section
  Widget _buildSpotifyHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.h),
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgVectorOnprimary,
            height: 110.h,
            width: 110.h,
          ),
          SizedBox(height: 10.h),
          Text(
            "lbl_spotify_account".tr(),
            style: CustomTextStyles.headlineLarge30,
          ),
        ],
      ),
    );
  }

  /// Display user info under Spotify account
  Widget _buildSignedInInfo(BuildContext context) {
    return Container(
      decoration: AppDecoration.outline8.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder28,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "lbl_signed_in_as".tr(),
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(width: 4.h),
                Text(
                  "msg_vchristou32_gmail_com".tr(),
                  style: CustomTextStyles.labelLargeBold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles back navigation
  void onTapArrowLeft(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
