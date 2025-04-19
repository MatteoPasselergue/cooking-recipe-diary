import 'package:flutter/material.dart';
import '../models/TagModel.dart';
import '../services/ApiServices.dart';

class TagProvider extends ChangeNotifier {
  List<Tag> _tags = [];

  List<Tag> get tags => _tags;

  Future<void> fetchTags() async {
    try {
      final data = await ApiService.get('tags');
      _tags = data.map<Tag>((item) => Tag.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch tags: $e');
    }
  }

  Future<void> addTag(Tag tag) async {
    try {
      final newTag = await ApiService.post('tags', {
        'name': tag.name,
      });
      _tags.add(Tag.fromJson(newTag));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add tag: $e');
    }
  }

  Future<void> updateTag(Tag tag) async {
    try {
      await ApiService.put('tags', tag.id, {
        'name': tag.name,
      });
      final index = _tags.indexWhere((t) => t.id == tag.id);
      if (index != -1) {
        _tags[index] = tag;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update tag: $e');
    }
  }

  Future<void> deleteTag(int id) async {
    try {
      await ApiService.delete('tags', id);
      _tags.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete tag: $e');
    }
  }
}
