import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/app_export.dart';
import '../models/logged_input_ai_model.dart';

/// A provider class for the LoggedInputAiScreen.
///
/// This provider manages the state of the LoggedInputAiScreen, including the
/// current loggedInputAiModelObj

// ignore_for_file: must_be_immutable
class LoggedInputAiProvider extends ChangeNotifier {
  TextEditingController miconeController = TextEditingController();

  LoggedInputAiModel loggedInputAiModelObj = LoggedInputAiModel();

  types.User chatUser = types.User(id: 'RECEIVER_USER');

  List<types.Message> messageList = [
    types.TextMessage(
        type: types.MessageType.text,
        id: '317:12820',
        author: types.User(id: 'SENDER_USER'),
        text:
            "I sense you’re feeling happy —your mood is safe with me! 🌟 Let’s gently flow through it together.",
        status: types.Status.delivered,
        createdAt: 1745178606638),
    types.TextMessage(
        type: types.MessageType.text,
        id: '317:12741',
        author: types.User(id: 'SENDER_USER'),
        text: "Did I get your mood right, or should we rewind?   🎯✨",
        status: types.Status.delivered,
        createdAt: 1745178606638),
    types.TextMessage(
        type: types.MessageType.text,
        id: '317:12164',
        author: types.User(id: 'RECEIVER_USER'),
        text:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam iaculis convallis viverra. Pellentesque ac pharetra lorem, in ornare enim. Donec non lectus magna. ",
        status: types.Status.delivered,
        createdAt: 1745178606638)
  ];

  @override
  void dispose() {
    super.dispose();
    miconeController.dispose();
  }
}
