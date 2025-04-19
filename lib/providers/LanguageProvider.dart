import 'package:flutter/material.dart';
import '../services/LocalizationService.dart';

class LanguageProvider extends ChangeNotifier {
  String _locale = 'fr_FR'; //default language

  String get locale => _locale;

  Future<void> setLocale(String newLocale) async {
    _locale = newLocale;
    await LocalizationService.load(_locale);
    notifyListeners();
  }
}
