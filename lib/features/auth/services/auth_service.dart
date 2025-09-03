import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_user_model.dart';

class AuthService {
  // Використовуємо Singleton-патерн для єдиного екземпляру сервісу
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final Box<String> _sessionBox;
  late final Box<AppUser> _usersBox;

  // Ініціалізація сервісу
  Future<void> init() async {
    _sessionBox = await Hive.openBox<String>('session');
    _usersBox = Hive.box<AppUser>('users');
  }

  // Вхід користувача (зберігаємо email як ключ сесії)
  Future<void> login(String email) async {
    await _sessionBox.put('currentUserEmail', email);
  }

  // Вихід користувача
  Future<void> logout() async {
    await _sessionBox.delete('currentUserEmail');
  }

  // Отримуємо поточного користувача
  AppUser? getCurrentUser() {
    final email = _sessionBox.get('currentUserEmail');
    if (email != null) {
      return _usersBox.get(email);
    }
    return null;
  }

  // Перевіряємо, чи користувач увійшов
  bool isLoggedIn() {
    return _sessionBox.containsKey('currentUserEmail');
  }
}