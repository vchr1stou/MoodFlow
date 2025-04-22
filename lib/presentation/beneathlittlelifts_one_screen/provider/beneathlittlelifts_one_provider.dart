import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/beneathlittlelifts_one_model.dart';
import '../models/listworkout_one_item_model.dart';

/// A provider class for the BeneathlittleliftsOneScreen.
///
/// This provider manages the state of the BeneathlittleliftsOneScreen, including the
/// current beneathlittleliftsOneModelObj

// ignore_for_file: must_be_immutable
class BeneathlittleliftsOneProvider extends ChangeNotifier {
  BeneathlittleliftsOneModel beneathlittleliftsOneModelObj =
      BeneathlittleliftsOneModel();

  @override
  void dispose() {
    super.dispose();
  }
}
