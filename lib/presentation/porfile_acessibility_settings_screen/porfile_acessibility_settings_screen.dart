import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/porfile_acessibility_settings_model.dart';
import 'provider/porfile_acessibility_settings_provider.dart';

class PorfileAcessibilitySettingsScreen extends StatefulWidget {
  const PorfileAcessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  PorfileAcessibilitySettingsScreenState createState() =>
      PorfileAcessibilitySettingsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PorfileAcessibilitySettingsProvider(),
      child: PorfileAcessibilitySettingsScreen(),
    );
  }
}

class PorfileAcessibilitySettingsScreenState
    extends State<PorfileAcessibilitySettingsScreen> {
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
                    onTap: () {
                      onTapBtnArrowleftone(context);
                    },
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowLeft,
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgSettingsOnprimary74x76,
                    height: 74.h,
                    width: 78.h,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "lbl_accessibility".tr,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 2.h),
                  _buildNotifications(context),
                  _buildStreak(context),
                  _buildPreferences(context),
                  SizedBox(height: 416.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNotifications(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 18.h,
      ),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 84.h,
            child: Text(
              "lbl_voice_over".tr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 18.h,
            width: 16.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildStreak(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.h,
            margin: EdgeInsets.only(left: 6.h),
            child: Text(
              "lbl_invert_colors".tr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imageNotFound,
            height: 22.h,
            width: 8.h,
          ),
          Selector<PorfileAcessibilitySettingsProvider, bool?>(
            selector: (context, provider) => provider.isSelectedSwitch,
            builder: (context, isSelectedSwitch, child) {
              return CustomSwitch(
                margin: EdgeInsets.only(
                  left: 18.h,
                  top: 8.h,
                ),
                alignment: Alignment.bottomCenter,
                value: isSelectedSwitch,
                onChange: (value) {
                  context
                      .read<PorfileAcessibilitySettingsProvider>()
                      .changeSwitchBox(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPreferences(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 14.h,
      ),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 88.h,
            margin: EdgeInsets.only(left: 8.h),
            child: Text(
              "lbl_larger_text".tr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Selector<PorfileAcessibilitySettingsProvider, bool?>(
            selector: (context, provider) => provider.isSelectedSwitch1,
            builder: (context, isSelectedSwitch1, child) {
              return CustomSwitch(
                value: isSelectedSwitch1,
                onChange: (value) {
                  context
                      .read<PorfileAcessibilitySettingsProvider>()
                      .changeSwitchBox1(value);
                },
              );
            },
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
