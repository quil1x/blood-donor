// lib/features/auth/services/local_auth_service.dart
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class LocalAuthService extends ChangeNotifier {
  // --- Створюємо єдиний екземпляр сервісу (синглтон) ---
  static final LocalAuthService _instance = LocalAuthService._internal();

  // Фабричний конструктор, який завжди повертає той самий екземпляр
  factory LocalAuthService() {
    return _instance;
  }

  // Приватний конструктор
  LocalAuthService._internal();

  AppUser? _currentUser;
  final StorageService _storageService = StorageService();
  
  // Геттер для отримання поточного користувача
  AppUser? get currentUser => _currentUser;

  // Цей метод викликається один раз при старті застосунку
  Future<void> init() async {
    debugPrint("🔍 Ініціалізуємо локальний AuthService...");
    
    // Завантажуємо користувача з збережених даних
    _currentUser = await _storageService.loadUser();
    
    if (_currentUser != null) {
      debugPrint("✅ Знайдено залогіненого користувача: ${_currentUser!.name}");
    } else {
      debugPrint("ℹ️ Користувач не залогінений");
    }
    
    notifyListeners();
  }

  // Реєстрація користувача
  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔍 Починаємо реєстрацію користувача: $email");
      
      // Валідація пароля
      if (password.length < 6) {
        return 'Пароль занадто слабкий.';
      }

      // Валідація email
      if (!email.contains('@') || !email.contains('.')) {
        return 'Неправильний формат email.';
      }

      // Перевіряємо, чи не існує користувач з таким email
      if (_currentUser != null && _currentUser!.email == email) {
        return 'Акаунт з таким email вже існує.';
      }

      // Створюємо нового користувача
      final newUser = AppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Генеруємо унікальний ID
        name: name,
        email: email,
        password: password, // <-- ОСЬ ТУТ ВИПРАВЛЕННЯ
      );

      // Зберігаємо користувача в пам'яті та в збереженнях
      _currentUser = newUser;
      await _storageService.saveUser(newUser);
      
      debugPrint("✅ Користувач успішно зареєстрований: ${newUser.id}");
      notifyListeners();
      
      return null; // Успішна реєстрація
    } catch (e) {
      debugPrint("❌ Помилка реєстрації: $e");
      return 'Виникла помилка реєстрації.';
    }
  }

  // Логін користувача
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("🔍 Починаємо логін користувача: $email");
      
      // Валідація email
      if (!email.contains('@') || !email.contains('.')) {
        return 'Неправильний формат email.';
      }

      // Шукаємо користувача за email
      if (_currentUser == null || _currentUser!.email != email) {
        debugPrint("❌ Користувач не знайдений: $email");
        return 'Неправильний email або пароль.';
      }

      // Встановлюємо поточного користувача
      await _storageService.saveUser(_currentUser!);
      notifyListeners();
      
      debugPrint("✅ Користувач успішно залогінений: ${_currentUser!.name}");
      return null; // Успішний логін
    } catch (e) {
      debugPrint("❌ Помилка логіну: $e");
      return 'Виникла помилка входу.';
    }
  }

  // Вихід з системи
  Future<void> logout() async {
    debugPrint("🔍 Вихід з системи...");
    _currentUser = null;
    await _storageService.clearUser();
    notifyListeners();
    debugPrint("✅ Користувач вийшов з системи");
  }

  // Оновлення профілю користувача
  Future<bool> updateUserProfile(AppUser user) async {
    try {
      debugPrint("🔄 Починаємо оновлення профілю...");
      debugPrint("📊 Старі дані: балів: ${_currentUser?.totalPoints ?? 0}, квестів: ${_currentUser?.completedQuests.length ?? 0}");
      debugPrint("📊 Нові дані: балів: ${user.totalPoints}, квестів: ${user.completedQuests.length}");
      
      _currentUser = user;
      await _storageService.updateUser(user);
      
      debugPrint("🔄 Сповіщаємо слухачів про зміни...");
      notifyListeners();
      
      debugPrint("✅ Профіль користувача оновлено: ${user.name}, балів: ${user.totalPoints}, квестів: ${user.completedQuests.length}");
      debugPrint("🔄 ChangeNotifier оновлено, слухачі будуть сповіщені");
      
      // Додаткова перевірка
      debugPrint("🔍 Перевірка: _currentUser == user: ${_currentUser == user}");
      debugPrint("🔍 Перевірка: _currentUser.totalPoints: ${_currentUser?.totalPoints}");
      
      return true;
    } catch (e) {
      debugPrint("❌ Помилка оновлення профілю: $e");
      return false;
    }
  }

  // Отримання поточного користувача
  AppUser? getCurrentUser() {
    return _currentUser;
  }

  // Перевірка, чи залогінений користувач
  bool get isLoggedIn => _currentUser != null;
}