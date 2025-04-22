import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/chipviewactiont_item_model.dart';
import '../models/gridnumber_item_model.dart';
import '../models/statistics_mood_drivers_model.dart';

/// A provider class for the StatisticsMoodDriversPage.
///
/// This provider manages the state of the StatisticsMoodDriversPage,
/// including the current statisticsMoodDriversModelObj
// ignore_for_file: must_be_immutable
class StatisticsMoodDriversProvider extends ChangeNotifier {
  StatisticsMoodDriversModel statisticsMoodDriversModelObj =
      StatisticsMoodDriversModel();

  @override
  void dispose() {
    super.dispose();
  }

  void onSelectedChipView(
    int index,
    bool value,
  ) {
    statisticsMoodDriversModelObj.chipviewactiontItemList[index].isSelected =
        value;
    notifyListeners();
  }
}
