import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/chipviewactiont_item_model.dart';
import 'models/gridnumber_item_model.dart';
import 'models/statistics_mood_drivers_model.dart';
import 'provider/statistics_mood_drivers_provider.dart';
import 'widgets/chipviewactiont_item_widget.dart';
import 'widgets/gridnumber_item_widget.dart';

class StatisticsMoodDriversPage extends StatefulWidget {
  const StatisticsMoodDriversPage({Key? key}) : super(key: key);

  @override
  StatisticsMoodDriversPageState createState() =>
      StatisticsMoodDriversPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodDriversProvider(),
      child: StatisticsMoodDriversPage(),
    );
  }
}

class StatisticsMoodDriversPageState extends State<StatisticsMoodDriversPage>
    with AutomaticKeepAliveClientMixin<StatisticsMoodDriversPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.maxFinite,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      spacing: 16,
                      children: [
                        _buildColumnPastWeek(context),
                        _buildAlert(context),
                        _buildAlertOne(context),
                        _buildAlertTwo(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnPastWeek(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 14,
        children: [
          Container(
            padding: EdgeInsets.all(4.h),
            decoration: AppDecoration.viewsRecessedMaterialView.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder24,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                CustomOutlinedButton(
                  height: 36.h,
                  width: 84.h,
                  text: "lbl_past_week".tr,
                  buttonStyle: CustomButtonStyles.none,
                  decoration: CustomButtonStyles.outlineTL18Decoration,
                  buttonTextStyle: CustomTextStyles.labelMediumSemiBold,
                ),
                Container(
                  width: 64.h,
                  margin: EdgeInsets.only(left: 16.h),
                  child: Text(
                    "lbl_past_month".tr,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelMediumGray700,
                  ),
                ),
                Spacer(flex: 43),
                SizedBox(
                  width: 42.h,
                  child: Text(
                    "lbl_all_time".tr,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelMediumGray700,
                  ),
                ),
                Spacer(flex: 56),
                Container(
                  width: 44.h,
                  margin: EdgeInsets.only(right: 20.h),
                  child: Text(
                    "lbl_custom".tr,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelMediumGray700,
                  ),
                )
              ],
            ),
          ),
          Text(
            "msg_understand_what_s".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
          ),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 4.h, right: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 6.h),
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "msg_top_activities_that".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Consumer<StatisticsMoodDriversProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 12.h,
                    spacing: 12.h,
                    children: List<Widget>.generate(
                      provider.statisticsMoodDriversModelObj
                          .chipviewactiontItemList.length,
                      (index) {
                        var model = provider.statisticsMoodDriversModelObj
                            .chipviewactiontItemList[index];
                        return ChipviewactiontItemWidget(model);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h)
        ],
      ),
    );
  }

  Widget _buildAlertOne(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 4.h, right: 2.h),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "msg_top_activities_that2".tr,
            style: CustomTextStyles.labelLargeRobotoOnPrimaryBold_1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.h),
                decoration: AppDecoration.controlsIdle.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgFigurerun1,
                      height: 18.h,
                      width: 14.h,
                    ),
                    Text(
                      "lbl_exercise".tr,
                      style: theme.textTheme.labelMedium,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 4.h),
                decoration: AppDecoration.controlsIdle.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgFiguredance1,
                      height: 14.h,
                      width: 8.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "lbl_party".tr,
                        style: theme.textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                decoration: AppDecoration.controlsIdle.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgAirplaneOnprimary10x16,
                      height: 10.h,
                      width: 16.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "lbl_travelling".tr,
                        style: theme.textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 2.h)
        ],
      ),
    );
  }

  Widget _buildAlertTwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 4.h, right: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 12.h),
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "lbl_often_together".tr,
            style: CustomTextStyles.titleMediumBold18,
          ),
          CustomElevatedButton(
            height: 28.h,
            width: 116.h,
            text: "lbl_bright".tr,
            leftIcon: Container(
              margin: EdgeInsets.only(right: 2.h),
              child: CustomImageView(
                imagePath: ImageConstant.img4,
                height: 24.h,
                width: 18.h,
                fit: BoxFit.contain,
              ),
            ),
            buttonStyle: CustomButtonStyles.fillPrimaryTL14,
            buttonTextStyle: CustomTextStyles.titleSmallRobotoOnPrimary_1,
          ),
          Consumer<StatisticsMoodDriversProvider>(
            builder: (context, provider, child) {
              return ResponsiveGridListBuilder(
                minItemWidth: 1,
                minItemsPerRow: 5,
                maxItemsPerRow: 5,
                horizontalGridSpacing: 16.h,
                verticalGridSpacing: 16.h,
                builder: (context, items) => ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  children: items,
                ),
                gridItems: List.generate(
                  provider
                      .statisticsMoodDriversModelObj.gridnumberItemList.length,
                  (index) {
                    var model = provider.statisticsMoodDriversModelObj
                        .gridnumberItemList[index];
                    return GridnumberItemWidget(model);
                  },
                ),
              );
            },
          ),
          SizedBox(height: 8.h)
        ],
      ),
    );
  }
}
