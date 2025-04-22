import '../../../core/app_export.dart';

/// This class is used in the [segmented_item_widget] screen.
/// Represents an individual segment option (e.g., a button).
// ignore_for_file: must_be_immutable
class SegmentedItemModel {
  SegmentedItemModel({
    this.buttononeOne,
    this.isSelected,
  }) {
    buttononeOne = buttononeOne ?? "lbl_past_week".tr;
    isSelected = isSelected ?? false;
  }

  String? buttononeOne;
  bool? isSelected;
}
