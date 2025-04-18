import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static late String appName;
  static late Color backgroundColor;
  static late Color primaryColor;
  static late Color accentColor;
  static late Color textColor;
  static late Color accentTextColor;

  static late String baseUrl;
  static late String apiToken;

  static Future<void> loadConfig() async {
    final configString = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(configString);

    appName = config['app']['name'];

    backgroundColor = _hexToColor(config['theme']['background_color']);
    primaryColor = _hexToColor(config['theme']['primary_color']);
    accentColor = _hexToColor(config['theme']['accent_color']);
    textColor = _hexToColor(config['theme']['text_color']);
    accentTextColor = _hexToColor(config['theme']['accent_text_color']);

    baseUrl = config['api']['base_url'];
    apiToken = config['api']['auth_token'];
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add opacity if missing
    return Color(int.parse('0x$hex'));
  }
}
