import 'dart:convert';
import 'package:cooking_recipe_diary/models/CategoryModel.dart';
import 'package:cooking_recipe_diary/models/TagModel.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:http/http.dart' as http;

import '../models/RecipeModel.dart';

class ApiService {

  static Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/recipes'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/categories'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Tag>> fetchTags() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/tags'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Tag.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }
}
