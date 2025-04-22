import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/profile_gentle_reminders_model.dart';
import 'provider/profile_gentle_reminders_provider.dart';

class ProfileGentleRemindersScreen extends StatefulWidget {
  const ProfileGentleRemindersScreen({Key? key}) : super(key: key);

  @override
  ProfileGentleRemindersScreenState createState() =>
      ProfileGentleRemindersScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileGentleRemindersProvider(),
      child: ProfileGentleRemindersScreen(),
    );
  }
}

class ProfileGentleRemindersScreenState
    extends State<ProfileGentleRemindersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  height: 770.h,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 26.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.h, vertical: 28.h),
                            decoration: AppDecoration.outline6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "msg_gentle_reminders".tr,
                                  style: theme.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 6.h),
                                _buildAlert(context),
                                SizedBox(height: 10.h),
                                _buildAlertone(context),
                                SizedBox(height: 122.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconButton(
                                height: 30.h,
                                width: 30.h,
                                padding: EdgeInsets.all(6.h),
                                decoration: IconButtonStyleHelper.none,
                                alignment: Alignment.centerLeft,
                                onTap: () {
                                  onTapBtnArrowleftone(context);
                                },
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgArrowLeft,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgGroup,
                                height: 62.h,
                                width: 54.h,
                              ),
                              Spacer(),
                              _buildAlerttwo(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnaddanew(context),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder24,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "msg_daily_check_in".tr,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Selector<ProfileGentleRemindersProvider, bool?>(
                        selector: (context, provider) =>
                            provider.isSelectedSwitch,
                        builder: (context, isSelectedSwitch, child) {
                          return CustomSwitch(
                            value: isSelectedSwitch,
                            onChange: (value) {
                              context
                                  .read<ProfileGentleRemindersProvider>()
                                  .changeSwitchBox(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Container(
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
                  decoration: AppDecoration.outline7.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder32,
                  ),
                  child: Column(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // your inner content here
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 14.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder24,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "msg_quote_of_the_day2".tr,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Selector<ProfileGentleRemindersProvider, bool?>(
                        selector: (context, provider) =>
                            provider.isSelectedSwitch1,
                        builder: (context, isSelectedSwitch1, child) {
                          return CustomSwitch(
                            value: isSelectedSwitch1,
                            onChange: (value) {
                              context
                                  .read<ProfileGentleRemindersProvider>()
                                  .changeSwitchBox1(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder28,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "lbl_9_30".tr,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Spacer(),
                      CustomImageView(
                        imagePath: ImageConstant.imgTrashFill1,
                        height: 24.h,
                        width: 20.h,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgPencil1,
                        height: 16.h,
                        width: 20.h,
                        margin: EdgeInsets.only(left: 6.h),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerttwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 14.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder28,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "lbl_streak_reminder".tr,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Selector<ProfileGentleRemindersProvider, bool?>(
                        selector: (context, provider) =>
                            provider.isSelectedSwitch2,
                        builder: (context, isSelectedSwitch2, child) {
                          return CustomSwitch(
                            alignment: Alignment.center,
                            value: isSelectedSwitch2,
                            onChange: (value) {
                              context
                                  .read<ProfileGentleRemindersProvider>()
                                  .changeSwitchBox2(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: AppDecoration.outline7.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder28,
            ),
            width: double.maxFinite,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "lbl_23_40".tr,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Spacer(),
                      CustomImageView(
                        imagePath: ImageConstant.imgTrashFill1,
                        height: 24.h,
                        width: 20.h,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgPencil1,
                        height: 16.h,
                        width: 20.h,
                        margin: EdgeInsets.only(left: 6.h),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnaddanew(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlinedButton(
            width: 182.h,
            text: "msg_add_a_new_reminder".tr,
            margin: EdgeInsets.only(bottom: 12.h),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.outlineTL241Decoration,
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapBtnArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
