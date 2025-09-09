import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class StaticAuthService extends ChangeNotifier {
  static final StaticAuthService _instance = StaticAuthService._internal();
  factory StaticAuthService() => _instance;
  StaticAuthService._internal();

  AppUser? _currentUser;
  List<AppUser> _users = [];
  
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    debugPrint("🔍 Завантажуємо статичних користувачів...");
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/static_users.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      
      _users = (jsonData['users'] as List)
          .map((userJson) => AppUser.fromJson(userJson))
          .toList();
      
      debugPrint("✅ Завантажено ${_users.length} користувачів");
    } catch (e) {
      debugPrint("❌ Помилка завантаження користувачів: $e");
    }
    
    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔍 Пошук користувача: $email");
      
      final user = _users.firstWhere(
        (user) => user.email == email && password == "123456",
        orElse: () => throw Exception("Користувач не знайдено"),
      );
      
      _currentUser = user;
      notifyListeners();
      
      debugPrint("✅ Успішний вхід: ${user.name}");
      return null;
    } catch (e) {
      debugPrint("❌ Помилка входу: $e");
      return 'Неправильний email або пароль. Використовуйте test1@example.com - test5@example.com з паролем 123456';
    }
  }

  Future<void> logout() async {
    debugPrint("🔍 Вихід з системи...");
    _currentUser = null;
    notifyListeners();
    debugPrint("✅ Користувач вийшов з системи");
  }

  Future<bool> updateUserProfile(AppUser user) async {
    try {
      debugPrint("🔄 Оновлення профілю: ${user.name}");
      
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        _currentUser = user;
        notifyListeners();
        
        debugPrint("✅ Профіль оновлено: ${user.name}, балів: ${user.totalPoints}");
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint("❌ Помилка оновлення профілю: $e");
      return false;
    }
  }

  // Отримання списку всіх користувачів для тестування
  List<AppUser> getAllUsers() => List.from(_users);
}
