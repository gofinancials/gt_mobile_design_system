import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a trend line chart connecting a series of values.
/// The line changes color based on the value's corresponding bin.
class GtTrendPainter extends CustomPainter {
  final List<num> values; // Clamped between 0.0 and 1.0
  final LinearGradient? gradient;
  final Color color;
  final Color? selectedFillColor;
  final num? maxValue;
  final int? selectedIndex;

  GtTrendPainter(
    this.values, {
    this.gradient,
    this.maxValue,
    required this.color,
    this.selectedIndex,
    this.selectedFillColor,
  });

  double resolveYCoordinate(num value, num min, num max, num availableHeight) {
    final clampedValue = value.clamp(min, max);
    final valueFraction = 1 - (clampedValue / max);
    return availableHeight * valueFraction;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawPaths(canvas, size);
  }

  void _drawPaths(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = gradient?.createShader(
        Rect.fromLTRB(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    if (values.isEmpty) {
      canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        paint,
      );
      return;
    }

    final sortedValues = [...values]..sort();
    final min = math.min(0, sortedValues.first);
    final max = math.max(sortedValues.last, maxValue ?? 0);

    final segmentWidth = values.length > 1
        ? size.width / (values.length - 1)
        : size.width;

    final path = Path();

    for (final (index, currentValue) in values.indexed) {
      if (index == values.length - 1) break;
      final nextValue = values[index + 1];

      final currentY = resolveYCoordinate(currentValue, min, max, size.height);
      final nextY = resolveYCoordinate(nextValue, min, max, size.height);

      final currentX = segmentWidth * index;
      final nextX = segmentWidth * (index + 1);

      final controlX = currentX + ((nextX - currentX) * 0.5);

      path.moveTo(currentX, currentY);

      path.cubicTo(controlX, currentY, controlX, nextY, nextX, nextY);
    }

    canvas.drawPath(path, paint);

    if (selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < values.length) {
      final value = values[selectedIndex!];
      final currentY = resolveYCoordinate(value, min, max, size.height);
      final currentX = segmentWidth * selectedIndex!;

      canvas.drawCircle(
        Offset(currentX, currentY),
        6,
        Paint()
          ..color = selectedFillColor ?? color
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(currentX, currentY),
        6,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GtTrendPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
