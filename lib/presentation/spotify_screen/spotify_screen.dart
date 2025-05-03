import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/spotify_model.dart';
import 'provider/spotify_provider.dart';

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({Key? key})
      : super(
          key: key,
        );

  @override
  SpotifyScreenState createState() => SpotifyScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpotifyProvider(),
      child: SpotifyScreen(),
    );
  }
}

class SpotifyScreenState extends State<SpotifyScreen> {
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
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 24.h),
                child: Column(
                  spacing: 40,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4,
                            sigmaY: 4,
                          ),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                              horizontal: 26.h,
                              vertical: 70.h,
                            ),
                            decoration: AppDecoration.outline,
                            child: Consumer<SpotifyProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }

                                if (provider.isAuthenticated) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgVectorOnprimarycontainer,
                                        height: 176.h,
                                        width: 178.h,
                                      ),
                                      SizedBox(height: 30.h),
                                      Text(
                                        "Connected to Spotify",
                                        style: CustomTextStyles.headlineLarge30,
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        "Signed in as ${provider.userProfile?['display_name'] ?? 'User'}",
                                        style: CustomTextStyles.titleLargeRobotoOnPrimaryContainer_1,
                                      ),
                                      SizedBox(height: 46.h),
                                      CustomOutlinedButton(
                                        height: 54.h,
                                        text: "Disconnect Spotify",
                                        margin: EdgeInsets.only(
                                          left: 14.h,
                                          right: 18.h,
                                        ),
                                        buttonStyle: CustomButtonStyles.none,
                                        decoration: CustomButtonStyles.outlineTL26Decoration,
                                        buttonTextStyle: theme.textTheme.titleSmall!,
                                        hasBlurBackground: true,
                                        onTap: () {
                                          provider.logout();
                                        },
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgVectorOnprimarycontainer,
                                      height: 176.h,
                                      width: 178.h,
                                    ),
                                    SizedBox(height: 30.h),
                                    Text(
                                      "msg_connect_your_soundtrack".tr,
                                      style: CustomTextStyles.headlineLarge30,
                                    ),
                                    Text(
                                      "msg_every_feeling_has".tr,
                                      style: CustomTextStyles.titleLargeRobotoOnPrimaryContainer_1,
                                    ),
                                    SizedBox(height: 6.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 12.h,
                                        right: 14.h,
                                      ),
                                      child: Text(
                                        "msg_by_connecting_to".tr,
                                        style: CustomTextStyles.labelMediumRobotoOnPrimaryContainer_2,
                                      ),
                                    ),
                                    SizedBox(height: 46.h),
                                    CustomOutlinedButton(
                                      height: 54.h,
                                      text: "msg_link_spotify_account".tr,
                                      margin: EdgeInsets.only(
                                        left: 14.h,
                                        right: 18.h,
                                      ),
                                      buttonStyle: CustomButtonStyles.none,
                                      decoration: CustomButtonStyles.outlineTL26Decoration,
                                      buttonTextStyle: theme.textTheme.titleSmall!,
                                      hasBlurBackground: true,
                                      onTap: () {
                                        provider.loginWithSpotify();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomOutlinedButton(
                      height: 48.h,
                      width: 108.h,
                      text: "lbl_next".tr,
                      margin: EdgeInsets.only(right: 20.h),
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineDecoration,
                      buttonTextStyle: CustomTextStyles.labelLargeRobotoOnPrimaryContainerBold13_1,
                    ),
                    SizedBox(height: 32.h)
                  ],
                ),
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
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
