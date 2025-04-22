import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/app_export.dart';
import '../models/positiveaffirmations_model.dart';

/// A provider class for the PositiveaffirmationsScreen.
///
/// This provider manages the state of the PositiveaffirmationsScreen,
/// including the current positiveaffirmationsModelObj.
// ignore_for_file: must_be_immutable
class PositiveaffirmationsProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();

  PositiveaffirmationsModel positiveaffirmationsModelObj =
      PositiveaffirmationsModel();

  types.User chatUser = types.User(id: 'RECEIVER_USER');

  List<types.Message> messageList = [
    types.TextMessage(
      type: types.MessageType.text,
      id: '800:4080',
      author: types.User(id: 'SENDER_USER'),
      text:
          "🪞 Whisper this truth gently — your words shape the world within you. ✨💬",
      status: types.Status.delivered,
      createdAt: 1745178606777,
    ),
  ];

  @override
  void dispose() {
    searchfieldoneController.dispose();
    super.dispose();
  }
}
