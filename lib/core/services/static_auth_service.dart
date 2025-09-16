import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/services/storage_service.dart';
import 'package:donor_dashboard/core/services/simple_sync_service.dart';

class StaticAuthService extends ChangeNotifier {
  static final StaticAuthService _instance = StaticAuthService._internal();
  factory StaticAuthService() => _instance;
  StaticAuthService._internal();

  AppUser? _currentUser;
  List<AppUser> _users = [];
  final StorageService _storageService = StorageService();
  final SimpleSyncService _syncService = SimpleSyncService();
  
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    debugPrint("🔍 Завантажуємо користувачів...");
    try {
      final String jsonString = await rootBundle.loadString('lib/data/static_users.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      
      _users = (jsonData['users'] as List)
          .map((userJson) => AppUser.fromJson(userJson))
          .toList();
      
      debugPrint("✅ Завантажено ${_users.length} користувачів з локального файлу");
      for (final user in _users) {
        debugPrint("👤 Користувач: ${user.name} (${user.email})");
      }
      await _syncService.saveUsers(_users);
    } catch (e) {
      debugPrint("❌ Помилка завантаження користувачів: $e");
    }
    _currentUser = await _storageService.loadUser();
    if (_currentUser != null) {
      debugPrint("✅ Знайдено збереженого користувача: ${_currentUser!.name}");
      if (!_users.any((u) => u.id == _currentUser!.id)) {
        _users.add(_currentUser!);
        debugPrint("✅ Додано збереженого користувача до списку");
      }
    } else {
      debugPrint("ℹ️ Збереженого користувача не знайдено");
    }
    
    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔍 Пошук користувача: $email");
      debugPrint("🔍 Доступні користувачі: ${_users.length}");
      for (final u in _users) {
        debugPrint("👤 ${u.email} (${u.password})");
      }
      AppUser? user;
      try {
        user = _users.firstWhere(
          (user) => user.email == email && user.password == password,
        );
        debugPrint("✅ Знайдено користувача в статичному списку: ${user.name}");
      } catch (e) {
        debugPrint("🔍 Користувач не знайдений в статичному списку, шукаємо в збережених даних...");
        final savedUser = await _storageService.loadUser();
        if (savedUser != null && savedUser.email == email && savedUser.password == password) {
          user = savedUser;
          if (!_users.any((u) => u.id == user!.id)) {
            _users.add(user);
          }
        } else {
          debugPrint("🔍 Користувач не знайдений в збережених даних, можливо він реєструвався на іншому пристрої");
        }
      }
      
      if (user == null) {
        throw Exception("Користувач не знайдено");
      }
      
      _currentUser = user;
      await _storageService.saveUser(user);
      notifyListeners();
      
      debugPrint("✅ Успішний вхід: ${user.name}");
      return null;
    } catch (e) {
      debugPrint("❌ Помилка входу: $e");
      return 'Неправильний email або пароль.';
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔍 Реєстрація користувача: $email");
      
      if (_users.any((user) => user.email == email)) {
        return 'Акаунт з таким email вже існує.';
      }

      if (password.length < 6) {
        return 'Пароль занадто слабкий.';
      }

      if (!email.contains('@') || !email.contains('.')) {
        return 'Неправильний формат email.';
      }

      final newUser = AppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
      );

      _users.add(newUser);
      _currentUser = newUser;
      await _storageService.saveUser(newUser);
      
      final success = await _syncService.addUser(newUser);
      if (success) {
        debugPrint("✅ Користувач синхронізований");
      } else {
        debugPrint("⚠️ Не вдалося синхронізувати, але користувач зареєстрований локально");
      }
      
      notifyListeners();
      
      debugPrint("✅ Користувач успішно зареєстрований: ${newUser.name}");
      debugPrint("ℹ️ Користувач буде доступний на всіх пристроях через GitHub Gist");
      return null;
    } catch (e) {
      debugPrint("❌ Помилка реєстрації: $e");
      return 'Виникла помилка реєстрації.';
    }
  }

  Future<void> logout() async {
    debugPrint("🔍 Вихід з системи...");
    _currentUser = null;
    await _storageService.clearUser();
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
        await _storageService.updateUser(user);
        
        final success = await _syncService.updateUser(user);
        if (success) {
          debugPrint("✅ Профіль синхронізований");
        } else {
          debugPrint("⚠️ Не вдалося синхронізувати, але профіль оновлено локально");
        }
        
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

  List<AppUser> getAllUsers() => List.from(_users);
  
  AppUser? getCurrentUser() => _currentUser;
  
}
