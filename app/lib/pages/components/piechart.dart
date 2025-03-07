import 'dart:math';

import 'package:flutter/material.dart';

class SemiCirclePiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height);

    final List<Color> colors = [
      Color(0xffFDA75C),
      Color(0xff7EFCE3),
      Color(0xff7E84FC),
      Color(0xff93DB95),
    ];

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13 // Border thickness
      ..strokeCap = StrokeCap.round // Round the edges
      ..strokeJoin = StrokeJoin.round; // Smooth edges

    double startAngle = -pi; // Start from left (-180°)
    double gapSize = 0.13; // Increased gap size
    double sweepAngle = (pi / 4) - gapSize; // Reduce segment width slightly

    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + ((gapSize*3)/2); // Add gap
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}