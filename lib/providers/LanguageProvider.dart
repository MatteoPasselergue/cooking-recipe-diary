import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/LocalizationService.dart';

class LanguageProvider extends ChangeNotifier {
  String _locale = 'fr_FR'; //default language
  List<Map<String, String>> _availableLocales = [];
  List<Map<String, String>> get availableLocales => _availableLocales;


  String get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) {
      _locale = savedLocale;
    }
    _availableLocales = await LocalizationService.getAvailableLocales();
    await LocalizationService.load(_locale);
    notifyListeners();
  }

  Future<void> setLocale(String newLocale) async {
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale);
    await LocalizationService.load(_locale);
    notifyListeners();
  }
}
