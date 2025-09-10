import 'package:flutter/material.dart';

class BloodTypeModel {
  final String type;
  final String rarity;
  final int percentage;
  final String description;
  final Color color;

  const BloodTypeModel({
    required this.type,
    required this.rarity,
    required this.percentage,
    required this.description,
    required this.color,
  });
}

class BloodCenterStats {
  final String name;
  final int donations;
  final int capacity;
  final double rating;
  final String address;

  const BloodCenterStats({
    required this.name,
    required this.donations,
    required this.capacity,
    required this.rating,
    required this.address,
  });
}

class BonusTracker {
  final String title;
  final int currentPoints;
  final int maxPoints;
  final String description;
  final bool isCompleted;

  const BonusTracker({
    required this.title,
    required this.currentPoints,
    required this.maxPoints,
    required this.description,
    required this.isCompleted,
  });
}
