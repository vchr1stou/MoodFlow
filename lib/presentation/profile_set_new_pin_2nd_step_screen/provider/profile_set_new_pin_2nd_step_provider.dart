import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_set_new_pin_2nd_step_model.dart';

/// A provider class for the ProfileSetNewPin2ndStepScreen.
///
/// This provider manages the state of the ProfileSetNewPin2ndStepScreen,
/// including the current profileSetNewPin2ndStepModelObj.
// ignore_for_file: must_be_immutable
class ProfileSetNewPin2ndStepProvider extends ChangeNotifier {
  ProfileSetNewPin2ndStepModel profileSetNewPin2ndStepModelObj =
      ProfileSetNewPin2ndStepModel();

  @override
  void dispose() {
    super.dispose();
  }
}
