import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/emoji_log_one_model.dart';

/// A provider class for the EmojiLogOneScreen.
///
/// This provider manages the state of the EmojiLogOneScreen, including the
/// current emojiLogOneModelObj

// ignore_for_file: must_be_immutable
class EmojiLogOneProvider extends ChangeNotifier {
  EmojiLogOneModel emojiLogOneModelObj = EmojiLogOneModel();

  @override
  void dispose() {
    super.dispose();
  }
}
