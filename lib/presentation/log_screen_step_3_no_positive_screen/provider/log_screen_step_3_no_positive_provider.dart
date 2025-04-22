import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_3_no_positive_model.dart';
import '../models/logscreenstep_tab2_model.dart';

/// A provider class for the LogScreenStep3NoPositiveScreen.
///
/// This provider manages the state of the LogScreenStep3NoPositiveScreen, including the
/// current logScreenStep3NoPositiveModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep3NoPositiveProvider extends ChangeNotifier {
  LogScreenStep3NoPositiveModel logScreenStep3NoPositiveModelObj =
      LogScreenStep3NoPositiveModel();

  LogscreenstepTab2Model logscreenstepTab2ModelObj = LogscreenstepTab2Model();

  @override
  void dispose() {
    super.dispose();
  }
}
