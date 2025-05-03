import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/log_screen_step_four_model.dart';
import 'provider/log_screen_step_four_provider.dart';

class LogScreenStepFourScreen extends StatefulWidget {
  const LogScreenStepFourScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStepFourScreenState createState() => LogScreenStepFourScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStepFourProvider(),
      child: LogScreenStepFourScreen(),
    );
  }
}

class LogScreenStepFourScreenState extends State<LogScreenStepFourScreen> {
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
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4,
                    sigmaY: 4,
                  ),
                  child: Container(
                    height: 830.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    decoration: AppDecoration.gradientAmberToRed4001,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 4,
                              sigmaY: 4,
                            ),
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.h,
                                vertical: 36.h,
                              ),
                              decoration: AppDecoration.gradientBlackToGray,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 96.h),
                                  Text(
                                    "lbl_add_photo".tr,
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "msg_save_the_scene_that".tr,
                                    style:
                                        CustomTextStyles.labelMediumOnPrimary,
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildAlert(context),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "msg_add_music_track".tr,
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "msg_every_feeling_has2".tr,
                                    style:
                                        CustomTextStyles.labelMediumOnPrimary,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.fromLTRB(6.h, 26.h, 6.h, 46.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: _buildAppbar(context),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "lbl_add_to_journal".tr,
                                style: theme.textTheme.headlineSmall,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "msg_spill_the_tea_it_s".tr,
                                style: CustomTextStyles.labelMediumOnPrimary,
                              ),
                              SizedBox(height: 16.h),
                              _buildColumncloseone(context),
                              Spacer(),
                              _buildAlertone(context),
                              SizedBox(height: 26.h),
                              CustomOutlinedButton(
                                height: 36.h,
                                width: 118.h,
                                text: "lbl_save".tr,
                                buttonStyle: CustomButtonStyles.none,
                                decoration:
                                    CustomButtonStyles.outlineTL18Decoration,
                                buttonTextStyle:
                                    CustomTextStyles.titleSmallSemiBold,
                                alignment: Alignment.centerRight,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPhotoOnRectan,
            height: 30.h,
            width: 38.h,
          ),
          Text(
            "lbl_add_photo2".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 6.h)
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 30.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
      title: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          left: 21.h,
          right: 49.h,
        ),
        child: SliderTheme(
          data: SliderThemeData(
            trackShape: RoundedRectSliderTrackShape(),
            activeTrackColor: theme.colorScheme.onPrimary.withValues(
              alpha: 0.6,
            ),
            inactiveTrackColor: appTheme.blueGray1007f,
            thumbShape: RoundSliderThumbShape(),
          ),
          child: Slider(
            value: 76.39,
            min: 0.0,
            max: 100.0,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildColumncloseone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.h),
      padding: EdgeInsets.symmetric(vertical: 60.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 36.h,
            width: 38.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.fillPrimaryTL18,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
          Text(
            "msg_press_to_start_writing".tr,
            style: CustomTextStyles.labelMediumOnPrimary_1,
          ),
          SizedBox(height: 6.h)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSettingsOnprimary,
            height: 28.h,
            width: 30.h,
          ),
          Text(
            "lbl_add_music".tr,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
