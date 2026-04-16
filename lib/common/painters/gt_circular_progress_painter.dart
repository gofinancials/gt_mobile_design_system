import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Paints a circular progress indicator with a sweep gradient.
class GtCircularProgressPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  GtCircularProgressPainter({required this.color, this.strokeWidth = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Create a sweep gradient from transparent to the target color
    final gradient = SweepGradient(
      colors: [color.setOpacity(0.0), color],
      stops: const [0.4, 1.0],
      transform: const GradientRotation(-pi / 2), // Start from top
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw a full circle; the gradient shader handles the fading tail effect
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.0,
      pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GtCircularProgressPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
