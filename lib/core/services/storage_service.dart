import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  
  Future<void> saveUser(AppUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
      await prefs.setBool(_isLoggedInKey, true);
      debugPrint('✅ Користувач збережено: ${user.name}');
    } catch (e) {
      debugPrint('❌ Помилка збереження користувача: $e');
    }
  }

  
  Future<AppUser?> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        final user = AppUser.fromJson(userData);
        debugPrint('✅ Користувач завантажено: ${user.name}');
        return user;
      }
      
      debugPrint('ℹ️ Користувач не знайдено в збережених даних');
      return null;
    } catch (e) {
      debugPrint('❌ Помилка завантаження користувача: $e');
      return null;
    }
  }

  
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      debugPrint('❌ Помилка перевірки статусу входу: $e');
      return false;
    }
  }

  
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.setBool(_isLoggedInKey, false);
      debugPrint('✅ Дані користувача видалено');
    } catch (e) {
      debugPrint('❌ Помилка видалення даних: $e');
    }
  }

  
  Future<void> updateUser(AppUser user) async {
    await saveUser(user);
  }
}
