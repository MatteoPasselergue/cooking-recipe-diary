import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/AppConfig.dart';

class ApiService {
  static final String baseUrl = AppConfig.baseUrl;

  // GET
  static Future<List<dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('GET failed: ${response.statusCode}');
    }
  }

  // GET SINGLE
  static Future<dynamic> getById(String endpoint, int id) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('GET by ID failed: ${response.statusCode}');
    }
  }

  // POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('POST failed: ${response.statusCode}');
    }
  }

  // PUT
  static Future<dynamic> put(String endpoint, int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('PUT failed: ${response.statusCode}');
    }
  }

  // PATCH
  static Future<dynamic> patch(String endpoint, int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('PATCH failed: ${response.statusCode}');
    }
  }

  // DELETE
  static Future<void> delete(String endpoint, int id) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('DELETE failed: ${response.statusCode}');
    }
  }
}
