import 'package:cooking_recipe_diary/services/api_services.dart';
import 'package:flutter/material.dart';

import '../models/TagModel.dart';

class TagProvider with ChangeNotifier {
  List<Tag> _tags = [];
  bool _isLoading = false;

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;

  Future<void> fetchTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tags = await ApiService.fetchTags();
    } catch (e) {
      print('Error fetch tags: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
