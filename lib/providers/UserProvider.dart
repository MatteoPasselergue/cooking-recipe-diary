import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/ApiServices.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    try {
      final data = await ApiService.get('users');
      _users = data.map<User>((item) => User.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      final newUser = await ApiService.post('users', {
        'name': user.name,
      });
      _users.add(User.fromJson(newUser));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await ApiService.put('users', user.id, {
        'name': user.name,
      });
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await ApiService.delete('users', id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
