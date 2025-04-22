import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/emoji_log_five_model.dart';
import 'provider/emoji_log_five_provider.dart';

class EmojiLogFiveScreen extends StatefulWidget {
  const EmojiLogFiveScreen({Key? key}) : super(key: key);

  @override
  EmojiLogFiveScreenState createState() => EmojiLogFiveScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmojiLogFiveProvider(),
      child: const EmojiLogFiveScreen(),
    );
  }
}

class EmojiLogFiveScreenState extends State<EmojiLogFiveScreen> {
  @override
  void initState() {
    super.initState();
    // add any initialization logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.orange30001,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(12.h),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 26.h),
                    _buildTabIndicatorAndImageRow(context),
                    Container(
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "msg_this_spark_in_you".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.labelLarge13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(
            top: 13.h,
            right: 25.h,
            bottom: 13.h,
          ),
        ),
      ],
    );
  }

  Widget _buildTabIndicatorAndImageRow(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96.h,
            margin: EdgeInsets.only(top: 16.h),
            child: AnimatedSmoothIndicator(
              activeIndex: 0,
              count: 5,
              effect: ScrollingDotsEffect(
                activeDotColor: theme.colorScheme.onPrimary,
                dotColor: appTheme.black900.withAlpha(77), // alpha: 0.3
                dotHeight: 8.h,
                dotWidth: 8.h,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 114.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.img4,
                      height: 130.h,
                      width: 102.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 14.h),
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "lbl_bright".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.headlineSmall24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Center(
        child: CustomOutlinedButton(
          height: 36.h,
          width: 180.h,
          text: "lbl_this_matches_me".tr,
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.outlineTL18Decoration,
          buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
        ),
      ),
    );
  }
}
