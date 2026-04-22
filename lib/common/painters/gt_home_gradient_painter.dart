import 'package:flutter/material.dart';

/// Paints a circular progress indicator with a sweep gradient.
class GtHomeGradientPainter extends CustomPainter {
  final Color color;

  GtHomeGradientPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height * 0.4);
    // Create a sweep gradient from transparent to the target color
    final gradient = LinearGradient(
      colors: [color, Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    // Draw a full circle; the gradient shader handles the fading tail effect
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant GtHomeGradientPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
