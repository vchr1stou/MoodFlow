import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/porfile_acessibility_settings_model.dart';

/// A provider class for the PorfileAcessibilitySettingsScreen.
///
/// This provider manages the state of the PorfileAcessibilitySettingsScreen,
/// including the current porfileAcessibilitySettingsModelObj.
// ignore_for_file: must_be_immutable
class PorfileAcessibilitySettingsProvider extends ChangeNotifier {
  PorfileAcessibilitySettingsModel porfileAcessibilitySettingsModelObj =
      PorfileAcessibilitySettingsModel();

  bool isSelectedSwitch = false;
  bool isSelectedSwitch1 = false;

  @override
  void dispose() {
    super.dispose();
  }

  void changeSwitchBox(bool value) {
    isSelectedSwitch = value;
    notifyListeners();
  }

  void changeSwitchBox1(bool value) {
    isSelectedSwitch1 = value;
    notifyListeners();
  }
}
