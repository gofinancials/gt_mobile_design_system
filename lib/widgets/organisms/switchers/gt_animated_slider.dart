import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedSlider extends GtStatelessWidget {
  final Widget child;
  final int duration;
  final Axis axis;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  const GtAnimatedSlider({
    required this.child,
    this.duration = 300,
    this.axis = Axis.vertical,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animationDuration = GtMotion.adaptiveDuration(
      context,
      duration.milliseconds,
    );

    return AnimatedSwitcher(
      transitionBuilder: (child, animation) =>
          _GtSliderTransition(animation: animation, axis: axis, child: child),
      duration: animationDuration,
      reverseDuration: animationDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: child,
    );
  }
}

class _GtSliderTransition extends GtStatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Axis axis;

  const _GtSliderTransition({
    required this.child,
    required this.animation,
    required this.axis,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(sizeFactor: animation, axis: axis, child: child);
  }
}
