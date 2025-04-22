import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

import 'models/discover_model.dart';
import 'provider/discover_provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  DiscoverScreenState createState() => DiscoverScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscoverProvider(),
      child: const DiscoverScreen(),
    );
  }
}

class DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    // any initialization logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 28.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 14.h),
                    child: Text(
                      "lbl_discover".tr,
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildGlassList(context),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 28.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_back".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  Widget _buildGlassList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 6.h,
            ),
            decoration: AppDecoration.gradientBlackToGray,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAlert(context),
                const SizedBox(height: 16),
                _buildAlertOne(context),
                const SizedBox(height: 16),
                _buildAlertTwo(context),
                const SizedBox(height: 16),
                _buildAlertThree(context),
                const SizedBox(height: 16),
                _buildAlertFour(context),
                const SizedBox(height: 16),
                _buildAlertFive(context),
                SizedBox(height: 26.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder24,
      ),
      child: Text(
        "msg_explore_insights".tr,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: CustomTextStyles.labelMediumRobotoOnPrimary11_1,
      ),
    );
  }

  Widget _buildAlertOne(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_what_are_the_benefits".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280.h,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "lbl_summary".tr,
                        style: CustomTextStyles.labelMediumRobotoOnPrimary_1,
                      ),
                      TextSpan(
                        text: "msg_the_american_psychological".tr,
                        style:
                            CustomTextStyles.labelMediumRobotoOnPrimaryMedium,
                      ),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgArrowRight,
                height: 18.h,
                width: 16.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 18.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_how_sleep_deprivation".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "msg_summary_columbia".tr,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertThree(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "lbl_coping_with".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
                TextSpan(
                  text: "msg_stress_vs_burnout".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "msg_summary_this_article".tr,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertFour(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 16.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "msg_preventing_burnout".tr,
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "msg_summary_columbia".tr,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertFive(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_coping_after_disaster".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "msg_summary_provides".tr,
          ),
        ],
      ),
    );
  }

  Widget _buildRowArrowRight(
    BuildContext context, {
    required String description,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 286.h,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "lbl_summary".tr,
                  style: CustomTextStyles.labelMediumRobotoOnPrimary_1,
                ),
                TextSpan(
                  text: description,
                  style: CustomTextStyles.labelMediumRobotoOnPrimaryMedium,
                ),
              ],
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgArrowRight,
          height: 18.h,
          width: 16.h,
          margin: EdgeInsets.only(top: 6.h),
        ),
      ],
    );
  }
}
