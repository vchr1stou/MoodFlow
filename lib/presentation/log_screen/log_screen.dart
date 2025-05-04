import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/log_model.dart';
import 'models/log_screen_one_item_model.dart';
import 'provider/log_provider.dart';
import 'widgets/log_screen_one_item_widget.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  LogScreenState createState() => LogScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogProvider(),
      child: const LogScreen(),
    );
  }
}

class LogScreenState extends State<LogScreen> {
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
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    height: 830.h,
                    padding: EdgeInsets.symmetric(vertical: 26.h),
                    decoration: AppDecoration.gradientAmberToRed4001,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.h,
                                  vertical: 12.h,
                                ),
                                decoration: AppDecoration.gradientBlackToGray,
                                child: Column(
                                  spacing: 12,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 6.h),
                                    _buildAlert(context),
                                    Text(
                                      "msg_who_were_you_with".tr(),
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    _buildAlertone(context),
                                    Text(
                                      "lbl_where_were_you".tr(),
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    _buildAlerttwo(context),
                                    CustomOutlinedButton(
                                      height: 36.h,
                                      width: 118.h,
                                      text: "lbl_next".tr(),
                                      buttonStyle: CustomButtonStyles.none,
                                      decoration: CustomButtonStyles
                                          .outlineTL18Decoration,
                                      buttonTextStyle:
                                          CustomTextStyles.titleSmallSemiBold,
                                      alignment: Alignment.centerRight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 320.h,
                            margin: EdgeInsets.only(left: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildAppbar(context),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "lbl_mood_captured".tr(),
                                  style: CustomTextStyles
                                      .displaySmallSFProOnPrimary,
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 268.h,
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration:
                                      AppDecoration.controlsIdle.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder36,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "lbl_bright".tr(),
                                            style: CustomTextStyles
                                                .headlineLargeSFProOnPrimary,
                                          ),
                                          CustomImageView(
                                            imagePath: ImageConstant.img42x30,
                                            height: 42.h,
                                            width: 30.h,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "msg_today_mar_28_17_26"
                                                  .tr()
                                                  .toUpperCase(),
                                              style: CustomTextStyles
                                                  .labelLargeOnPrimary13_2,
                                            ),
                                          ),
                                          CustomImageView(
                                            imagePath:
                                                ImageConstant.imgArrowRight,
                                            height: 8.h,
                                            width: 5.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 40.h),
                                  child: Text(
                                    "msg_what_s_happening".tr(),
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 22.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<LogProvider>(
            builder: (context, provider, child) {
              return ResponsiveGridListBuilder(
                minItemWidth: 1,
                minItemsPerRow: 4,
                maxItemsPerRow: 4,
                horizontalGridSpacing: 32.h,
                verticalGridSpacing: 32.h,
                builder: (context, items) => ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: items,
                ),
                gridItems: List.generate(
                    provider.logModelObj.logScreenOneItemList.length, (index) {
                  final model =
                      provider.logModelObj.logScreenOneItemList[index];
                  return LogScreenOneItemWidget(model);
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            height: 32.h,
            width: 32.h,
            padding: EdgeInsets.all(8.h),
            decoration: IconButtonStyleHelper.none,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
          Text(
            "lbl_add_people".tr(),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAlerttwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            height: 32.h,
            width: 32.h,
            padding: EdgeInsets.all(8.h),
            decoration: IconButtonStyleHelper.none,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
          Text(
            "lbl_add_location".tr(),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 30.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        onTap: () => NavigatorService.goBackWithoutContext(),
      ),
      title: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 21.h),
        child: Container(
          height: 12.h,
          width: 268.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withValues(alpha: 0.1),
              ),
              BoxShadow(
                color: appTheme.blueGray1007f,
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(1, 1.5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.h),
            child: const LinearProgressIndicator(value: 0.19),
          ),
        ),
      ),
      styleType: Style.bgShadowBlack900,
    );
  }
}
