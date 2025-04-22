import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_change_pin_2nd_step_model.dart';

/// A provider class for the ProfileChangePin2ndStepScreen.
///
/// This provider manages the state of the ProfileChangePin2ndStepScreen,
/// including the current profileChangePin2ndStepModelObj.
// ignore_for_file: must_be_immutable
class ProfileChangePin2ndStepProvider extends ChangeNotifier {
  ProfileChangePin2ndStepModel profileChangePin2ndStepModelObj =
      ProfileChangePin2ndStepModel();

  @override
  void dispose() {
    super.dispose();
  }
}
