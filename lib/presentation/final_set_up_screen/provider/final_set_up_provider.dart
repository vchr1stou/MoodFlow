import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/final_set_up_model.dart';

/// A provider class for the FinalSetUpScreen.
///
/// This provider manages the state of the FinalSetUpScreen, including the
/// current finalSetUpModelObj

// ignore_for_file: must_be_immutable
class FinalSetUpProvider extends ChangeNotifier {
  FinalSetUpModel finalSetUpModelObj = FinalSetUpModel();

  @override
  void dispose() {
    super.dispose();
  }
}
