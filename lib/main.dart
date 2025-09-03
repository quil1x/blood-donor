import 'package:donor_dashboard/app.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Переконайтеся, що Flutter ініціалізовано
  WidgetsFlutterBinding.ensureInitialized();

  // Ініціалізуємо Hive у піддиректорії додатку
  await Hive.initFlutter();

  // Реєструємо адаптер для нашої моделі
  Hive.registerAdapter(AppUserAdapter());

  // Відкриваємо "коробку" для зберігання користувачів
  await Hive.openBox<AppUser>('users');

  // Запускаємо додаток
  runApp(const App());
}