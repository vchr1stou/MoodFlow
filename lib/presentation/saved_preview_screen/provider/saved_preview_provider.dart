import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/saved_preview_model.dart';

/// A provider class for the SavedPreviewScreen.
///
/// This provider manages the state of the SavedPreviewScreen,
/// including the current savedPreviewModelObj.
// ignore_for_file: must_be_immutable
class SavedPreviewProvider extends ChangeNotifier {
  SavedPreviewModel savedPreviewModelObj = SavedPreviewModel();

  @override
  void dispose() {
    super.dispose();
  }
}
