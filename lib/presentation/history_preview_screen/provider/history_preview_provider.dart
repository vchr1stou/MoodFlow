import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/history_preview_item_model.dart';
import '../models/history_preview_model.dart';

/// A provider class for the HistoryPreviewScreen.
///
/// This provider manages the state of the HistoryPreviewScreen, including the
/// current historyPreviewModelObj

// ignore_for_file: must_be_immutable
class HistoryPreviewProvider extends ChangeNotifier {
  HistoryPreviewModel historyPreviewModelObj = HistoryPreviewModel();

  @override
  void dispose() {
    super.dispose();
  }
}
