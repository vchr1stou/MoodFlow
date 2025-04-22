import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/segmented_item_model.dart';
import '../models/statistics_mood_charts_model.dart';
import '../models/statisticsmood_tab_model.dart';

/// A provider class for the StatisticsMoodChartsScreen.
///
/// This provider manages the state of the StatisticsMoodChartsScreen,
/// including the current statisticsMoodChartsModelObj.
// ignore_for_file: must_be_immutable
class StatisticsMoodChartsProvider extends ChangeNotifier {
  StatisticsMoodChartsModel statisticsMoodChartsModelObj =
      StatisticsMoodChartsModel();

  StatisticsmoodTabModel statisticsmoodTabModelObj = StatisticsmoodTabModel();

  @override
  void dispose() {
    super.dispose();
  }

  void onSelectedChipView(int index, bool value) {
    statisticsmoodTabModelObj.segmentedItemList[index].isSelected = value;
    notifyListeners();
  }
}
