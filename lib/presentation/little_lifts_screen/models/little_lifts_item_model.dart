import '../../../core/app_export.dart';

/// This class is used in the [little_lifts_item_widget] screen.

// ignore_for_file: must_be_immutable
class LittleLiftsItemModel {
  LittleLiftsItemModel({this.workoutOne, this.workoutTwo, this.id}) {
    workoutOne = workoutOne ?? ImageConstant.imgFigureStrength;
    workoutTwo = workoutTwo ?? "lbl_workout".tr;
    id = id ?? "";
  }

  String? workoutOne;

  String? workoutTwo;

  String? id;
}
