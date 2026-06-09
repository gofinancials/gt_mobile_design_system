import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

class GtTrendBin extends AppEquatable {
  final double min;
  final double max;
  final Color color;

  const GtTrendBin({required this.min, required this.max, required this.color});

  @override
  List<Object?> get props => [min, max, color];
}

class GtTrendBins extends AppEquatable {
  final GtTrendBin low;
  final GtTrendBin mid;
  final GtTrendBin high;

  const GtTrendBins({required this.low, required this.mid, required this.high});

  const GtTrendBins.defaultBins()
    : low = const GtTrendBin(min: 0, max: 100000, color: Color(0xFFCB0828)),
      mid = const GtTrendBin(
        min: 100000,
        max: 200000,
        color: Color(0xFFF6B51E),
      ),
      high = const GtTrendBin(
        min: 200000,
        max: .infinity,
        color: Color(0xFF1DAF61),
      );

  GtTrendBin getBinForValue(double value) {
    return switch (value) {
      double v when v >= mid.min && v <= mid.max => mid,
      double v when v >= high.min && v <= high.max => high,
      _ => low,
    };
  }

  @override
  List<Object?> get props => [low, mid, high];
}

/// Paints a trend line chart connecting a series of values.
/// The line changes color based on the value's corresponding bin.
class GtTrendPainter extends CustomPainter {
  final List<double> values; // Clamped between 0.0 and 1.0
  final GtTrendBins bins;

  GtTrendPainter({
    required this.values,
    this.bins = const GtTrendBins.defaultBins(),
  });

  double resolveYCoordinate(double value, double max, double availableHeight) {
    // If all values are the same, draw the line perfectly in the vertical center
    if (values.isEmpty) return availableHeight * 0.5;

    final clampedValue = value.clamp(0, max);
    final valueFraction = clampedValue / max;

    // Multiply by availableHeight to map to pixels, and invert because Canvas Y=0 is at the top
    return availableHeight - (valueFraction * availableHeight);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawPaths(canvas, size);
  }

  void _drawPaths(Canvas canvas, Size size) {
    if (values.isEmpty) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = bins.low.color
        ..strokeWidth = 3
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5),
        paint,
      );
      return;
    }

    // Explicitly copy and sort to find min and max without mutating the original sequential data
    final sortedValues = [...values]..sort();
    final max = sortedValues.last;

    // Use length - 1 so the segments stretch fully from left (0) to right (size.width)
    final segmentWidth = values.length > 1
        ? size.width / (values.length - 1)
        : size.width;

    for (final (index, currentValue) in values.indexed) {
      // Stop before the last element because each iteration draws a segment connecting to the next value
      if (index == values.length - 1) break;

      final nextValue = values[index + 1];

      final currentY = resolveYCoordinate(currentValue, max, size.height);
      final nextY = resolveYCoordinate(nextValue, max, size.height);

      final currentX = segmentWidth * index;
      final nextX = segmentWidth * (index + 1);

      final bin = bins.getBinForValue(currentValue);

      _drawSegment(
        (startY: currentY, endY: nextY),
        (startX: currentX, endX: nextX),
        bin,
        canvas,
      );
    }
  }

  void _drawSegment(
    ({double startY, double endY}) yRange,
    ({double startX, double endX}) xRange,
    GtTrendBin bin,
    Canvas canvas,
  ) {
    final paint = Paint()
      ..style = .stroke
      ..color = bin.color
      ..strokeWidth = 3
      ..strokeCap = .round
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(xRange.startX, yRange.startY);

    // Explicit control points for a smooth cubic bezier curve
    // Placing the control points horizontally halfway between startX and endX
    final controlX = xRange.startX + ((xRange.endX - xRange.startX) * 0.5);

    path.cubicTo(
      controlX,
      yRange.startY,
      controlX,
      yRange.endY,
      xRange.endX,
      yRange.endY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GtTrendPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.bins != bins;
  }
}
