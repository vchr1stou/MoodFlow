import '../../../core/app_export.dart';
import 'little_lifts_item_model.dart';

/// This class is used in the [little_lifts_initial_page] screen.

// ignore_for_file: must_be_immutable
class LittleLiftsInitialModel {
  List<LittleLiftsItemModel> littleLiftsItemList = [
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgFigureStrength,
        workoutTwo: "Workout"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBrainHeadProfileFill,
        workoutTwo: "Meditation"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgWind1, workoutTwo: "Breathing"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgPopcornFill1,
        workoutTwo: "Movie Time"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBeatsHeadphones,
        workoutTwo: "Music"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBookFill2,
        workoutTwo: "Read a Book"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgTextBubbleFill,
        workoutTwo: "Affirmations"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgFryingPanFill,
        workoutTwo: "Cooking"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgAirplane,
        workoutTwo: "Travel Plans"),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgThumbsUpOnprimary,
        workoutTwo: "Safety Net"),
    LittleLiftsItemModel(workoutOne: ImageConstant.imgHeartFill4),
    LittleLiftsItemModel(
        workoutOne: ImageConstant.imgBookmarkFill1, workoutTwo: "Saved")
  ];
}
