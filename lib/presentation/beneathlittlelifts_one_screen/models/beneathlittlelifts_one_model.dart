import '../../../core/app_export.dart';
import 'listworkout_one_item_model.dart';

// ignore_for_file: must_be_immutable
class BeneathlittleliftsOneModel {
  List<ListworkoutOneItemModel> listworkoutOneItemList = [
    ListworkoutOneItemModel(
      workoutOne: ImageConstant.imgFigureStrength,
      workoutTwo: "lbl_workout".tr,
      description: "msg_exercise_is_a_powerful".tr,
    ),
    ListworkoutOneItemModel(
      workoutOne: ImageConstant.imgBrainHeadProfileFill,
      workoutTwo: "lbl_mindfulness".tr,
      description: "msg_meditation_supports".tr,
    ),
    ListworkoutOneItemModel(
      workoutOne: ImageConstant.imgWind1,
      workoutTwo: "lbl_breathing".tr,
      description: "msg_deep_mindful_breathing".tr,
    ),
    ListworkoutOneItemModel(),
  ];
}
