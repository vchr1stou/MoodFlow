import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_set_new_pin_1st_step_model.dart';

/// A provider class for the ProfileSetNewPin1stStepScreen.
///
/// This provider manages the state of the ProfileSetNewPin1stStepScreen,
/// including the current profileSetNewPin1stStepModelObj.
// ignore_for_file: must_be_immutable
class ProfileSetNewPin1stStepProvider extends ChangeNotifier {
  ProfileSetNewPin1stStepModel profileSetNewPin1stStepModelObj =
      ProfileSetNewPin1stStepModel();

  @override
  void dispose() {
    super.dispose();
  }
}
