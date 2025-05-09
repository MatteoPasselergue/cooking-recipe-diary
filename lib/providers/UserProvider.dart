import 'dart:convert';
import 'dart:io';

import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/ApiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  User? _profile;

  List<User> get users => _users;
  User? get profile => _profile;

  Future<void> initialize() async {
    await fetchUsers();
    await loadProfile();
  }

  Future<void> fetchUsers() async {
    try {
      final data = await ApiService.get('users');
      _users = data.map<User>((item) => User.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      if(e is FormatException){
        throw FormatException(e.message);
      }else {
        throw Exception("$e");
      }
    }
  }

  Future<void> addUser(User user, {File? imageFile}) async {
    try {
      final newUserData = await ApiService.post('users', {
        'name': user.name,
        'imageVersion': user.imageVersion
      });

      final newUser = User.fromJson(newUserData);

      if(user.imageVersion != 0 && imageFile != null){
        await ImageService.uploadImage("users", newUser.id, imageFile);
      }

      _users.add(newUser);

      await saveProfile(newUser);

      notifyListeners();
    } catch (e) {
      if(e is FormatException){
        throw FormatException(e.message);
      }else {
        throw Exception("$e");
      }
    }
  }

  Future<void> updateUser(User user, {File? imageFile}) async {
    try {
      await ApiService.put('users', user.id, {
        'name': user.name,
        'imageVersion': user.imageVersion
      });
      if(user.imageVersion != 0 && imageFile != null){
        await ImageService.uploadImage("users", user.id, imageFile);
      }
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    } catch (e) {
      if(e is FormatException){
        throw FormatException(e.message);
      }else {
        throw Exception("$e");
      }
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await ApiService.delete('users', id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      if(e is FormatException){
        throw FormatException(e.message);
      }else {
        throw Exception("$e");
      }
    }
  }

  Future<void> saveProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', jsonEncode(user.toJson()));
    _profile = user;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString('profile');
    if (profileData != null) {
      final Map<String, dynamic> profileMap = jsonDecode(profileData);
      _profile = User.fromJson(profileMap);
    }
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
    _profile = null;
    notifyListeners();
  }

  User? getUserById(int id) {
    return _users.where((user) => user.id == id).isNotEmpty ? _users.firstWhere((user) => user.id == id) : null;
  }

}
