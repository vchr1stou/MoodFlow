import '../../../core/app_export.dart';

/// This class is used in the [listchange_pin_item_widget] screen.
// ignore_for_file: must_be_immutable
class ListchangePinItemModel {
  ListchangePinItemModel({
    this.changePinOne,
    this.changepin,
    this.id,
  }) {
    changePinOne ??= ImageConstant.imgKeyFill1;
    changepin ??= "lbl_change_pin".tr;
    id ??= "";
  }

  String? changePinOne;
  String? changepin;
  String? id;
}
