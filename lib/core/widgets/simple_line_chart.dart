import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class SimpleLineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color lineColor;

  const SimpleLineChart({
    super.key,
    required this.data,
    required this.labels,
    this.lineColor = AppColors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: LineChartPainter(
        data: data,
        labels: labels,
        lineColor: lineColor,
        maxValue: maxValue,
        minValue: minValue,
        range: range,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color lineColor;
  final double maxValue;
  final double minValue;
  final double range;

  LineChartPainter({
    required this.data,
    required this.labels,
    required this.lineColor,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.lightBorder
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw data line
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final normalizedValue = (data[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw labels
    for (int i = 0; i < labels.length; i++) {
      final x = size.width * i / (labels.length - 1);
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
