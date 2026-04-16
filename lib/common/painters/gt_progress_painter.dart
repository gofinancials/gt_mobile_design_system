import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtProgressPainter extends CustomPainter {
  final Color color;
  final double value;
  final double height;
  final Radius? borderRadius;

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
