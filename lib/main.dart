import 'package:donor_dashboard/app.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ініціалізуємо статичний сервіс автентифікації
  await StaticAuthService().init();

  runApp(const App());
}
