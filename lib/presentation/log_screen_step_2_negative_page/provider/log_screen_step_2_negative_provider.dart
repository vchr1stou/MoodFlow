import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/grid_item_model.dart';
import '../models/log_screen_step_2_negative_model.dart';

/// A provider class for the LogScreenStep2NegativePage.
///
/// This provider manages the state of the LogScreenStep2NegativePage, including the
/// current logScreenStep2NegativeModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep2NegativeProvider extends ChangeNotifier {
  LogScreenStep2NegativeModel logScreenStep2NegativeModelObj =
      LogScreenStep2NegativeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
