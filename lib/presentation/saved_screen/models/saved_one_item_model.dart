import '../../../core/app_export.dart';

/// This class is used in the [saved_one_item_widget] screen.
// ignore_for_file: must_be_immutable
class SavedOneItemModel {
  SavedOneItemModel({
    this.messagelarge,
    this.messagelarge1,
    this.italian,
    this.id,
  }) {
    messagelarge ??= "msg_italian_carbonara".tr;
    messagelarge1 ??= "lbl_cooking".tr;
    italian ??= ImageConstant.imgArrowRight;
    id ??= "";
  }

  String? messagelarge;
  String? messagelarge1;
  String? italian;
  String? id;
}
