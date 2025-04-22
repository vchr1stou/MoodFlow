import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/cooking_model.dart';

/// A provider class for the CookingScreen.
///
/// This provider manages the state of the CookingScreen,
/// including the current [cookingModelObj].

// ignore_for_file: must_be_immutable
class CookingProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();

  CookingModel cookingModelObj = CookingModel();

  @override
  void dispose() {
    searchfieldoneController.dispose();
    super.dispose();
  }
}
