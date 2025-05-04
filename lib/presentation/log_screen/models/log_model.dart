import '../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'log_screen_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LogModel {
  List<LogScreenOneItemModel> logScreenOneItemList = [
    LogScreenOneItemModel(
        workOne: ImageConstant.imgGroup31, workTwo: "lbl_work".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgThumbsUpOnprimary42x42,
        workTwo: "lbl_family".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgGroup36, workTwo: "lbl_relationship".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgGroup34, workTwo: "lbl_study".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgAirplaneOnprimary,
        workTwo: "lbl_exercise".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgInboxOnprimary, workTwo: "lbl_party".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgGroup37, workTwo: "lbl_travelling".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgGroup39, workTwo: "lbl_music".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgUserOnprimary42x42, workTwo: "lbl_hobby".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgThumbsUp42x42, workTwo: "lbl_shopping".tr()),
    LogScreenOneItemModel(
        workOne: ImageConstant.imgSearch, workTwo: "lbl_beauty".tr()),
    LogScreenOneItemModel(workTwo: "lbl_weather".tr())
  ];
}
