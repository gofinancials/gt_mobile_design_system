import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A custom [ScrollPhysics] that creates an automatic, continuous scrolling
/// effect (like a marquee) when attached to a scrollable widget.
///
/// Once the scroll position reaches the [maxScrollExtent], it snaps back
/// to the beginning using a spring simulation, creating an infinite loop effect.
class GtMarqueeScrollPhysics extends ScrollPhysics {
  /// The constant velocity at which the marquee scrolls.
  ///
  /// A higher value results in faster scrolling. The absolute value of this
  /// velocity is used for the continuous scroll simulation. Defaults to `10`.
  final double marqueeVelocity;

  /// Creates a [GtMarqueeScrollPhysics] instance.
  ///
  /// The [marqueeVelocity] dictates the speed of the scroll, and [parent]
  /// is an optional parent [ScrollPhysics] to inherit behavior from.
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
    // If the content is smaller than the viewport, fall back to default behavior.
    if (position.maxScrollExtent <= position.minScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    // If we've reached or exceeded the end of the scrollable area,
    // spring back to the beginning (0) to create a continuous loop.
    if (position.pixels >= position.maxScrollExtent) {
      const spring = SpringDescription(mass: 1, stiffness: 0.5, damping: 1);

      return SpringSimulation(spring, position.pixels, 0, 1);
    }

    // Otherwise, apply a constant gravity-like velocity towards the max scroll extent.
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
