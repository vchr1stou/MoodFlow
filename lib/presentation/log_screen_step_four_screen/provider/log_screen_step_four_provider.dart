import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_four_model.dart';

/// A provider class for the LogScreenStepFourScreen.
///
/// This provider manages the state of the LogScreenStepFourScreen, including the
/// current logScreenStepFourModelObj

// ignore_for_file: must_be_immutable
class LogScreenStepFourProvider extends ChangeNotifier {
  LogScreenStepFourModel logScreenStepFourModelObj = LogScreenStepFourModel();

  @override
  void dispose() {
    super.dispose();
  }
}
