import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An [AnimatedSwitcher] that fades and scales between children.
///
/// By default the outgoing child fades out as it shrinks to [beginScale] while
/// the incoming one fades in as it grows from it. With [crossFade] off, the
/// outgoing child is dropped as soon as the switch starts and the incoming one
/// only scales in. Children must carry distinct keys for a swap to animate.
///
/// The duration collapses to zero when the platform asks for reduced motion.
class GtAnimatedSwitcher extends GtStatelessWidget {
  /// The current child.
  final Widget child;

  /// Transition duration in milliseconds, in both directions.
  final int duration;

  /// The scale a child grows from on its way in and shrinks to on its way out.
  final double beginScale;

  /// The curve the incoming child animates along.
  final Curve switchInCurve;

  /// The curve the outgoing child animates along.
  ///
  /// [AnimatedSwitcher] plays this curve in reverse, from 1 to 0, so an
  /// ease-in curve here makes the outgoing child leave quickly.
  final Curve switchOutCurve;

  /// Whether the outgoing child stays on screen, fading out under the
  /// incoming one.
  ///
  /// Turn this off when the two children must never show together, such as a
  /// filled glyph swapping for its outline: even a short crossfade shows the
  /// fill through the outline. The swap is then instant and only the
  /// incoming child's scale animates, so [switchOutCurve] has no effect.
  final bool crossFade;

  /// Creates a [GtAnimatedSwitcher] showing [child].
  const GtAnimatedSwitcher({
    required this.child,
    this.duration = 300,
    this.beginScale = 0,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.crossFade = true,
    super.key,
  }) : assert(beginScale >= 0 && beginScale <= 1);

  @override
  Widget build(BuildContext context) {
    final animationDuration = GtMotion.adaptiveDuration(
      context,
      duration.milliseconds,
    );

    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => _GtSwitcherScaleTransition(
        animation: animation,
        beginScale: beginScale,
        fade: crossFade,
        child: child,
      ),
      layoutBuilder: switch (crossFade) {
        true => AnimatedSwitcher.defaultLayoutBuilder,
        false => _currentChildOnly,
      },
      duration: animationDuration,
      reverseDuration: animationDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: child,
    );
  }

  /// Builds only the incoming child; outgoing children are dropped from the
  /// tree while their switch runs.
  static Widget _currentChildOnly(
    Widget? currentChild,
    List<Widget> previousChildren,
  ) {
    return currentChild ?? const SizedBox.shrink();
  }
}

/// Fades and scales a [GtAnimatedSwitcher] child along [animation].
///
/// [AnimatedSwitcher] stacks the outgoing and incoming children. Scaling
/// alone keeps both fully opaque, so where their shapes differ, such as a
/// filled glyph swapping for its outline, the outgoing child shows through
/// the incoming one. The fade clears it away. Without [fade] only the scale
/// animates, for switchers that never stack their children.
class _GtSwitcherScaleTransition extends GtStatelessWidget {
  /// The child to transition.
  final Widget child;

  /// Runs 0 → 1 as [child] comes in and 1 → 0 as it goes out.
  final Animation<double> animation;

  /// The scale [child] sits at when [animation] is 0.
  final double beginScale;

  /// Whether [child] fades along with its scale.
  final bool fade;

  /// Creates a [_GtSwitcherScaleTransition].
  const _GtSwitcherScaleTransition({
    required this.child,
    required this.animation,
    required this.beginScale,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    final scaled = ScaleTransition(
      scale: Tween<double>(begin: beginScale, end: 1).animate(animation),
      child: child,
    );

    if (!fade) return scaled;

    // Spring curves overshoot past 1; FadeTransition clamps its opacity, so
    // the overshoot only reaches the scale.
    return FadeTransition(opacity: animation, child: scaled);
  }
}
