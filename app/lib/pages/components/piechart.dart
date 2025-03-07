import 'dart:math';
import 'package:flutter/material.dart';

class SemiCirclePiePainter extends CustomPainter {
  final List<double> values; // Dynamic values for pie chart
  final List<Color> colors = [
    Color(0xffFDA75C),
    Color(0xff7EFCE3),
    Color(0xff7E84FC),
    Color(0xff93DB95),
  ];

  SemiCirclePiePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height);

    double total = values.reduce((a, b) => a + b); // Sum of all values
    if (total == 0) return; // Avoid division by zero

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    double startAngle = -pi; // Start from -180° (left)
    double gapSize = 0.13; // Gap between segments

    for (int i = 0; i < values.length; i++) {
      paint.color = colors[i % colors.length]; // Cycle colors if more than 4

      double percentage = values[i] / total; // Find percentage
      double sweepAngle = (pi * percentage) - gapSize; // Convert to arc

      if (sweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }

      startAngle += sweepAngle + ((gapSize * 3) / 2); // Add spacing
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
