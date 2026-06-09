import 'dart:math';

import 'package:flutter/material.dart';

/// Paints a hollow circular chart (donut) representing a specific value.
class GtDonutPainter extends CustomPainter {
  final double value; // Clamped between 0.0 and 1.0
  final Color trackColor;
  final Color valueColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final bool clockWise;

  GtDonutPainter({
    required this.value,
    required this.trackColor,
    required this.valueColor,
    this.strokeCap = StrokeCap.round,
    this.clockWise = false,
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
      ..strokeCap = strokeCap
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
      ..strokeCap = strokeCap; // Added round caps for a polished look

    // Ensure value is between 0 and 1
    final clampedValue = value.clamp(0.0, 1.0);
    final sweepAngle = 2 * pi * clampedValue;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at the top (12 o'clock)
      clockWise ? -sweepAngle : sweepAngle,
      false, // MUST be false for a hollow ring
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GtDonutPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Paints a semi-circular arc gauge representing a specific value.
/// The arc starts at the bottom left of the canvas and ends at the bottom right.
class GtArcPainter extends CustomPainter {
  final double value; // Clamped between 0.0 and 1.0
  final Color trackColor;
  final Color valueColor;
  final double strokeWidth;
  final StrokeCap strokeCap;

  GtArcPainter({
    required this.value,
    required this.trackColor,
    required this.valueColor,
    this.strokeCap = StrokeCap.round,
    this.strokeWidth = 34.3, // Matches the default spinner width
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a bounding rectangle where the center is near the bottom of the canvas.
    // The height of the rect is twice the available height to ensure the top half
    // of the arc perfectly fits the canvas while the endpoints rest at the bottom.
    // strokeWidth is subtracted to prevent clipping.
    final rect = Rect.fromCircle(
      center: Offset(size.width * .5, size.height * .5),
      radius: (size.height - strokeWidth) / 2,
    );

    // 1. Draw the background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      rect,
      -pi, // Start at bottom right if clockwise, bottom left otherwise
      pi, // Sweep over the top
      false, // MUST be false for a hollow ring
      trackPaint,
    );

    // 2. Draw the value slice
    final valuePaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 0.6)
      ..strokeCap = strokeCap;

    // Ensure value is between 0 and 1
    final clampedValue = value.clamp(0.0, 1.0);
    final sweepAngle = pi * clampedValue;

    canvas.drawArc(
      rect,
      -pi,
      sweepAngle, // Sweep over the top
      false, // MUST be false for a hollow ring
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GtArcPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
