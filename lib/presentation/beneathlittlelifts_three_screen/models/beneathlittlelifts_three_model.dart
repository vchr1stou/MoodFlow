import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'listcooking_one_item_model.dart';

// ignore_for_file: must_be_immutable
class BeneathlittleliftsThreeModel {
  BeneathlittleliftsThreeModel({
    this.listcookingOneItemList = const [],
  });

  List<ListcookingOneItemModel> listcookingOneItemList;

  static List<ListcookingOneItemModel> getListcookingOneItemList() => [
        ListcookingOneItemModel(
          cookingTwo: "lbl_cooking".tr(),
          description: "msg_cooking_blends_creativity".tr(),
        ),
        ListcookingOneItemModel(
          cookingTwo: "lbl_travel_plans2".tr(),
          description: "msg_travel_gives_the".tr(),
        ),
        ListcookingOneItemModel(
          cookingTwo: "lbl_safety_net".tr(),
          description: "msg_connection_is_one".tr(),
        ),
        ListcookingOneItemModel(
          cookingTwo: "lbl_soft_thanks".tr(),
          description: "msg_keeping_a_gratitude".tr(),
        ),
      ];
}
