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

  void updateLogData(Map<String, dynamic> logData) {
    // Update the model with the log data
    historyPreviewModelObj = HistoryPreviewModel(
      mood: logData['mood'] as String? ?? '',
      time: logData['time'] as String? ?? '',
      date: logData['date'] as String? ?? '',
      photos: (logData['photos'] as List<dynamic>?)?.cast<String>() ?? [],
      positiveFeelings: (logData['positiveFeelings'] as List<dynamic>?)?.cast<String>() ?? [],
      negativeFeelings: (logData['negativeFeelings'] as List<dynamic>?)?.cast<String>() ?? [],
      spotifyTrack: logData['spotifyTrack'] as Map<String, dynamic>?,
      toggledIcons: (logData['toggledIcons'] as List<dynamic>?)?.cast<String>() ?? [],
      contacts: (logData['contacts'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
    );
    notifyListeners();
  }
}
