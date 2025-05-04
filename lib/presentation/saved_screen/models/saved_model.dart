import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'saved_one_item_model.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore_for_file: must_be_immutable
class SavedModel {
  List<SelectionPopupModel> dropdownItemList = [
    SelectionPopupModel(
      id: 1,
      title: "Item One",
      isSelected: true,
    ),
    SelectionPopupModel(
      id: 2,
      title: "Item Two",
    ),
    SelectionPopupModel(
      id: 3,
      title: "Item Three",
    ),
  ];

  List<SavedOneItemModel> savedOneItemList = [
    SavedOneItemModel(
      messagelarge: "msg_italian_carbonara".tr(),
      messagelarge1: "lbl_cooking".tr(),
      italian: ImageConstant.imgArrowRight,
    ),
    SavedOneItemModel(),
    SavedOneItemModel(),
    SavedOneItemModel(),
    SavedOneItemModel(),
  ];
}
