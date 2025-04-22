import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/little_lifts_initial_model.dart';
import '../models/little_lifts_item_model.dart';
import '../models/little_lifts_model.dart';

/// A provider class for the LittleLiftsScreen.
///
/// This provider manages the state of the LittleLiftsScreen, including the
/// current littleLiftsModelObj

// ignore_for_file: must_be_immutable
class LittleLiftsProvider extends ChangeNotifier {
  LittleLiftsModel littleLiftsModelObj = LittleLiftsModel();

  LittleLiftsInitialModel littleLiftsInitialModelObj =
      LittleLiftsInitialModel();

  @override
  void dispose() {
    super.dispose();
  }
}
