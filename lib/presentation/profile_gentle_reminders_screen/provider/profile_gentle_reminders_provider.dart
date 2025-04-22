import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_gentle_reminders_model.dart';

/// A provider class for the ProfileGentleRemindersScreen.
///
/// This provider manages the state of the ProfileGentleRemindersScreen,
/// including the current profileGentleRemindersModelObj.
// ignore_for_file: must_be_immutable
class ProfileGentleRemindersProvider extends ChangeNotifier {
  ProfileGentleRemindersModel profileGentleRemindersModelObj =
      ProfileGentleRemindersModel();

  bool isSelectedSwitch = false;
  bool isSelectedSwitch1 = false;
  bool isSelectedSwitch2 = false;

  @override
  void dispose() {
    super.dispose();
  }

  void changeSwitchBox(bool value) {
    isSelectedSwitch = value;
    notifyListeners();
  }

  void changeSwitchBox1(bool value) {
    isSelectedSwitch1 = value;
    notifyListeners();
  }

  void changeSwitchBox2(bool value) {
    isSelectedSwitch2 = value;
    notifyListeners();
  }
}
