import 'package:flutter/material.dart';

/// A custom [ScrollPhysics] that creates an automatic, continuous back-and-forth
/// scrolling effect (ping-pong marquee) when attached to a scrollable widget.
///
/// When the scrollable content exceeds the viewport, it automatically
/// scrolls to the end, pauses briefly, scrolls back to the start, pauses, and
/// repeats continuously.
class GtMarqueeScrollPhysics extends ScrollPhysics {
  /// The constant velocity in pixels per second at which the marquee scrolls.
  ///
  /// Defaults to `20.0`.
  final double marqueeVelocity;

  /// The duration to pause at each boundary (start and end) before reversing direction.
  ///
  /// Defaults to `1200ms` (1.2 seconds).
  final Duration pauseDuration;

  /// Creates a [GtMarqueeScrollPhysics] instance.
  const GtMarqueeScrollPhysics({
    this.marqueeVelocity = 20.0,
    this.pauseDuration = const Duration(milliseconds: 1200),
    super.parent,
  });

  @override
  GtMarqueeScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return GtMarqueeScrollPhysics(
      marqueeVelocity: marqueeVelocity,
      pauseDuration: pauseDuration,
      parent: buildParent(ancestor),
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (newPosition.maxScrollExtent > newPosition.minScrollExtent &&
        !isScrolling &&
        newPosition.pixels == newPosition.minScrollExtent) {
      // Offset by a fractional pixel to kick off ballistic marquee activity on initial layout.
      return newPosition.pixels + 0.001;
    }
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If the content is smaller than or equal to the viewport, no scrolling needed.
    if (position.maxScrollExtent <= position.minScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    final double speed = marqueeVelocity.abs();
    if (speed == 0) return null;

    final double min = position.minScrollExtent;
    final double max = position.maxScrollExtent;
    final double current = position.pixels;

    // Determine target based on current position and velocity.
    double target;
    Duration pause = pauseDuration;

    if (current >= max - 0.5) {
      // At or past the end: reverse and scroll back to the start.
      target = min;
    } else if (current <= min + 0.5) {
      // At or before the start: scroll forward to the end.
      target = max;
    } else if (velocity > 0) {
      // In the middle with positive velocity (e.g. after user drag or continuing forward):
      target = max;
      pause = Duration.zero;
    } else if (velocity < 0) {
      // In the middle with negative velocity:
      target = min;
      pause = Duration.zero;
    } else {
      // In the middle with 0 velocity: target the end
      target = max;
      pause = Duration.zero;
    }

    return _GtMarqueeSimulation(
      start: current,
      end: target,
      velocity: speed,
      pauseDuration: pause,
    );
  }

  @override
  String toString() {
    return 'GtMarqueeScrollPhysics(marqueeVelocity: $marqueeVelocity, pauseDuration: $pauseDuration, parent: $parent)';
  }
}

/// A linear simulation for marquee scrolling that can hold at the starting position
/// for a specified [pauseDuration] before moving at a constant [velocity] to [end].
class _GtMarqueeSimulation extends Simulation {
  _GtMarqueeSimulation({
    required this.start,
    required this.end,
    required this.velocity,
    this.pauseDuration = Duration.zero,
  }) : _distance = (end - start).abs(),
       _direction = end >= start ? 1.0 : -1.0,
       _pauseSeconds = pauseDuration.inMicroseconds / 1000000.0 {
    _scrollSeconds = velocity > 0 ? _distance / velocity : 0.0;
    _totalSeconds = _pauseSeconds + _scrollSeconds;
  }

  final double start;
  final double end;
  final double velocity;
  final Duration pauseDuration;

  final double _distance;
  final double _direction;
  final double _pauseSeconds;
  late final double _scrollSeconds;
  late final double _totalSeconds;

  @override
  double x(double time) {
    if (time <= _pauseSeconds) {
      return start;
    }
    if (time >= _totalSeconds || _scrollSeconds <= 0) {
      return end;
    }
    final double progress = (time - _pauseSeconds) / _scrollSeconds;
    return start + (end - start) * progress;
  }

  @override
  double dx(double time) {
    if (time <= _pauseSeconds || time >= _totalSeconds) {
      return 0.0;
    }
    return _direction * velocity;
  }

  @override
  bool isDone(double time) {
    return time >= _totalSeconds;
  }
}
