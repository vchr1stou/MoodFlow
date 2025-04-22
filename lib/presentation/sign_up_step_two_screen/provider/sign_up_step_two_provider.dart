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
}
