import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final bool isHighlighted;

  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.lightTextPrimary,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                color: isHighlighted ? Colors.white : AppColors.blueAccent,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
