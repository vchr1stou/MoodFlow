import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_five_model.dart';

/// A provider class for the LogScreenStepFiveScreen.
///
/// This provider manages the state of the LogScreenStepFiveScreen, including the
/// current logScreenStepFiveModelObj

// ignore_for_file: must_be_immutable
class LogScreenStepFiveProvider extends ChangeNotifier {
  LogScreenStepFiveModel logScreenStepFiveModelObj = LogScreenStepFiveModel();

  @override
  void dispose() {
    super.dispose();
  }
}
