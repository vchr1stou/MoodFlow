import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_input_ai_model.dart';

/// A provider class for the LogInputAiScreen.
///
/// This provider manages the state of the LogInputAiScreen, including the
/// current logInputAiModelObj

// ignore_for_file: must_be_immutable
class LogInputAiProvider extends ChangeNotifier {
  TextEditingController miconeController = TextEditingController();

  LogInputAiModel logInputAiModelObj = LogInputAiModel();

  @override
  void dispose() {
    super.dispose();
    miconeController.dispose();
  }
}
