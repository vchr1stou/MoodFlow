import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/little_lifts_initial_model.dart';
import 'models/little_lifts_item_model.dart';
import 'provider/little_lifts_provider.dart';
import 'widgets/little_lifts_item_widget.dart';

class LittleLiftsInitialPage extends StatefulWidget {
  const LittleLiftsInitialPage({Key? key})
      : super(
          key: key,
        );

  @override
  LittleLiftsInitialPageState createState() => LittleLiftsInitialPageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LittleLiftsProvider(),
      child: LittleLiftsInitialPage(),
    );
  }
}

class LittleLiftsInitialPageState extends State<LittleLiftsInitialPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.gradientAmberToRed,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 38.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: _buildAppbar(context),
                  ),
                  _buildRowalertone(context),
                  SizedBox(height: 30.h),
                  _buildLittlelifts(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 50.h,
      title: AppbarTitle(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 28.h),
      ),
      actions: [
        AppbarTrailingIconbuttonTwo(
          imagePath: ImageConstant.imgInfo1,
          margin: EdgeInsets.only(
            top: 6.h,
            right: 22.h,
            bottom: 13.h,
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildRowalertone(BuildContext context) {
    return Container(
      decoration: AppDecoration.outline9,
      width: double.maxFinite,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 6.h,
                  ),
                  decoration: AppDecoration.outline1.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder14,
                  ),
                  child: Text(
                    "msg_tiny_acts_of_care".tr,
                    textAlign: TextAlign.left,
                    style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 112.h,
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 4.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.h,
                                  vertical: 4.h,
                                ),
                                decoration: AppDecoration.outline1.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder14,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Text(
                                        "lbl_surprise_me".tr,
                                        style: CustomTextStyles
                                            .labelLargeRobotoOnPrimaryBold_1,
                                      ),
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgArrowDown,
                                      height: 12.h,
                                      width: 14.h,
                                      margin: EdgeInsets.only(bottom: 2.h),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgGroup28,
                        height: 40.h,
                        width: double.maxFinite,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLittlelifts(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Consumer<LittleLiftsProvider>(
          builder: (context, provider, child) {
            return ResponsiveGridListBuilder(
              minItemWidth: 1,
              minItemsPerRow: 3,
              maxItemsPerRow: 3,
              horizontalGridSpacing: 24.h,
              verticalGridSpacing: 24.h,
              builder: (context, items) => ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: items,
              ),
              gridItems: List.generate(
                provider.littleLiftsInitialModelObj.littleLiftsItemList.length,
                (index) {
                  LittleLiftsItemModel model = provider
                      .littleLiftsInitialModelObj.littleLiftsItemList[index];
                  return LittleLiftsItemWidget(
                    model: model,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
