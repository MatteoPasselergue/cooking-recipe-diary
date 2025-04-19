import 'package:flutter/material.dart';
import '../models/RecipeModel.dart';
import '../services/ApiServices.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> fetchRecipes() async {
    try {
      final data = await ApiService.get('recipes');
      _recipes = data.map<Recipe>((item) => Recipe.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final newRecipe = await ApiService.post('recipes', recipe.toJson());
      _recipes.add(Recipe.fromJson(newRecipe));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await ApiService.put('recipes', recipe.id, recipe.toJson());
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await ApiService.delete('recipes', id);
      _recipes.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}
