import 'package:flutter/material.dart';

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int cost;
  final String iconName;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.iconName,
  });

  // Геттер для отримання IconData
  IconData get icon {
    switch (iconName) {
      case 'science_outlined':
        return Icons.science_outlined;
      case 'ticket_fill':
        return Icons.confirmation_number;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'coffee':
        return Icons.local_cafe;
      default:
        return Icons.card_giftcard;
    }
  }
}