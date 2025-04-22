import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/emoji_log_three_model.dart';
import 'provider/emoji_log_three_provider.dart';

class EmojiLogThreeScreen extends StatefulWidget {
  const EmojiLogThreeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  EmojiLogThreeScreenState createState() => EmojiLogThreeScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmojiLogThreeProvider(),
      child: const EmojiLogThreeScreen(),
    );
  }
}

class EmojiLogThreeScreenState extends State<EmojiLogThreeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.pink800,
      appBar: _buildAppbar(context),
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
                    _buildRowtabbarone(context),
                    Container(
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "msg_low_doesn_t_mean".tr,
                        textAlign: TextAlign.center,
                        style: CustomTextStyles.labelLarge13,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildColumnthis(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(
            top: 13.h,
            right: 25.h,
            bottom: 13.h,
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildRowtabbarone(BuildContext context) {
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
                activeDotColor: theme.colorScheme.onPrimaryContainer,
                dotColor: appTheme.black900.withOpacity(0.3),
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
                padding: EdgeInsets.only(left: 112.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.img1,
                      height: 130.h,
                      width: 102.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 26.h),
                      decoration: AppDecoration.textPrimary,
                      child: Text(
                        "lbl_low".tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnthis(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlinedButton(
            width: 180.h,
            text: "lbl_this_matches_me".tr,
            margin: EdgeInsets.only(bottom: 12.h),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.outlineTL18Decoration,
          )
        ],
      ),
    );
  }
}
