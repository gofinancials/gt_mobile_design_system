import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A custom painter that draws a dashed border around a given area.
///
/// It supports rounded corners via the [radius] property and allows
/// customization of the stroke color and width.
class GtDashedPainter extends CustomPainter {
  /// The color of the dashed line.
  Color color;

  /// The border radius for the corners. Defaults to 0 for sharp corners.
  double radius;

  /// The width of the dashed line stroke. If null, it defaults to a percentage
  /// of the canvas width.
  double? width;

  /// Creates a [GtDashedPainter] instance.
  GtDashedPainter({required this.color, this.radius = 0, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = width ?? size.width * 0.002
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path topPath = getDashedPath(
      a: math.Point(0 + radius, 0),
      b: math.Point(x - radius, 0),
      gap: size.width * 0.01,
    );

    Path rightPath = getDashedPath(
      a: math.Point(x, 0 + radius),
      b: math.Point(x, y - radius),
      gap: size.width * 0.01,
    );

    Path bottomPath = getDashedPath(
      a: math.Point(0 + radius, y),
      b: math.Point(x - radius, y),
      gap: size.width * 0.01,
    );

    Path leftPath = getDashedPath(
      a: math.Point(0, 0 + radius),
      b: math.Point(0.001, y - radius),
      gap: size.width * 0.01,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);

    if (radius > 0) {
      final double gap = size.width * 0.01;

      Path topLeftArc = getArc(
        a: Offset(0, 0 + radius),
        b: Offset(radius, 0),
        gap: gap,
      );

      Path topRightArc = getArc(
        a: Offset(x - radius, 0),
        b: Offset(x, 0 + radius),
        gap: gap,
      );

      Path bottomRightArc = getArc(
        a: Offset(x, y - radius),
        b: Offset(x - radius, y),
        gap: gap,
      );

      Path bottomLeftArc = getArc(
        a: Offset(0 + radius, y),
        b: Offset(0, y - radius),
        gap: gap,
      );

      canvas.drawPath(topLeftArc, dashedPaint);
      canvas.drawPath(topRightArc, dashedPaint);
      canvas.drawPath(bottomRightArc, dashedPaint);
      canvas.drawPath(bottomLeftArc, dashedPaint);
    }
  }

  /// Calculates a dashed path between two points.
  ///
  /// The [gap] determines the spacing between the dashes.
  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x as double, currentPoint.y as double)
          : path.moveTo(currentPoint.x as double, currentPoint.y as double);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(currentPoint.x + dx, currentPoint.y + dy);
    }
    return path;
  }

  /// Creates an arc path between two corner offsets to form a rounded edge.
  Path getArc({required Offset a, required Offset b, double gap = 0.01}) {
    Path solidPath = Path();
    solidPath.moveTo(a.dx, a.dy);
    solidPath.arcToPoint(b, radius: Radius.circular(radius));

    Path dashedPath = Path();
    for (final metric in solidPath.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + gap),
            Offset.zero,
          );
        }
        distance += gap;
        draw = !draw;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(GtDashedPainter oldDelegate) {
    return false;
  }
}
