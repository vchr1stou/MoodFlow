import '../../../core/app_export.dart';
import 'chipviewactiont_item_model.dart';
import 'gridnumber_item_model.dart';

// ignore_for_file: must_be_immutable
class StatisticsMoodDriversModel {
  List<ChipviewactiontItemModel> chipviewactiontItemList = [
    ChipviewactiontItemModel(actiontwoOne: "lbl_exercise".tr),
    ChipviewactiontItemModel(actiontwoOne: "lbl_party".tr),
    ChipviewactiontItemModel(actiontwoOne: "lbl_travelling".tr)
  ];

  List<GridnumberItemModel> gridnumberItemList = [
    GridnumberItemModel(
      number: "lbl_20".tr,
      image: ImageConstant.imgFigurerun1,
      exercise: "lbl_exercise".tr,
    ),
    GridnumberItemModel(
      number: "lbl_20".tr,
      image: ImageConstant.imgAirplane,
      exercise: "lbl_travelling".tr,
    ),
    GridnumberItemModel(
      image: ImageConstant.imgPaintbrushPointedFill,
      exercise: "lbl_hobby".tr,
    ),
    GridnumberItemModel(exercise: "lbl_party".tr),
    GridnumberItemModel(exercise: "lbl_relationship".tr),
    GridnumberItemModel(exercise: "lbl_music".tr),
    GridnumberItemModel(exercise: "lbl_weather".tr),
    GridnumberItemModel(exercise: "lbl_shopping".tr),
    GridnumberItemModel(exercise: "lbl_beauty".tr),
    GridnumberItemModel(exercise: "lbl_person_12".tr),
    GridnumberItemModel(exercise: "lbl_person_22".tr),
    GridnumberItemModel(exercise: "lbl_person_22".tr),
    GridnumberItemModel(exercise: "lbl_ntua".tr),
  ];
}
