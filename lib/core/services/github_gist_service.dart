import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:donor_dashboard/data/models/app_user_model.dart';

class GitHubGistService {
  
  static const String gistId = 'YOUR_GIST_ID_HERE';
  static const String githubToken = 'YOUR_GITHUB_TOKEN_HERE'; 
  
  
  String get gistUrl => 'https://api.github.com/gists/your-gist-id';
  
  
  Future<List<AppUser>> getUsers() async {
    try {
      debugPrint('🔍 Завантажуємо користувачів з GitHub Gist...');
      
      final response = await http.get(
        Uri.parse(gistUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          if (githubToken != 'YOUR_GITHUB_TOKEN_HERE')
            'Authorization': 'token $githubToken',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = data['files'] as Map<String, dynamic>;
        
        if (files.containsKey('users.json')) {
          final usersJson = files['users.json']['content'] as String;
          final usersData = jsonDecode(usersJson);
          final usersList = usersData['users'] as List;
          
          final users = usersList
              .map((userJson) => AppUser.fromJson(userJson))
              .toList();
          
          debugPrint('✅ Завантажено ${users.length} користувачів з Gist');
          return users;
        }
      } else {
        debugPrint('❌ Помилка завантаження Gist: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Помилка: $e');
    }
    
    return [];
  }
  
  
  Future<bool> saveUsers(List<AppUser> users) async {
    try {
      debugPrint('💾 Зберігаємо користувачів в GitHub Gist...');
      
      final usersJson = {
        'users': users.map((user) => user.toJson()).toList(),
      };
      
      final response = await http.patch(
        Uri.parse(gistUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'Content-Type': 'application/json',
          if (githubToken != 'YOUR_GITHUB_TOKEN_HERE')
            'Authorization': 'token $githubToken',
        },
        body: jsonEncode({
          'files': {
            'users.json': {
              'content': jsonEncode(usersJson),
            },
          },
        }),
      );
      
      if (response.statusCode == 200) {
        debugPrint('✅ Користувачі збережені в Gist');
        return true;
      } else {
        debugPrint('❌ Помилка збереження: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Помилка: $e');
      return false;
    }
  }
  
  
  Future<bool> addUser(AppUser user) async {
    final users = await getUsers();
    users.add(user);
    return await saveUsers(users);
  }
  
  
  Future<bool> updateUser(AppUser user) async {
    final users = await getUsers();
    final index = users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      users[index] = user;
      return await saveUsers(users);
    }
    return false;
  }
}
