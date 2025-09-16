import 'package:flutter/foundation.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class SimpleSyncService {
  
  
  
  Future<List<AppUser>> getUsers() async {
    try {
      debugPrint('🔍 Завантажуємо синхронізованих користувачів...');
      
      
      
      debugPrint('ℹ️ Синхронізація через API не налаштована');
      return [];
    } catch (e) {
      debugPrint('❌ Помилка завантаження: $e');
      return [];
    }
  }
  
  
  Future<bool> saveUsers(List<AppUser> users) async {
    try {
      debugPrint('💾 Зберігаємо користувачів для синхронізації...');
      
      
      debugPrint('ℹ️ Синхронізація через API не налаштована');
      debugPrint('👥 Користувачі для синхронізації:');
      for (final user in users) {
        debugPrint('👤 ${user.name} (${user.email})');
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ Помилка збереження: $e');
      return false;
    }
  }
  
  
  Future<bool> addUser(AppUser user) async {
    debugPrint('➕ Додаємо користувача для синхронізації: ${user.name}');
    return true;
  }
  
  
  Future<bool> updateUser(AppUser user) async {
    debugPrint('🔄 Оновлюємо користувача для синхронізації: ${user.name}');
    return true;
  }
}
