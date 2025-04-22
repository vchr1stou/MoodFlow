import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/history_empty_model.dart';

/// A provider class for the HistoryEmptyScreen.
///
/// This provider manages the state of the HistoryEmptyScreen, including the
/// current historyEmptyModelObj

// ignore_for_file: must_be_immutable
class HistoryEmptyProvider extends ChangeNotifier {
  HistoryEmptyModel historyEmptyModelObj = HistoryEmptyModel();

  @override
  void dispose() {
    super.dispose();
  }
}
