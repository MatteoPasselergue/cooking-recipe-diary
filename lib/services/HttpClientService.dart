import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpClientService {
  static late http.Client _client;

  static Future<void> init() async {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    _client = IOClient(httpClient);
  }

  static http.Client get client => _client;
}