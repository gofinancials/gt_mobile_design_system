import 'package:flutter/material.dart';

/// A custom painter that draws a top-to-bottom linear gradient background.
///
/// The gradient starts with the provided [color] at the top and fades to
/// transparent, spanning across the top 40% of the canvas height.
class GtHomeGradientPainter extends CustomPainter {
  /// The starting color of the gradient at the top edge.
  final Color color;

  /// Creates a [GtHomeGradientPainter] with the specified starting [color].
  GtHomeGradientPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height * 0.4);
    // Create a linear gradient from the target color to transparent
    final gradient = LinearGradient(
      colors: [color, Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    // Draw the rectangle; the gradient shader handles the fading effect
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant GtHomeGradientPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
