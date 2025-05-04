import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/inhale_model.dart';
import 'provider/inhale_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class InhaleScreen extends StatefulWidget {
  const InhaleScreen({Key? key})
      : super(
          key: key,
        );

  @override
  InhaleScreenState createState() => InhaleScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InhaleProvider(),
      child: InhaleScreen(),
    );
  }
}

class InhaleScreenState extends State<InhaleScreen> {
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
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            padding: EdgeInsets.only(top: 108.h),
            child: Column(
              spacing: 14,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgScreenshot20250329,
                  height: 276.h,
                  width: 258.h,
                ),
                Text(
                  "lbl_now_inhale".tr(),
                  style: CustomTextStyles.displayMediumSemiBold,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_saved".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }
}
