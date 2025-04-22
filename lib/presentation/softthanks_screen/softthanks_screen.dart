import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import 'models/softthanks_model.dart';
import 'models/softthanks_one_item_model.dart';
import 'provider/softthanks_provider.dart';
import 'widgets/softthanks_one_item_widget.dart';

class SoftthanksScreen extends StatefulWidget {
  const SoftthanksScreen({Key? key}) : super(key: key);

  @override
  SoftthanksScreenState createState() => SoftthanksScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SoftthanksProvider(),
      child: SoftthanksScreen(),
    );
  }
}

class SoftthanksScreenState extends State<SoftthanksScreen> {
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
            margin: EdgeInsets.only(top: 28.h),
            padding: EdgeInsets.only(left: 18.h, top: 60.h, right: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    "lbl_soft_thanks".tr,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  margin: EdgeInsets.only(left: 2.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
                  decoration: AppDecoration.outline1.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder14,
                  ),
                  child: Text(
                    "msg_whispers_of_appreciation".tr,
                    textAlign: TextAlign.left,
                    style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
                  ),
                ),
                SizedBox(height: 18.h),
                _buildAlerttwo(context),
                SizedBox(height: 12.h),
                _buildSoftthanksone(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 28.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  Widget _buildAlerttwo(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
            decoration: AppDecoration.windowsGlassBlur.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder32,
            ),
            child: Column(
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "msg_what_made_you".tr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.titleSmallRobotoOnPrimary_1
                      .copyWith(height: 1.60),
                ),
                CustomElevatedButton(
                  height: 42.h,
                  width: 154.h,
                  text: "msg_keep_this_moment".tr,
                  leftIcon: Container(
                    margin: EdgeInsets.only(right: 8.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgPluscirclefill1,
                      height: 14.h,
                      width: 14.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.none,
                  decoration:
                      CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
                  buttonTextStyle: CustomTextStyles.labelLargeRoboto_1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoftthanksone(BuildContext context) {
    return Expanded(
      child: Consumer<SoftthanksProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: provider.softthanksModelObj.softthanksOneItemList.length,
            itemBuilder: (context, index) {
              final model =
                  provider.softthanksModelObj.softthanksOneItemList[index];
              return SoftthanksOneItemWidget(model);
            },
          );
        },
      ),
    );
  }
}
