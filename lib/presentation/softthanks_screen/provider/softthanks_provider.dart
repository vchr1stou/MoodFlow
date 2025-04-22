import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/softthanks_model.dart';
import '../models/softthanks_one_item_model.dart';

/// A provider class for the SoftthanksScreen.
///
/// This provider manages the state of the SoftthanksScreen,
/// including the current SoftthanksModel instance.
// ignore_for_file: must_be_immutable
class SoftthanksProvider extends ChangeNotifier {
  SoftthanksModel softthanksModelObj = SoftthanksModel();

  @override
  void dispose() {
    super.dispose();
  }
}
