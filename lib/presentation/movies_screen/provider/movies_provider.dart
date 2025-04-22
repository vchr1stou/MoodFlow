import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/app_export.dart';
import '../models/movies_model.dart';

/// A provider class for the MoviesScreen.
///
/// This provider manages the state of the MoviesScreen, including the
/// current moviesModelObj.
// ignore_for_file: must_be_immutable
class MoviesProvider extends ChangeNotifier {
  MoviesModel moviesModelObj = MoviesModel();

  types.User chatUser = types.User(id: 'RECEIVER_USER');

  List<types.Message> messageList = [
    types.TextMessage(
      type: types.MessageType.text,
      id: '308:5449',
      author: types.User(id: 'SENDER_USER'),
      text:
          "🍿 Lights, camera, mood boost! Here’s your personal feel-good movie night! 🎬",
      status: types.Status.delivered,
      createdAt: 1745178606694,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }
}
