import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmum_one_item_model.dart';
import '../models/safetynetlittlelifts_model.dart';

/// A provider class for the SafetynetlittleliftsScreen.
///
/// This provider manages the state of the SafetynetlittleliftsScreen,
/// including the current safetynetlittleliftsModelObj.
// ignore_for_file: must_be_immutable
class SafetynetlittleliftsProvider extends ChangeNotifier {
  TextEditingController searchfieldoneController = TextEditingController();
  bool showChat = true;
  List<Map<String, String>> messages = [
    {
      'role': 'assistant',
      'content': 'Sometimes, all you need is the voice of someone who makes you feel safe 💞 Take a deep breath — comfort is just one call away 📞'
    }
  ];

  late final SafetynetlittleliftsModel safetynetlittleliftsModelObj;
  bool _isInitialized = false;

  SafetynetlittleliftsProvider() {
    safetynetlittleliftsModelObj = SafetynetlittleliftsModel();
    _initializeSafetynet();
  }

  Future<void> _initializeSafetynet() async {
    try {
      await safetynetlittleliftsModelObj.fetchSafetynetFiles();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing safetynet: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    searchfieldoneController.dispose();
    super.dispose();
  }
}
