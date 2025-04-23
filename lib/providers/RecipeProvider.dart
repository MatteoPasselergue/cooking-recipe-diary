import 'dart:io';

import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:flutter/material.dart';
import '../models/RecipeModel.dart';
import '../services/ApiServices.dart';
import '../services/LocalizationService.dart';

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

  Future<void> addRecipe(Recipe recipe, {File? imageFile}) async {
    try {
      final newRecipeData = await ApiService.post('recipes', recipe.toJson());
      final newRecipe = Recipe.fromJson(newRecipeData);

      if(recipe.imageVersion !=0 && imageFile !=null){
        ImageService.uploadImage("recipes", newRecipe.id, imageFile);
      }

      _recipes.add(newRecipe);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<void> updateRecipe(Recipe recipe, {File? imageFile}) async {
    try {
      await ApiService.put('recipes', recipe.id, recipe.toJson());

      if(recipe.imageVersion !=0 && imageFile !=null){
        ImageService.uploadImage("recipes", recipe.id, imageFile);
      }
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  Future<void> removeCategoryFromRecipes(int categoryId) async {
    final recipesToUpdate = _recipes.where((recipe) => recipe.categoryId == categoryId).toList();

    if(recipesToUpdate.isEmpty) return;

    for (final recipe in recipesToUpdate) {
      final updatedRecipe = recipe.copyWith(categoryId: 0);
      final index = _recipes.indexWhere((r) => r.id == recipe.id);

      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
    }
    notifyListeners();
  }

  Future<void> removeUserFromRecipes(int userId) async {
    final recipesToUpdate = _recipes.where((recipe) => recipe.userId == userId).toList();

    if(recipesToUpdate.isEmpty) return;

    for (final recipe in recipesToUpdate) {
      final updatedRecipe = recipe.copyWith(userId: 0);
      final index = _recipes.indexWhere((r) => r.id == recipe.id);

      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
    }
    notifyListeners();
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

  Future<Recipe> createEmptyRecipe(int userId) async {
    try {
      final emptyRecipe = Recipe(
        id: 0,
        name: LocalizationService.translate("default_recipe_title"),
        ingredients: [],
        steps: [],
        prepTime: 0,
        cookTime: 0,
        restTime: 0,
        servings: 1,
        categoryId: 0,
        tags: [],
        userId: userId,
        imageVersion: 0,
      );

      final newRecipeData = await ApiService.post('recipes', emptyRecipe.toJson());
      final newRecipe = Recipe.fromJson(newRecipeData);

      _recipes.add(newRecipe);
      notifyListeners();

      return newRecipe;
    } catch (e) {
      throw Exception('Failed to create empty recipe: $e');
    }
  }

}
