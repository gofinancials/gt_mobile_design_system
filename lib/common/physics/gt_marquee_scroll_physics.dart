import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class GtMarqueeScrollPhysics extends ScrollPhysics {
  final double marqueeVelocity;

  const GtMarqueeScrollPhysics({this.marqueeVelocity = 10, super.parent});

  @override
  GtMarqueeScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return GtMarqueeScrollPhysics(
      marqueeVelocity: marqueeVelocity,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position.maxScrollExtent <= position.minScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    if (position.pixels >= position.maxScrollExtent) {
      const spring = SpringDescription(mass: 1, stiffness: 0.5, damping: 1);

      return SpringSimulation(spring, position.pixels, 0, 1);
    }

    return GravitySimulation(
      1,
      position.pixels,
      position.maxScrollExtent,
      marqueeVelocity.abs(),
    );
  }

  @override
  String toString() {
    return 'MarqueeScrollPhysics(marqueeVelocity: $marqueeVelocity, parent: $parent)';
  }
}
