import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/beneathlittlelifts_one_model.dart';
import 'models/listworkout_one_item_model.dart';
import 'provider/beneathlittlelifts_one_provider.dart';
import 'widgets/listworkout_one_item_widget.dart';

class BeneathlittleliftsOneScreen extends StatefulWidget {
  const BeneathlittleliftsOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  BeneathlittleliftsOneScreenState createState() =>
      BeneathlittleliftsOneScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeneathlittleliftsOneProvider(),
      child: BeneathlittleliftsOneScreen(),
    );
  }
}

class BeneathlittleliftsOneScreenState
    extends State<BeneathlittleliftsOneScreen> {
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
            margin: EdgeInsets.only(top: 34.h),
            padding: EdgeInsets.symmetric(horizontal: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 62.h),
                Text(
                  "msg_beneath_the_little".tr,
                  style: theme.textTheme.displaySmall,
                ),
                SizedBox(height: 2.h),
                Container(
                  margin: EdgeInsets.only(left: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 6.h,
                  ),
                  decoration: AppDecoration.outline1.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder14,
                  ),
                  child: Text(
                    "msg_what_the_research".tr,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildListworkoutone(context)
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
      height: 34.h,
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

  /// Section Widget
  Widget _buildListworkoutone(BuildContext context) {
    return Expanded(
      child: Consumer<BeneathlittleliftsOneProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 6.h,
              );
            },
            itemCount: provider
                .beneathlittleliftsOneModelObj.listworkoutOneItemList.length,
            itemBuilder: (context, index) {
              ListworkoutOneItemModel model = provider
                  .beneathlittleliftsOneModelObj.listworkoutOneItemList[index];
              return ListworkoutOneItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }
}
