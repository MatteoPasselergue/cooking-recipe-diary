import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/AppConfig.dart';
import 'HttpClientService.dart';

class ImageService {
  static final String baseUrl = AppConfig.baseUrl;

  static String buildImageUrl(String folder,int id, {int version=0}) {

    String url = '${AppConfig.baseUrl}/$folder/image/$id';
    if (version > 0) {
      url += '?v=$version';
    }
    return url;
  }

  static Future<void> uploadImage(String folder, int id, File imageFile) async {
    final url = Uri.parse('$baseUrl/$folder/image/$id');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var streamedResponse = await HttpClientService.client.send(request);  // <-- utilisez client.send()
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Image upload failed: ${response.statusCode}');
    }
  }
}