import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/porfile_acessibility_settings_model.dart';
import '../../../providers/accessibility_provider.dart';

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

  void initialize(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(
      context,
      listen: false,
    );
    isSelectedSwitch = accessibilityProvider.isInverted;
    isSelectedSwitch1 = accessibilityProvider.isLargerText;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeSwitchBox(bool value, BuildContext context) {
    isSelectedSwitch = value;
    // Get the accessibility provider and toggle color inversion
    final accessibilityProvider = Provider.of<AccessibilityProvider>(
      context,
      listen: false,
    );
    if (value != accessibilityProvider.isInverted) {
      accessibilityProvider.toggleInvertColors();
    }
    notifyListeners();
  }

  void changeSwitchBox1(bool value, BuildContext context) {
    isSelectedSwitch1 = value;
    // Get the accessibility provider and toggle larger text
    final accessibilityProvider = Provider.of<AccessibilityProvider>(
      context,
      listen: false,
    );
    if (value != accessibilityProvider.isLargerText) {
      accessibilityProvider.toggleLargerText();
    }
    notifyListeners();
  }
}
