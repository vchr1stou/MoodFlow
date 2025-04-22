import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_model.dart';
import '../models/log_screen_one_item_model.dart';

/// A provider class for the LogScreen.
///
/// This provider manages the state of the LogScreen, including the
/// current logModelObj

// ignore_for_file: must_be_immutable
class LogProvider extends ChangeNotifier {
  LogModel logModelObj = LogModel();

  @override
  void dispose() {
    super.dispose();
  }
}
