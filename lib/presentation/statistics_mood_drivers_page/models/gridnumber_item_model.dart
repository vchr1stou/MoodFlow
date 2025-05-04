import '../../../core/app_export.dart';

/// This class is used in the [gridnumber_item_widget] screen.
// ignore_for_file: must_be_immutable
class GridnumberItemModel {
  GridnumberItemModel({
    this.number,
    this.image,
    this.exercise,
    this.id,
  }) {
    number = number ?? "lbl_20";
    image = image ?? ImageConstant.imgFigurerun1;
    exercise = exercise ?? "lbl_exercise";
    id = id ?? "";
  }

  String? number;
  String? image;
  String? exercise;
  String? id;
}
