import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmum_one_item_model.dart';
import '../models/profile_safety_net_model.dart';

/// A provider class for the ProfileSafetyNetScreen.
///
/// This provider manages the state of the ProfileSafetyNetScreen,
/// including the current profileSafetyNetModelObj.
// ignore_for_file: must_be_immutable
class ProfileSafetyNetProvider extends ChangeNotifier {
  ProfileSafetyNetModel profileSafetyNetModelObj = ProfileSafetyNetModel();

  @override
  void dispose() {
    super.dispose();
  }
}
