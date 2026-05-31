import 'package:flutter/material.dart';

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
