import 'dart:math';

import 'package:flutter/material.dart';

/// Paints a hollow circular chart (donut) representing a specific value.
class GtPiePainter extends CustomPainter {
  final double value; // Clamped between 0.0 and 1.0
  final Color trackColor;
  final Color valueColor;
  final double strokeWidth;

  GtPiePainter({
    required this.value,
    required this.trackColor,
    required this.valueColor,
    this.strokeWidth = 4.0, // Matches the default spinner width
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Subtract strokeWidth to ensure the ring stays entirely within the bounds
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // 1. Draw the background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw the value slice
    final valuePaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 0.6)
      ..strokeCap = StrokeCap.square; // Added round caps for a polished look

    // Ensure value is between 0 and 1
    final clampedValue = value.clamp(0.0, 1.0);
    final sweepAngle = 2 * pi * clampedValue;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at the top (12 o'clock)
      sweepAngle,
      false, // MUST be false for a hollow ring
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GtPiePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
