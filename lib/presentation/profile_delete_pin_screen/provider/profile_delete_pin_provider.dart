import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_delete_pin_model.dart';

/// A provider class for the ProfileDeletePinScreen.
///
/// This provider manages the state of the ProfileDeletePinScreen,
/// including the current profileDeletePinModelObj.
// ignore_for_file: must_be_immutable
class ProfileDeletePinProvider extends ChangeNotifier {
  ProfileDeletePinModel profileDeletePinModelObj = ProfileDeletePinModel();

  @override
  void dispose() {
    super.dispose();
  }
}
