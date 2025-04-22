import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_3_no_negative_model.dart';

/// A provider class for the LogScreenStep3NoNegativePage.
///
/// This provider manages the state of the LogScreenStep3NoNegativePage, including the
/// current logScreenStep3NoNegativeModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep3NoNegativeProvider extends ChangeNotifier {
  LogScreenStep3NoNegativeModel logScreenStep3NoNegativeModelObj =
      LogScreenStep3NoNegativeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
