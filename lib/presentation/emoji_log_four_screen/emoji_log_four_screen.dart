import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';

import 'models/emoji_log_four_model.dart';
import 'provider/emoji_log_four_provider.dart';

class EmojiLogFourScreen extends StatefulWidget {
  const EmojiLogFourScreen({Key? key}) : super(key: key);

  @override
  EmojiLogFourScreenState createState() => EmojiLogFourScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmojiLogFourProvider(),
      child: const EmojiLogFourScreen(),
    );
  }
}

class EmojiLogFourScreenState extends State<EmojiLogFourScreen> {
  @override
  void initState() {
    super.initState();
    // initialization logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.orange300,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 6.h),
                    _buildTabIndicatorAndImageRow(context),
                    Container(
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "msg_this_ease_you".tr,
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
                dotColor: appTheme.black900.withAlpha(77), // ~30% opacity
                dotHeight: 8.h,
                dotWidth: 8.h,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 114.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.img3,
                      height: 130.h,
                      width: 102.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.h),
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "lbl_light".tr,
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
