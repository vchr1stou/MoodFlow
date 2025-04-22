import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/sign_up_step_three_model.dart';

/// A provider class for the SignUpStepThreeScreen.
///
/// This provider manages the state of the SignUpStepThreeScreen,
/// including the current signUpStepThreeModelObj.
// ignore_for_file: must_be_immutable
class SignUpStepThreeProvider extends ChangeNotifier {
  SignUpStepThreeModel signUpStepThreeModelObj = SignUpStepThreeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
