import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/app_export.dart';
import '../models/beneathlittlelifts_two_model.dart';
import '../models/listmovie_time_item_model.dart';

/// A provider class for the BeneathlittleliftsTwoScreen.
///
/// This provider manages the state of the BeneathlittleliftsTwoScreen, including the
/// current beneathlittleliftsTwoModelObj

// ignore_for_file: must_be_immutable
class BeneathlittleliftsTwoProvider extends ChangeNotifier {
  BeneathlittleliftsTwoModel beneathlittleliftsTwoModelObj =
      BeneathlittleliftsTwoModel();

  TextEditingController miconeController = TextEditingController();
  List<types.Message> messageList = [];
  types.User chatUser = types.User(
    id: '1',
    firstName: 'User',
    lastName: 'Name',
  );

  @override
  void dispose() {
    miconeController.dispose();
    super.dispose();
  }
}
