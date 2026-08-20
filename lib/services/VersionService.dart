import 'dart:convert';
import 'dart:io';

import 'package:cooking_recipe_diary/services/HttpClientService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {

  static Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static Future<Map<String, dynamic>?> fetchLatestVersionInfo() async {
    try {
      final response = await HttpClientService.client.get(
          Uri.parse("${AppConfig.baseUrl}/version"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static bool isNewVersionAvailable(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }
}