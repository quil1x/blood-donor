import 'package:donor_dashboard/app.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppUserAdapter());
  await Hive.openBox<AppUser>('users');

  // Ініціалізуємо сервіс ДО запуску додатку
  await AuthService().init();

  runApp(const App());
}
