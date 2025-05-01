import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/sign_up_step_two_model.dart';

/// A provider class for the SignUpStepTwoScreen.
///
/// This provider manages the state of the SignUpStepTwoScreen,
/// including the current signUpStepTwoModelObj and the state of toggle switches.
// ignore_for_file: must_be_immutable
class SignUpStepTwoProvider extends ChangeNotifier {
  // Model object for the screen
  SignUpStepTwoModel signUpStepTwoModelObj = SignUpStepTwoModel();

  // State of toggle switches
  bool isSelectedSwitch = false;
  bool isSelectedSwitch1 = false;
  List<bool> dailyCheckInEnabled = [false, false, false, false];
  List<TimeOfDay> dailyCheckInTimes = [
    TimeOfDay(hour: 9, minute: 30),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 15, minute: 30),
    TimeOfDay(hour: 18, minute: 0),
  ];
  List<bool> isAddingDailyReminders = [false, false, false, false];

  @override
  void dispose() {
    super.dispose();
  }

  /// Method to update the first switch state
  void changeSwitchBox(bool value) {
    isSelectedSwitch = value;
    notifyListeners();
  }

  /// Method to update the second switch state
  void changeSwitchBox1(bool value) {
    isSelectedSwitch1 = value;
    notifyListeners();
  }

  void toggleDailyCheckIn(int index, bool value) {
    if (index >= 0 && index < dailyCheckInEnabled.length) {
      dailyCheckInEnabled[index] = value;
      notifyListeners();
    }
  }

  void updateDailyCheckInTime(int index, TimeOfDay time) {
    if (index >= 0 && index < dailyCheckInTimes.length) {
      dailyCheckInTimes[index] = time;
      isAddingDailyReminders[index] = false;
      notifyListeners();
    }
  }

  void toggleAddingReminder(int index, bool value) {
    if (index >= 0 && index < isAddingDailyReminders.length) {
      isAddingDailyReminders[index] = value;
      notifyListeners();
    }
  }
}
