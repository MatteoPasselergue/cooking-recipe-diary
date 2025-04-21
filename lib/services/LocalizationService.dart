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

  static Future<List<Map<String, String>>> getAvailableLocales() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final localeFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/lang/') && key.endsWith('.json'))
        .toList();

    List<Map<String, String>> locales = [];

    for (String filePath in localeFiles) {
      final jsonString = await rootBundle.loadString(filePath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final localeCode = filePath.split('/').last.replaceAll('.json', '');
      final languageName = jsonMap['language_name'] ?? localeCode;

      locales.add({
        'code': localeCode,
        'name': languageName,
      });
    }

    return locales;
  }

}