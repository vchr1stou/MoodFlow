import '../../../core/app_export.dart';

/// This class is used in the [listmum_one_item_widget] screen.
// ignore_for_file: must_be_immutable
class ListmumOneItemModel {
  ListmumOneItemModel({
    this.mumTwo,
    this.mobileNo,
    this.id,
  }) {
    mumTwo ??= "lbl_mum".tr;
    mobileNo ??= "lbl_6969696969".tr;
    id ??= "";
  }

  String? mumTwo;
  String? mobileNo;
  String? id;
}
