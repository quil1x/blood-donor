import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class ProfileActionSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? actionText;
  final VoidCallback? onAction;

  const ProfileActionSection({
    super.key,
    required this.title,
    required this.children,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20, 
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              if (actionText != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(
                    actionText!,
                    style: const TextStyle(
                      color: AppColors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        isDesktop 
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: children,
              ),
            )
          : SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: children[index],
                  );
                },
              ),
            ),
      ],
    );
  }
}

class ProfileActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.blueAccent,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
