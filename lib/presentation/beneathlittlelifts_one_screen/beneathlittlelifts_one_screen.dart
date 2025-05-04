import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
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
                      "msg_beneath_the_little".tr(),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgHouseFill1Pink100,
                            height: 14.h,
                            width: 18.h,
                            margin: EdgeInsets.only(left: 12.h),
                          ),
                          Container(
                            width: 40.h,
                            margin: EdgeInsets.only(left: 2.h),
                            child: Text(
                              "lbl_home".tr(),
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.labelLargePink100,
                            ),
                          ),
                          Spacer(),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.18,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.5.h,
                              ),
                              borderRadius: BorderRadiusStyle.circleBorder18,
                            ),
                            child: Container(
                              height: 36.h,
                              width: 120.h,
                              decoration: AppDecoration.outline1.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder18,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgImage3,
                                    height: 36.h,
                                    width: double.maxFinite,
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgBlurS36x118,
                                    height: 36.h,
                                    width: double.maxFinite,
                                  )
                                ],
                              ),
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgThumbsUpPink100,
                            height: 16.h,
                            width: 18.h,
                            margin: EdgeInsets.only(left: 20.h),
                          ),
                          Container(
                            width: 66.h,
                            margin: EdgeInsets.only(left: 2.h),
                            child: Text(
                              "lbl_little_lifts".tr(),
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.labelLargeOnPrimary13,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: Builder(
        builder: (context) => AppbarLeadingImage(
          imagePath: ImageConstant.imgChevron,
          margin: EdgeInsets.only(left: 8.h),
        ),
      ),
      title: Builder(
        builder: (context) => AppbarSubtitleOne(
          text: "lbl_beneath_little_lifts".tr(),
          margin: EdgeInsets.only(left: 10.h),
        ),
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
