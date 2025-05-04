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
      child: Builder(
        builder: (context) => DiscoverScreen(),
      ),
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
                      "Discover",
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
        text: "Back",
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
        "Explore insights and articles about mental health",
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
            "What are the benefits of mindfulness?",
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
                        text: "Summary: ",
                        style: CustomTextStyles.labelMediumRobotoOnPrimary_1,
                      ),
                      TextSpan(
                        text: "The American Psychological Association explains how mindfulness can improve mental health",
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
            "How sleep deprivation affects mental health",
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "Summary: Columbia University research on sleep and mental health",
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
                  text: "Coping with ",
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
                TextSpan(
                  text: "Stress vs Burnout",
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "Summary: This article explains the difference between stress and burnout",
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
                  text: "Preventing Burnout in the Workplace",
                  style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "Summary: Columbia University research on workplace burnout prevention",
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
            "Coping After Disaster",
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
          ),
          const SizedBox(height: 8),
          _buildRowArrowRight(
            context,
            description: "Summary: Provides guidance on coping with trauma after natural disasters",
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
                  text: "Summary: ",
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
