import '../../../core/app_export.dart';
import 'little_lifts_item_model.dart';

/// This class is used in the [little_lifts_initial_page] screen.

// ignore_for_file: must_be_immutable
class LittleLiftsInitialModel {
  List<LittleLiftsItemModel> littleLiftsItemList = [
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgFigureStrength,
        workoutTwo: "lbl_workout".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBrainHeadProfileFill,
        workoutTwo: "lbl_meditation".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgWind1, workoutTwo: "lbl_breathing".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgPopcornFill1,
        workoutTwo: "lbl_movie_time".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBeatsHeadphones,
        workoutTwo: "lbl_music".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBookFill2,
        workoutTwo: "lbl_read_a_book".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgTextBubbleFill,
        workoutTwo: "lbl_affirmations".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgFryingPanFill,
        workoutTwo: "lbl_cooking".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgAirplane,
        workoutTwo: "lbl_travel_plans".tr),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgThumbsUpOnprimary,
        workoutTwo: "lbl_safety_net".tr),
    LittleLiftsItemModel(workoutOne: ImageConstant.imgHeartFill4),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBookmarkFill1, workoutTwo: "lbl_saved".tr)
  ];
}
