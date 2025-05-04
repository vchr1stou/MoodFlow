import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'listmum_one_item_model.dart';

// ignore_for_file: must_be_immutable
class SafetynetlittleliftsModel {
  SafetynetlittleliftsModel({
    this.listmumOneItemList = const [],
  });

  List<ListmumOneItemModel> listmumOneItemList;

  static List<ListmumOneItemModel> getListmumOneItemList() => [
        ListmumOneItemModel(
          mumTwo: "lbl_mum".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
        ListmumOneItemModel(
          mumTwo: "lbl_dad".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
        ListmumOneItemModel(
          mumTwo: "lbl_partner".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
      ];
}
