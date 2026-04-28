import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A custom painter that draws a horizontal progress bar.
///
/// This painter fills a rounded rectangle proportionally based on the provided
/// [value], allowing for customizable [color], [height], and [borderRadius].
class GtProgressPainter extends CustomPainter {
  /// The color of the progress bar.
  final Color color;

  /// The current progress value, typically between 0.0 and 1.0.
  final double value;

  /// The thickness (height) of the progress bar. Defaults to 6.
  final double height;

  /// The corner radius of the progress bar. Defaults to a fully rounded pill shape.
  final Radius? borderRadius;

  /// Creates a [GtProgressPainter].
  GtProgressPainter({
    required this.color,
    this.value = 0,
    this.height = 6,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = height
      ..style = PaintingStyle.fill;

    double resolvedValue = value > 1 ? 1 : max(value, 0);
    canvas.drawPath(_strokeButt(size, resolvedValue), paint);
  }

  Path _strokeButt(Size size, double value) {
    final path = Path();
    double x = size.width;
    double y = size.height;
    double widthFraction = (x * value);
    path.addRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        widthFraction,
        y,
        topRight: borderRadius ?? 999.radius,
        bottomRight: borderRadius ?? 999.radius,
        topLeft: borderRadius ?? 999.radius,
        bottomLeft: borderRadius ?? 999.radius,
      ),
    );

    return path;
  }

  @override
  bool shouldRepaint(GtProgressPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

/// A custom painter that draws a vertical line down the exact center of its bounds.
///
/// This is often used to create connecting lines between vertical elements,
/// such as the timeline-style separator in money transfer interfaces.
class GtCenterLinePainter extends CustomPainter {
  /// The color of the vertical line.
  final Color color;

  /// Creates a [GtCenterLinePainter].
  GtCenterLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    double x = size.width;
    double y = size.height;
    path.moveTo(x * .5, 0);
    path.lineTo(x * .5, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GtCenterLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
