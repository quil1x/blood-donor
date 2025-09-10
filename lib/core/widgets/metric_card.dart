import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color? iconColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  icon,
                  color: iconColor ?? AppColors.blueAccent,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? CupertinoIcons.arrow_up_right : CupertinoIcons.arrow_down_right,
                  size: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 14,
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
