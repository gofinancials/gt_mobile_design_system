import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A custom painter that strokes a raised-glass rim along [shape]'s outline.
///
/// The highlight peaks at the upper-left, where Figma's Liquid Glass light
/// falls at -45°, and again more softly at the lower-right, where it reflects;
/// it fades out entirely between the two. Used by [GtGlassSurface] as a
/// foreground painter, so it draws over whatever fill sits beneath it.
class GtGlassRimPainter extends CustomPainter {
  /// The outline to stroke.
  final ShapeBorder shape;

  /// The highlight colour; always light, since a specular rim doesn't invert
  /// with the theme.
  final Color color;

  /// The rim thickness.
  final double strokeWidth;

  /// The ambient text direction, for direction-aware shapes.
  final TextDirection? textDirection;

  /// Creates a [GtGlassRimPainter].
  const GtGlassRimPainter({
    required this.shape,
    required this.color,
    required this.strokeWidth,
    this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    // Inset by half the stroke so the clip doesn't cut the rim in half.
    final path = shape.getOuterPath(
      bounds.deflate(strokeWidth / 2),
      textDirection: textDirection,
    );
    final lit = color.setOpacity(.85);
    final reflected = color.setOpacity(.6);
    final clear = color.setOpacity(0);
    final edge = Color.lerp(clear, reflected, .5)!;

    // Angles run clockwise from +x: the light peaks at 5π/4 (upper-left), its
    // reflection at π/4 (lower-right), and both fade out at 3π/4 and 7π/4.
    final shader = SweepGradient(
      colors: [edge, reflected, clear, lit, clear, edge],
      stops: const [0, .125, .375, .625, .875, 1],
      endAngle: 2 * math.pi,
    ).createShader(bounds);

    final paint = Paint()
      ..style = .stroke
      ..strokeWidth = strokeWidth
      ..shader = shader;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GtGlassRimPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.textDirection != textDirection;
  }
}
