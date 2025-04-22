import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmum_one_item_model.dart';
import '../models/sign_up_step_3_filled_model.dart';

/// A provider class for the SignUpStep3FilledScreen.
///
/// This provider manages the state of the SignUpStep3FilledScreen,
/// including the current signUpStep3FilledModelObj.
// ignore_for_file: must_be_immutable
class SignUpStep3FilledProvider extends ChangeNotifier {
  SignUpStep3FilledModel signUpStep3FilledModelObj = SignUpStep3FilledModel();

  @override
  void dispose() {
    super.dispose();
  }
}
