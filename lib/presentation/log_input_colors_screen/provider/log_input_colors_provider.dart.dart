import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_input_colors_model.dart';

/// A provider class for the LogInputColorsScreen.
///
/// This provider manages the state of the LogInputColorsScreen, including the
/// current logInputColorsModelObj

// ignore_for_file: must_be_immutable
class LogInputColorsProvider extends ChangeNotifier {
  LogInputColorsModel logInputColorsModelObj = LogInputColorsModel();

  @override
  void dispose() {
    super.dispose();
  }
}
