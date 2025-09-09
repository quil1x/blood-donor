// lib/data/models/quest_model.dart

import 'package:flutter/cupertino.dart';

class QuestModel {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final String iconName; // Зберігаємо назву іконки замість IconData

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.iconName,
  });

  // Геттер для отримання IconData
  IconData get icon {
    switch (iconName) {
      case 'drop_fill':
        return CupertinoIcons.drop_fill;
      case 'person_2_fill':
        return CupertinoIcons.person_2_fill;
      case 'map_pin_ellipse':
        return CupertinoIcons.location;
      case 'flame_fill':
        return CupertinoIcons.flame;
      case 'star_fill':
        return CupertinoIcons.star_fill;
      case 'shield_fill':
        return CupertinoIcons.shield_fill;
      case 'share_up':
        return CupertinoIcons.share_up;
      case 'book_fill':
        return CupertinoIcons.book_fill;
      default:
        return CupertinoIcons.flame;
    }
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rewardPoints: json['rewardPoints'] ?? 0,
      iconName: json['iconName'] ?? 'flame',
    );
  }
}
