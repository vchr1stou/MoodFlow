import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmum_one_item_model.dart';
import '../models/safetynetlittlelifts_model.dart';

/// A provider class for the SafetynetlittleliftsScreen.
///
/// This provider manages the state of the SafetynetlittleliftsScreen,
/// including the current safetynetlittleliftsModelObj.
// ignore_for_file: must_be_immutable
class SafetynetlittleliftsProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();

  SafetynetlittleliftsModel safetynetlittleliftsModelObj =
      SafetynetlittleliftsModel();

  @override
  void dispose() {
    searchfieldoneController.dispose();
    super.dispose();
  }
}
