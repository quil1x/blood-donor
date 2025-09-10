import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final List<String> tabs;
  final int selectedTab;
  final Function(int) onTabChanged;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Row(
                  children: tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = index == selectedTab;
                    
                    return GestureDetector(
                      onTap: () => onTabChanged(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blueAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }
}
