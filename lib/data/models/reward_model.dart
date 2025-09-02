import 'package:flutter/material.dart';

class RewardModel {
  final String title;
  final String description;
  final int cost;
  final IconData icon;

  RewardModel({
    required this.title,
    required this.description,
    required this.cost,
    required this.icon,
  });
}