import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/breathingmain_model.dart';

/// A provider class for the BreathingmainScreen.
///
/// This provider manages the state of the BreathingmainScreen,
/// including the current [breathingmainModelObj].

// ignore_for_file: must_be_immutable
class BreathingmainProvider extends ChangeNotifier {
  BreathingmainModel breathingmainModelObj = BreathingmainModel();

  int lblQuantity = 1;

  @override
  void dispose() {
    super.dispose();
  }

  void decrementQuantity() {
    if (lblQuantity > 1) {
      lblQuantity--;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    lblQuantity++;
    notifyListeners();
  }
}
