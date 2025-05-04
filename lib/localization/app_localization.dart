import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  static const Map<String, String> _translations = {
    'lbl_exercise': 'Exercise',
    'lbl_party': 'Party',
    'lbl_travelling': 'Travelling',
    'lbl_20': '20',
    'lbl_mum': 'Mum',
    'lbl_dad': 'Dad',
    'lbl_partner': 'Partner',
    'lbl_best_friend': 'Best Friend',
    'lbl_6969696969': '6969696969',
  };

  static String tr(String key) {
    return _translations[key] ?? key;
  }
} 