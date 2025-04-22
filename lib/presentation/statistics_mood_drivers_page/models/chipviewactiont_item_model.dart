import '../../../core/app_export.dart';

/// This class is used in the [chipviewactiont_item_widget] screen.
// ignore_for_file: must_be_immutable
class ChipviewactiontItemModel {
  ChipviewactiontItemModel({
    this.actiontwoOne,
    this.isSelected,
  }) {
    actiontwoOne = actiontwoOne ?? "lbl_exercise".tr;
    isSelected = isSelected ?? false;
  }

  String? actiontwoOne;
  bool? isSelected;
}
