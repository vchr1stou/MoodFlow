import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'softthanks_one_item_model.dart';

// ignore_for_file: must_be_immutable
class SoftthanksModel {
  List<SoftthanksOneItemModel> softthanksOneItemList = [
    SoftthanksOneItemModel(
      thewaythe: "msg_the_way_the_sunlight".tr(),
    ),
    SoftthanksOneItemModel(
      thewaythe: "msg_a_text_from_someone".tr(),
    ),
    SoftthanksOneItemModel(
      thewaythe: "msg_breathing_deeply".tr(),
    ),
    SoftthanksOneItemModel(
      thewaythe: "msg_laughing_at_something".tr(),
    ),
    SoftthanksOneItemModel(
      thewaythe: "msg_finishing_something".tr(),
    ),
  ];
}
