import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listchange_pin_item_model.dart';
import '../models/profile_pin_setted_model.dart';

/// A provider class for the ProfilePinSettedScreen.
///
/// This provider manages the state of the ProfilePinSettedScreen,
/// including the current profilePinSettedModelObj.
// ignore_for_file: must_be_immutable
class ProfilePinSettedProvider extends ChangeNotifier {
  ProfilePinSettedModel profilePinSettedModelObj = ProfilePinSettedModel();

  @override
  void dispose() {
    super.dispose();
  }
}
