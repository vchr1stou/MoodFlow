import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';

/// This class is used in the [profile_one_item_widget] screen.
// ignore_for_file: must_be_immutable
class ProfileOneItemModel {
  ProfileOneItemModel({
    this.dailyStreak,
    this.title,
    this.isSelectedSwitch,
    this.id,
  }) {
    dailyStreak ??= ImageConstant.imgFlamefill2;
    title = title ?? "lbl_daily_streak".tr();
    isSelectedSwitch ??= false;
    id ??= "";
  }

  String? dailyStreak;
  String? title;
  bool? isSelectedSwitch;
  String? id;
}
