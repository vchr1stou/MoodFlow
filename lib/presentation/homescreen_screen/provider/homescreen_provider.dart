import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/homescreen_model.dart';

/// A provider class for the HomescreenScreen.
///
/// This provider manages the state of the HomescreenScreen, including the
/// current homescreenModelObj

// ignore_for_file: must_be_immutable
class HomescreenProvider extends ChangeNotifier {
  HomescreenModel homescreenModelObj = HomescreenModel();

  @override
  void dispose() {
    super.dispose();
  }
}
