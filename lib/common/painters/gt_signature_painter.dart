import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Paints the strokes held by a [GtSignaturePadController].
class GtSignaturePainter extends CustomPainter {
  /// Controller that owns the signature strokes and repaint notifications.
  final GtSignaturePadController controller;

  /// Color used to paint the signature.
  final Color strokeColor;

  /// Width of the signature stroke in logical pixels.
  final double strokeWidth;

  /// Creates a signature painter.
  GtSignaturePainter({
    required this.controller,
    required this.strokeColor,
    required this.strokeWidth,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (final stroke in controller.value.strokes) {
      final points = stroke.points;
      if (points.isEmpty) continue;

      if (points.length == 1) {
        canvas.drawCircle(
          points.single,
          strokeWidth / 2,
          paint..style = PaintingStyle.fill,
        );
        paint.style = PaintingStyle.stroke;
        continue;
      }

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var index = 1; index < points.length; index++) {
        final previous = points[index - 1];
        final current = points[index];
        final midpoint = Offset(
          (previous.dx + current.dx) / 2,
          (previous.dy + current.dy) / 2,
        );
        path.quadraticBezierTo(
          previous.dx,
          previous.dy,
          midpoint.dx,
          midpoint.dy,
        );
      }
      path.lineTo(points.last.dx, points.last.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GtSignaturePainter oldDelegate) {
    return oldDelegate.controller != controller ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
