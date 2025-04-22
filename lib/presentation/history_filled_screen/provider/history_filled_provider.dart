import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/history_filled_item_model.dart';
import '../models/history_filled_model.dart';

/// A provider class for the HistoryFilledScreen.
///
/// This provider manages the state of the HistoryFilledScreen, including the
/// current historyFilledModelObj

// ignore_for_file: must_be_immutable
class HistoryFilledProvider extends ChangeNotifier {
  HistoryFilledModel historyFilledModelObj = HistoryFilledModel();

  @override
  void dispose() {
    super.dispose();
  }
}
