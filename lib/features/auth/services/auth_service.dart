import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final Box<String> _sessionBox;
  late final Box<AppUser> _usersBox;

  // --- ДОДАНО: Центральний слухач змін ---
  // Цей об'єкт буде зберігати поточного користувача і сповіщати всіх, хто на нього підписаний.
  final ValueNotifier<AppUser?> currentUserNotifier = ValueNotifier(null);

  Future<void> init() async {
    _sessionBox = await Hive.openBox<String>('session');
    _usersBox = Hive.box<AppUser>('users');
    _loadCurrentUser();
  }

  // Завантажує користувача з Hive і оновлює слухач
  void _loadCurrentUser() {
    final email = _sessionBox.get('currentUserEmail');
    if (email != null) {
      final user = _usersBox.get(email);
      currentUserNotifier.value = user;
    } else {
      currentUserNotifier.value = null;
    }
  }

  Future<void> login(String email) async {
    await _sessionBox.put('currentUserEmail', email);
    _loadCurrentUser();
  }

  Future<void> logout() async {
    await _sessionBox.delete('currentUserEmail');
    _loadCurrentUser();
  }

  // Оновлений метод для збереження змін
  void updateUser(AppUser user) {
    user.save();
    // Створюємо копію об'єкта, щоб ValueNotifier точно зафіксував зміну
    currentUserNotifier.value = AppUser(
      email: user.email,
      name: user.name,
      password: user.password,
      totalDonations: user.totalDonations,
      livesSaved: user.livesSaved,
      totalPoints: user.totalPoints,
      completedQuests: Map<String, DateTime>.from(user.completedQuests),
    );
  }

  AppUser? getCurrentUser() {
    return currentUserNotifier.value;
  }

  bool isLoggedIn() {
    return _sessionBox.containsKey('currentUserEmail');
  }
}
