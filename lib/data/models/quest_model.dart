import 'package:flutter/material.dart';

class QuestModel {
  final String title;
  final String description;
  final int rewardPoints;
  double progress;
  final IconData icon;

  QuestModel({
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.progress,
    required this.icon,
  });
}