import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class SimpleBarChart extends StatelessWidget {
  final List<BarData> data;
  final String title;

  const SimpleBarChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((barData) {
                  final height = (barData.value / maxValue) * 160;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: height,
                        decoration: BoxDecoration(
                          color: barData.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          barData.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarData {
  final String label;
  final double value;
  final Color color;

  const BarData({
    required this.label,
    required this.value,
    required this.color,
  });
}
