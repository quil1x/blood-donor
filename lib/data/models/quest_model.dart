// lib/data/models/quest_model.dart

import 'package:flutter/cupertino.dart';

class QuestModel {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final IconData icon;

  const QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.icon,
  });

  // ++ ДОДАЙТЕ ЦЕЙ МЕТОД ++
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    // Проста логіка для визначення іконки за назвою
    IconData getIconByName(String name) {
      switch (name) {
        case 'drop_fill':
          return CupertinoIcons.drop_fill;
        case 'person_2_fill':
          return CupertinoIcons.person_2_fill;
        default:
          return CupertinoIcons.flame;
      }
    }

    return QuestModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rewardPoints: json['rewardPoints'] ?? 0,
      icon: getIconByName(json['iconName'] ?? 'flame'),
    );
  }
}
