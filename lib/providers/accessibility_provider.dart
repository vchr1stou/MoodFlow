import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  static const String _invertColorsKey = 'invert_colors';
  static const String _largerTextKey = 'larger_text';
  
  bool _isInverted = false;
  bool _isLargerText = false;
  double _textScaleFactor = 1.0;

  AccessibilityProvider() {
    _loadSettings();
  }

  bool get isInverted => _isInverted;
  bool get isLargerText => _isLargerText;
  double get textScaleFactor => _textScaleFactor;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isInverted = prefs.getBool(_invertColorsKey) ?? false;
    _isLargerText = prefs.getBool(_largerTextKey) ?? false;
    _textScaleFactor = _isLargerText ? 1.15 : 1.0;
    notifyListeners();
  }

  Future<void> toggleInvertColors() async {
    _isInverted = !_isInverted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_invertColorsKey, _isInverted);
    notifyListeners();
  }

  Future<void> toggleLargerText() async {
    _isLargerText = !_isLargerText;
    _textScaleFactor = _isLargerText ? 1.15 : 1.0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largerTextKey, _isLargerText);
    notifyListeners();
  }
} 