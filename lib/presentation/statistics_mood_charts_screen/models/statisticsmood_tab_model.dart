import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_export.dart';
import 'chart_one_chart_model.dart';
import 'segmented_item_model.dart';

/// This class is used in the [statisticsmood_tab_page] screen.
// ignore_for_file: must_be_immutable
class StatisticsmoodTabModel {
  List<SegmentedItemModel> segmentedItemList = [
    SegmentedItemModel(buttononeOne: "lbl_past_week".tr),
    SegmentedItemModel(buttononeOne: "lbl_past_month".tr),
    SegmentedItemModel(buttononeOne: "lbl_all_time".tr),
    SegmentedItemModel(buttononeOne: "lbl_custom".tr),
  ];

  List<ChartOneChartModel> chartOneChartModelObj = [
    ChartOneChartModel(
      x: 0,
      barRods: [
        BarChartRodData(toY: 1.23),
        BarChartRodData(toY: 2.45),
      ],
    ),
    ChartOneChartModel(
      x: 1,
      barRods: [
        BarChartRodData(toY: 1.12),
        BarChartRodData(toY: 2.34),
      ],
    ),
    ChartOneChartModel(
      x: 2,
      barRods: [
        BarChartRodData(toY: 2.13),
        BarChartRodData(toY: 3.25),
      ],
    ),
    ChartOneChartModel(
      x: 3,
      barRods: [
        BarChartRodData(toY: 1.47),
        BarChartRodData(toY: 2.89),
      ],
    ),
  ];
}
