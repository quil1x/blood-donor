import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class ProfileQuestCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ProfileQuestCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDesktop ? 140 : 120,
        height: isDesktop ? 120 : 100,
        margin: EdgeInsets.only(
          right: isDesktop ? 0 : 16,
          bottom: isDesktop ? 0 : 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isDesktop ? 50 : 40,
              height: isDesktop ? 50 : 40,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppColors.blueAccent.withValues(alpha: 0.1)
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(isDesktop ? 25 : 20),
              ),
              child: Icon(
                icon,
                color: isCompleted ? AppColors.blueAccent : AppColors.lightTextSecondary,
                size: isDesktop ? 24 : 20,
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppColors.blueAccent : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: isDesktop ? 12 : 10,
                  color: AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
