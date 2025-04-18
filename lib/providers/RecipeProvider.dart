import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/services/api_services.dart';
import 'package:flutter/material.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;


  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await ApiService.fetchRecipes();
    } catch (e) {
      print('Error fetch recipes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
