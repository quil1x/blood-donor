import 'package:flutter/material.dart';

class QuestModel {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final IconData icon;

  QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.icon,
  });
}
