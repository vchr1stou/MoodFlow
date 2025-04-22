import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/inhale_model.dart';

/// A provider class for the InhaleScreen.
///
/// This provider manages the state of the InhaleScreen, including the
/// current inhaleModelObj

// ignore_for_file: must_be_immutable
class InhaleProvider extends ChangeNotifier {
  InhaleModel inhaleModelObj = InhaleModel();

  @override
  void dispose() {
    super.dispose();
  }
}
