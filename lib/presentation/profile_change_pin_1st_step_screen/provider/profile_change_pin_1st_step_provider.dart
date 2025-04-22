import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_change_pin_1st_step_model.dart';

/// A provider class for the ProfileChangePin1stStepScreen.
///
/// This provider manages the state of the ProfileChangePin1stStepScreen,
/// including the current profileChangePin1stStepModelObj.
// ignore_for_file: must_be_immutable
class ProfileChangePin1stStepProvider extends ChangeNotifier {
  ProfileChangePin1stStepModel profileChangePin1stStepModelObj =
      ProfileChangePin1stStepModel();

  @override
  void dispose() {
    super.dispose();
  }
}
