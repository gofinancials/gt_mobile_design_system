import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';

/// A finite curve backed by Flutter's spring simulation.
class GtSpringCurve extends Curve {
  final SpringDescription spring;
  final Duration settlingDuration;

  const GtSpringCurve({
    required this.spring,
    this.settlingDuration = const Duration(milliseconds: 500),
  });

  @override
  double transformInternal(double t) {
    if (t == 0 || t == 1) return t;
    final simulation = SpringSimulation(spring, 0, 1, 0);
    return simulation.x(t * settlingDuration.inMicroseconds / 1000000);
  }
}

/// Standard spring curves used by interactive components.
abstract final class GtSpringCurves {
  static const Curve bouncy = GtSpringCurve(
    spring: SpringDescription(mass: 1, stiffness: 420, damping: 22),
  );
  static const Curve snappy = GtSpringCurve(
    spring: SpringDescription(mass: 1, stiffness: 520, damping: 34),
    settlingDuration: Duration(milliseconds: 350),
  );
  static const Curve gentle = GtSpringCurve(
    spring: SpringDescription(mass: 1, stiffness: 220, damping: 26),
    settlingDuration: Duration(milliseconds: 600),
  );
  static const Curve interactive = Curves.easeOutCubic;
}
