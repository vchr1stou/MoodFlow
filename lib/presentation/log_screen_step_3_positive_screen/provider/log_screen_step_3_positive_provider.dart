import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_3_positive_model.dart';
import '../models/logscreenstep_tab1_model.dart';

/// A provider class for the LogScreenStep3PositiveScreen.
///
/// This provider manages the state of the LogScreenStep3PositiveScreen, including the
/// current logScreenStep3PositiveModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep3PositiveProvider extends ChangeNotifier {
  LogScreenStep3PositiveModel logScreenStep3PositiveModelObj =
      LogScreenStep3PositiveModel();

  LogscreenstepTab1Model logscreenstepTab1ModelObj = LogscreenstepTab1Model();

  @override
  void dispose() {
    super.dispose();
  }
}
