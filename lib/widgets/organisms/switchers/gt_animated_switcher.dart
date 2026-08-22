import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedSwitcher extends GtStatelessWidget {
  final Widget child;
  final int duration;
  final double beginScale;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  const GtAnimatedSwitcher({
    required this.child,
    this.duration = 300,
    this.beginScale = 0,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
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
        child: child,
      ),
      duration: animationDuration,
      reverseDuration: animationDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: child,
    );
  }
}

class _GtSwitcherScaleTransition extends GtStatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final double beginScale;

  const _GtSwitcherScaleTransition({
    required this.child,
    required this.animation,
    required this.beginScale,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: beginScale, end: 1).animate(animation),
      child: child,
    );
  }
}
