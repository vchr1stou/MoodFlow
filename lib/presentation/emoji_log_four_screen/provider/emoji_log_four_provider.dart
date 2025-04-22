import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/emoji_log_four_model.dart';

/// A provider class for the EmojiLogFourScreen.
///
/// This provider manages the state of the EmojiLogFourScreen, including the
/// current emojiLogFourModelObj

// ignore_for_file: must_be_immutable
class EmojiLogFourProvider extends ChangeNotifier {
  EmojiLogFourModel emojiLogFourModelObj = EmojiLogFourModel();

  @override
  void dispose() {
    super.dispose();
  }
}
