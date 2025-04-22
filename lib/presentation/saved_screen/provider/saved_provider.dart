import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/saved_model.dart';
import '../models/saved_one_item_model.dart';

/// A provider class for the SavedScreen.
///
/// This provider manages the state of the SavedScreen,
/// including the current savedModelObj.
// ignore_for_file: must_be_immutable
class SavedProvider extends ChangeNotifier {
  SavedModel savedModelObj = SavedModel();

  @override
  void dispose() {
    super.dispose();
  }

  void onSelected(dynamic value) {
    for (var element in savedModelObj.dropdownItemList) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    notifyListeners();
  }
}
