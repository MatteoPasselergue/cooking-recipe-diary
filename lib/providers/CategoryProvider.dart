import 'package:cooking_recipe_diary/services/api_services.dart';
import 'package:flutter/material.dart';

import '../models/CategoryModel.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await ApiService.fetchCategories();
    } catch (e) {
      print('Error fetch categories: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
