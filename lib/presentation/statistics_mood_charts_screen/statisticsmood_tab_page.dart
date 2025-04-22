import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import './models/chart_one_chart_model.dart';
import 'models/segmented_item_model.dart';
import 'models/statisticsmood_tab_model.dart';
import 'provider/statistics_mood_charts_provider.dart';
import 'widgets/segmented_item_widget.dart';

class StatisticsmoodTabPage extends StatefulWidget {
  const StatisticsmoodTabPage({Key? key}) : super(key: key);

  @override
  StatisticsmoodTabPageState createState() => StatisticsmoodTabPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodChartsProvider(),
      child: StatisticsmoodTabPage(),
    );
  }
}

class StatisticsmoodTabPageState extends State<StatisticsmoodTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    _buildSegmented(context),
                    SizedBox(height: 18.h),
                    Container(
                      height: 206.h,
                      width: 206.h,
                      margin: EdgeInsets.only(left: 74.h, right: 78.h),
                      child: Consumer<StatisticsMoodChartsProvider>(
                        builder: (context, provider, child) {
                          return BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.5,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.7,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.3,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.9,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.6,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.8,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 0.4,
                                      color: appTheme.pink100,
                                      width: 4.h,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30.h,
                                    getTitlesWidget: (value, meta) {
                                      String title = '';
                                      switch (value.toInt()) {
                                        case 0:
                                          title = 'M';
                                          break;
                                        case 1:
                                          title = 'T';
                                          break;
                                        case 2:
                                          title = 'W';
                                          break;
                                        case 3:
                                          title = 'T';
                                          break;
                                        case 4:
                                          title = 'F';
                                          break;
                                        case 5:
                                          title = 'S';
                                          break;
                                        case 6:
                                          title = 'S';
                                          break;
                                      }
                                      return Text(title);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _buildAlertone(context),
                    SizedBox(height: 10.h),
                    CustomOutlinedButton(
                      height: 36.h,
                      width: 140.h,
                      text: "lbl_export_charts".tr,
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineTL18Decoration,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSegmented(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer<StatisticsMoodChartsProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 15.5.h,
              spacing: 15.5.h,
              children: List<Widget>.generate(
                provider.statisticsmoodTabModelObj.segmentedItemList.length,
                (index) {
                  SegmentedItemModel model = provider
                      .statisticsmoodTabModelObj.segmentedItemList[index];
                  return SegmentedItemWidget(model);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 18.h),
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var img in [
            ImageConstant.img4,
            ImageConstant.img3,
            ImageConstant.img2,
            ImageConstant.img1,
            ImageConstant.img130x100
          ]) ...[
            SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  CustomImageView(imagePath: img, height: 30.h, width: 22.h),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var day in [
                  "lbl_mon",
                  "lbl_tue2",
                  "lbl_wed2",
                  "lbl_thu2",
                  "lbl_fri2",
                  "lbl_sat2",
                  "lbl_sun2"
                ]) ...[
                  if (day != "lbl_mon") SizedBox(width: 14.h),
                  Text(day.tr.toUpperCase(),
                      style: CustomTextStyles.bodySmallOnPrimary),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
