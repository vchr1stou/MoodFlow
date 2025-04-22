import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/emoji_log_five_model.dart';

/// A provider class for the EmojiLogFiveScreen.
///
/// This provider manages the state of the EmojiLogFiveScreen, including the
/// current emojiLogFiveModelObj

// ignore_for_file: must_be_immutable
class EmojiLogFiveProvider extends ChangeNotifier {
  EmojiLogFiveModel emojiLogFiveModelObj = EmojiLogFiveModel();

  @override
  void dispose() {
    super.dispose();
  }
}
