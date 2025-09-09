import 'package:donor_dashboard/app.dart';
import 'package:donor_dashboard/features/auth/services/local_auth_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ініціалізуємо локальний сервіс автентифікації
  LocalAuthService().init();

  runApp(const App());
}
