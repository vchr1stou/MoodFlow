import '../../../core/app_export.dart';

/// This class is used in the [listworkout_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListworkoutOneItemModel {
  ListworkoutOneItemModel(
      {this.workoutOne, this.workoutTwo, this.description, this.id}) {
    workoutOne = workoutOne ?? ImageConstant.imgFigureStrength;
    workoutTwo = workoutTwo ?? "lbl_workout".tr;
    description = description ?? "msg_exercise_is_a_powerful".tr;
    id = id ?? "";
  }

  String? workoutOne;

  String? workoutTwo;

  String? description;

  String? id;
}
