import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listtext_item_model.dart';
import '../models/log_input_model.dart';

/// A provider class for the LogInputScreen.
///
/// This provider manages the state of the LogInputScreen, including the
/// current logInputModelObj

// ignore_for_file: must_be_immutable
class LogInputProvider extends ChangeNotifier {
  LogInputModel logInputModelObj = LogInputModel();

  @override
  void dispose() {
    super.dispose();
  }
}
