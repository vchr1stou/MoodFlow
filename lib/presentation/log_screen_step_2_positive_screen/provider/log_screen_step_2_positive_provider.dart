import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/grid_item_model.dart';
import '../models/log_screen_step_2_positive_model.dart';
import '../models/logscreenstep_tab_model.dart';

/// A provider class for the LogScreenStep2PositiveScreen.
///
/// This provider manages the state of the LogScreenStep2PositiveScreen, including the
/// current logScreenStep2PositiveModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep2PositiveProvider extends ChangeNotifier {
  LogScreenStep2PositiveModel logScreenStep2PositiveModelObj =
      LogScreenStep2PositiveModel();

  LogscreenstepTabModel logscreenstepTabModelObj = LogscreenstepTabModel();

  @override
  void dispose() {
    super.dispose();
  }
}
