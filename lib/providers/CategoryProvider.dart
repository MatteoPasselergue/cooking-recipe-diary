import 'package:cooking_recipe_diary/services/ApiServices.dart';
import 'package:flutter/material.dart';

import '../models/CategoryModel.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  // FETCH
  Future<void> fetchCategories() async {
    try {
      final data = await ApiService.get('categories');
      _categories = data.map<Category>((item) => Category.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // ADD
  Future<void> addCategory(Category category) async {
    try {
      final newCategory = await ApiService.post('categories', {
        'name': category.name,
        'icon_name': category.iconName,
      });
      _categories.add(Category.fromJson(newCategory));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // UPDATE
  Future<void> updateCategory(Category category) async {
    try {
      await ApiService.put('categories', category.id, {
        'name': category.name,
        'icon_name': category.iconName,
      });
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // DELETE
  Future<void> deleteCategory(int id) async {
    try {
      await ApiService.delete('categories', id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
