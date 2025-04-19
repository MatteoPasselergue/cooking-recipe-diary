import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static Map<String, dynamic> _localizedStrings = {};

  static Future<void> load(String locale) async {
    final String jsonString =
    await rootBundle.loadString('assets/lang/$locale.json');
    _localizedStrings = json.decode(jsonString);
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}