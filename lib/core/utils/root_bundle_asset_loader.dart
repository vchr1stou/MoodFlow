import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class CustomRootBundleAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final String jsonString = await rootBundle.loadString('$path/${locale.languageCode}.json');
    return json.decode(jsonString);
  }
} 