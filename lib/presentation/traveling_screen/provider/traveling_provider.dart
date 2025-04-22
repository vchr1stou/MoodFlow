import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/app_export.dart';
import '../models/traveling_model.dart';

/// A provider class for the TravelingScreen.
///
/// This provider manages the state of the TravelingScreen, including the
/// current travelingModelObj
// ignore_for_file: must_be_immutable
class TravelingProvider extends ChangeNotifier {
  TravelingModel travelingModelObj = TravelingModel();

  types.User chatUser = types.User(id: 'RECEIVER_USER');

  List<types.Message> messageList = [
    types.TextMessage(
      type: types.MessageType.text,
      id: '798:3339',
      author: types.User(id: 'SENDER_USER'),
      text:
          "✈️ Your personal mini escape awaits — let’s boost that mood with a feel-good travel idea! 🌍🧳",
      status: types.Status.delivered,
      createdAt: 1745178606770,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }
}
