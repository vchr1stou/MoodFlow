import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'profile_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfileModel {
  ProfileModel({
    this.profileOneItemList = const [],
  });

  List<ProfileOneItemModel> profileOneItemList;

  static List<ProfileOneItemModel> getProfileOneItemList() => [
        ProfileOneItemModel(
          title: "lbl_daily_streak".tr(),
        ),
        ProfileOneItemModel(
          title: "lbl_music".tr(),
        ),
        ProfileOneItemModel(
          title: "lbl_haptic_feedback".tr(),
        ),
      ];
}
