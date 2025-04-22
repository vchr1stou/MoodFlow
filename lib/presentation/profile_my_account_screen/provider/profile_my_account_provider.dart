import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_my_account_model.dart';

/// A provider class for the ProfileMyAccountScreen.
///
/// This provider manages the state of the ProfileMyAccountScreen,
/// including the current profileMyAccountModelObj.
// ignore_for_file: must_be_immutable
class ProfileMyAccountProvider extends ChangeNotifier {
  ProfileMyAccountModel profileMyAccountModelObj = ProfileMyAccountModel();

  @override
  void dispose() {
    super.dispose();
  }
}
