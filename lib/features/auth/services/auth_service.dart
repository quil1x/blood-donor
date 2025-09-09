import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // --- Створюємо єдиний екземпляр сервісу (синглтон) ---
  static final AuthService _instance = AuthService._internal();

  // Фабричний конструктор, який завжди повертає той самий екземпляр
  factory AuthService() {
    return _instance;
  }

  // Приватний конструктор
  AuthService._internal();
  // ---------------------------------------------------------

  final ValueNotifier<AppUser?> currentUserNotifier = ValueNotifier(null);
  AppUser? _currentUser;
  final StorageService _storageService = StorageService();

  // Цей метод викликається один раз при старті застосунку
  Future<void> init() async {
    debugPrint("🔍 Ініціалізуємо AuthService...");
    
    // Завантажуємо користувача з збережених даних
    _currentUser = await _storageService.loadUser();
    
    if (_currentUser != null) {
      debugPrint("✅ Знайдено залогіненого користувача: ${_currentUser!.name}");
      currentUserNotifier.value = _currentUser;
    } else {
      debugPrint("ℹ️ Користувач не залогінений");
      currentUserNotifier.value = null;
    }
  }

  // Реєстрація користувача
  Future<String?> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
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
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );

      // Зберігаємо користувача в пам'яті та в збереженнях
      _currentUser = newUser;
      currentUserNotifier.value = newUser;
      await _storageService.saveUser(newUser);
      
      debugPrint("✅ Користувач успішно зареєстрований: ${newUser.id}");
      return null;
    } catch (e) {
      debugPrint("❌ Помилка реєстрації: $e");
      return 'Виникла помилка реєстрації.';
    }
  }

  // Логін користувача
  Future<String?> login(
      {required String email, required String password}) async {
    try {
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
      currentUserNotifier.value = _currentUser;
      await _storageService.saveUser(_currentUser!);
      
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
    currentUserNotifier.value = null;
    await _storageService.clearUser();
    debugPrint("✅ Користувач вийшов з системи");
  }
}
