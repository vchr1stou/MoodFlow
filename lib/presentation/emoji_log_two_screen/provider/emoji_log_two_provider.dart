import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/emoji_log_two_model.dart';

/// A provider class for the EmojiLogTwoScreen.
///
/// This provider manages the state of the EmojiLogTwoScreen, including the
/// current emojiLogTwoModelObj

// ignore_for_file: must_be_immutable
class EmojiLogTwoProvider extends ChangeNotifier {
  EmojiLogTwoModel emojiLogTwoModelObj = EmojiLogTwoModel();

  @override
  void dispose() {
    super.dispose();
  }
}
