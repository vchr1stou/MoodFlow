import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/emoji_log_three_model.dart';

/// A provider class for the EmojiLogThreeScreen.
///
/// This provider manages the state of the EmojiLogThreeScreen, including the
/// current emojiLogThreeModelObj

// ignore_for_file: must_be_immutable
class EmojiLogThreeProvider extends ChangeNotifier {
  EmojiLogThreeModel emojiLogThreeModelObj = EmojiLogThreeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
