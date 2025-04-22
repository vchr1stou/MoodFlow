import '../../../core/app_export.dart';
import 'listchange_pin_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfilePinSettedModel {
  List<ListchangePinItemModel> listchangePinItemList = [
    ListchangePinItemModel(
      changePinOne: ImageConstant.imgKeyFill1,
      changepin: "lbl_change_pin".tr,
    ),
    ListchangePinItemModel(
      changePinOne: ImageConstant.imgLockOpenFill1,
      changepin: "lbl_delete_pin".tr,
    ),
  ];
}
