import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/features/auth/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  final ValueNotifier<AppUser?> currentUserNotifier = ValueNotifier(null);

  // Цей метод викликається один раз при старті застосунку
  void init() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        // Користувач залогінений, завантажуємо його профіль
        final userProfile =
            await _databaseService.getUserProfile(firebaseUser.uid);
        currentUserNotifier.value = userProfile;
      } else {
        // Користувач вийшов з системи
        currentUserNotifier.value = null;
      }
    });
  }

  // Решта методів залишається без змін...
  Future<String?> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return "Не вдалося створити користувача.";

      await firebaseUser.updateDisplayName(name);
      final newUser = AppUser(id: firebaseUser.uid, name: name, email: email);
      await _databaseService.createUserProfile(newUser);
      currentUserNotifier.value = newUser;
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'Пароль занадто слабкий.';
      if (e.code == 'email-already-in-use')
        return 'Акаунт з таким email вже існує.';
      if (e.code == 'invalid-email') return 'Неправильний формат email.';
      return 'Виникла помилка реєстрації.';
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return 'Неправильний email або пароль.';
      }
      if (e.code == 'invalid-email') return 'Неправильний формат email.';
      return 'Виникла помилка входу.';
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
