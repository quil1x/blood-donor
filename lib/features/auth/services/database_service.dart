// lib/features/auth/services/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return AppUser.fromJson(docSnapshot.data()!);
      }
    } catch (e) {
      debugPrint("Помилка завантаження профілю: $e");
    }
    return null;
  }

  Future<void> createUserProfile(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      debugPrint("Помилка створення профілю: $e");
    }
  }

  Future<void> updateUserProfile(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      debugPrint("Помилка оновлення профілю: $e");
    }
  }

  Future<List<QuestModel>> getQuests() async {
    try {
      final snapshot = await _firestore.collection('quests').get();
      return snapshot.docs
          .map((doc) => QuestModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Помилка завантаження квестів: $e");
      return [];
    }
  }
}
