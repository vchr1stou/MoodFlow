import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/ai_model.dart';

/// A provider class for the AiScreen.
///
/// This provider manages the state of the AiScreen, including the
/// current aiModelObj

// ignore_for_file: must_be_immutable
class AiProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();

  AiModel aiModelObj = AiModel();

  @override
  void dispose() {
    super.dispose();
    searchfieldoneController.dispose();
  }
}
