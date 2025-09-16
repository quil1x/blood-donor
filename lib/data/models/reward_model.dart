import 'package:flutter/material.dart';

enum RewardCategory {
  health,
  entertainment,
  lifestyle,
  food,
  education,
  special
}

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int cost;
  final String iconName;
  final RewardCategory category;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final bool isPopular;
  final bool isNew;
  final int? originalCost;
  final String? partnerName;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.iconName,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
    this.isPopular = false,
    this.isNew = false,
    this.originalCost,
    this.partnerName,
  });

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
      case 'restaurant':
        return Icons.restaurant;
      case 'book':
        return Icons.book;
      case 'spa':
        return Icons.spa;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'flight':
        return Icons.flight;
      case 'hotel':
        return Icons.hotel;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'phone_android':
        return Icons.phone_android;
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'cake':
        return Icons.cake;
      case 'local_pizza':
        return Icons.local_pizza;
      case 'local_drink':
        return Icons.local_drink;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.card_giftcard;
    }
  }

  Color get categoryColor {
    switch (category) {
      case RewardCategory.health:
        return Colors.red;
      case RewardCategory.entertainment:
        return Colors.purple;
      case RewardCategory.lifestyle:
        return Colors.green;
      case RewardCategory.food:
        return Colors.orange;
      case RewardCategory.education:
        return Colors.blue;
      case RewardCategory.special:
        return Colors.amber;
    }
  }

  String get categoryName {
    switch (category) {
      case RewardCategory.health:
        return 'Здоров\'я';
      case RewardCategory.entertainment:
        return 'Розваги';
      case RewardCategory.lifestyle:
        return 'Стиль життя';
      case RewardCategory.food:
        return 'Їжа та напої';
      case RewardCategory.education:
        return 'Освіта';
      case RewardCategory.special:
        return 'Спеціальні';
    }
  }

  double get discountPercentage {
    if (originalCost == null || originalCost! <= cost) return 0.0;
    return ((originalCost! - cost) / originalCost!) * 100;
  }
}
