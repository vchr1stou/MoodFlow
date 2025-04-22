import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_model.dart';
import '../models/profile_one_item_model.dart';

/// A provider class for the ProfileScreen.
///
/// This provider manages the state of the ProfileScreen,
/// including the current profileModelObj.
// ignore_for_file: must_be_immutable
class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModelObj = ProfileModel();

  @override
  void dispose() {
    super.dispose();
  }

  /// Updates the switch value for the item at the given index
  void changeSwitchBox(int index, bool value) {
    profileModelObj.profileOneItemList[index].isSelectedSwitch = value;
    notifyListeners();
  }
}
