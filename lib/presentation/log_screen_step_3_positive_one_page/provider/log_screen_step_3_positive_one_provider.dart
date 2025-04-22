import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_screen_step_3_positive_one_model.dart';

/// A provider class for the LogScreenStep3PositiveOnePage.
///
/// This provider manages the state of the LogScreenStep3PositiveOnePage, including the
/// current logScreenStep3PositiveOneModelObj

// ignore_for_file: must_be_immutable
class LogScreenStep3PositiveOneProvider extends ChangeNotifier {
  LogScreenStep3PositiveOneModel logScreenStep3PositiveOneModelObj =
      LogScreenStep3PositiveOneModel();

  @override
  void dispose() {
    super.dispose();
  }
}
