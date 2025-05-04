import '../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';

/// This class is used in the [grid_item_widget] screen.

// ignore_for_file: must_be_immutable
class GridItemModel {
  GridItemModel({this.button, this.id}) {
    button = button ?? "lbl_calm".tr();
    id = id ?? "";
  }

  String? button;

  String? id;
}
