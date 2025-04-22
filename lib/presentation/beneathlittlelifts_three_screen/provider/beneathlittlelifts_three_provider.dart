import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/beneathlittlelifts_three_model.dart';
import '../models/listcooking_one_item_model.dart';

/// A provider class for the BeneathlittleliftsThreeScreen.
///
/// This provider manages the state of the BeneathlittleliftsThreeScreen, including the
/// current beneathlittleliftsThreeModelObj

// ignore_for_file: must_be_immutable
class BeneathlittleliftsThreeProvider extends ChangeNotifier {
  BeneathlittleliftsThreeModel beneathlittleliftsThreeModelObj =
      BeneathlittleliftsThreeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
