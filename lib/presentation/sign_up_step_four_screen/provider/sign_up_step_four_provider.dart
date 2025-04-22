import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/sign_up_step_four_model.dart';

/// A provider class for the SignUpStepFourScreen.
///
/// This provider manages the state of the SignUpStepFourScreen,
/// including the current signUpStepFourModelObj.
// ignore_for_file: must_be_immutable
class SignUpStepFourProvider extends ChangeNotifier {
  SignUpStepFourModel signUpStepFourModelObj = SignUpStepFourModel();

  @override
  void dispose() {
    super.dispose();
  }
}
