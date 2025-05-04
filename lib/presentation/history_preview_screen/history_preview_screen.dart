import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/appbar_trailing_button_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/history_preview_item_model.dart';
import 'models/history_preview_model.dart';
import 'provider/history_preview_provider.dart';
import 'widgets/history_preview_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryPreviewScreen extends StatefulWidget {
  const HistoryPreviewScreen({Key? key}) : super(key: key);

  @override
  HistoryPreviewScreenState createState() => HistoryPreviewScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryPreviewProvider(),
      child: HistoryPreviewScreen(),
    );
  }
}

class HistoryPreviewScreenState extends State<HistoryPreviewScreen> {
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
            margin: EdgeInsets.only(top: 56.h),
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 26.h),
                child: Column(
                  children: [
                    Container(
                      height: 720.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(right: 4.h),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 678.h,
                            width: 344.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.5, 0),
                                end: Alignment(0.5, 0.53),
                                colors: [
                                  appTheme.black900.withValues(alpha: 0.1),
                                  appTheme.gray70019,
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(left: 4.h),
                            padding: EdgeInsets.only(
                              left: 16.h,
                              top: 16.h,
                              right: 16.h,
                            ),
                            decoration: AppDecoration.windowsGlass.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(height: 4.h),
                                Container(
                                  width: double.maxFinite,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.h),
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration:
                                      AppDecoration.controlsIdle.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder36,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              "msg_today_mar_30_17_00".tr().toUpperCase(),
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
                                SizedBox(height: 10.h),
                                _buildHistorypreview(context),
                                SizedBox(height: 12.h),
                                CustomOutlinedButton(
                                  height: 30.h,
                                  text: "msg_party_in_the_u_s_a".tr(),
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 4.h),
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.imgSettingsOnprimary,
                                      height: 16.h,
                                      width: 16.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  buttonStyle: CustomButtonStyles.none,
                                  decoration:
                                      CustomButtonStyles.outlineTL141Decoration,
                                  buttonTextStyle:
                                      CustomTextStyles.labelMediumSemiBold_1,
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration:
                                      AppDecoration.windowsGlass.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder28,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 6.h),
                                      Text(
                                        "msg_playful_100".tr(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.labelLarge!
                                            .copyWith(height: 1.67),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  decoration:
                                      AppDecoration.windowsGlass.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder28,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 6.h),
                                      Text(
                                        "msg_lonely_100".tr(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.labelLarge!
                                            .copyWith(height: 1.67),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(6.h),
                                  decoration:
                                      AppDecoration.windowsGlass.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder32,
                                  ),
                                  child: Column(
                                    spacing: 6,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 4.h),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.h,
                                          vertical: 2.h,
                                        ),
                                        decoration:
                                            AppDecoration.controlsIdle.copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.circleBorder8,
                                        ),
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "msg_your_inner_monologue".tr(),
                                              style: CustomTextStyles
                                                  .labelMediumOnPrimarySemiBold,
                                            ),
                                            Spacer(),
                                            Text(
                                              "lbl_show_more".tr(),
                                              style: CustomTextStyles
                                                  .labelMediumOnPrimarySemiBold,
                                            ),
                                            CustomImageView(
                                              imagePath:
                                                  ImageConstant.imgArrowRight,
                                              height: 8.h,
                                              width: 8.h,
                                              margin: EdgeInsets.only(
                                                left: 2.h,
                                                right: 4.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "msg_lorem_ipsum_dolor2".tr(),
                                        maxLines: 12,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles
                                            .labelLargeGray10001
                                            .copyWith(height: 1.67),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 34.h),
                  ],
                ),
              ),
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
        text: "lbl_history".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
      actions: [
        AppbarTrailingButtonOne(
          margin: EdgeInsets.only(
            top: 14.h,
            right: 17.h,
            bottom: 15.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildHistorypreview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.h),
      child: Consumer<HistoryPreviewProvider>(
        builder: (context, provider, child) {
          return ResponsiveGridListBuilder(
            minItemWidth: 1,
            minItemsPerRow: 5,
            maxItemsPerRow: 5,
            horizontalGridSpacing: 14.h,
            verticalGridSpacing: 14.h,
            builder: (context, items) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: items,
            ),
            gridItems: List.generate(
              provider.historyPreviewModelObj.historyPreviewItemList.length,
              (index) {
                HistoryPreviewItemModel model = provider
                    .historyPreviewModelObj.historyPreviewItemList[index];
                return HistoryPreviewItemWidget(
                  model,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
