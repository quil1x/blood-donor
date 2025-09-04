import 'package:donor_dashboard/app.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ініціалізуємо сервіс. Оскільки він синглтон,
  // нам не потрібно передавати його екземпляр далі.
  AuthService().init();

  runApp(const App());
}
