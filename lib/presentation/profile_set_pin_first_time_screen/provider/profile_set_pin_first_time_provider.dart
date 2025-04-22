import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_set_pin_first_time_model.dart';

/// A provider class for the ProfileSetPinFirstTimeScreen.
///
/// This provider manages the state of the ProfileSetPinFirstTimeScreen,
/// including the current profileSetPinFirstTimeModelObj.
// ignore_for_file: must_be_immutable
class ProfileSetPinFirstTimeProvider extends ChangeNotifier {
  ProfileSetPinFirstTimeModel profileSetPinFirstTimeModelObj =
      ProfileSetPinFirstTimeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
