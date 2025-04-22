import '../../../core/app_export.dart';

/// This class is used in the [grid_item_widget] screen.

// ignore_for_file: must_be_immutable
class GridItemModel {
  GridItemModel({this.button, this.id}) {
    button = button ?? "lbl_angry".tr;
    id = id ?? "";
  }

  String? button;

  String? id;
}
