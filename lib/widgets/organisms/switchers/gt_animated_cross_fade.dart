import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedFade extends GtStatelessWidget {
  final Widget child1;
  final Widget child2;
  final bool showFirst;
  final int duration;

  const GtAnimatedFade({
    required this.child1,
    required this.child2,
    this.showFirst = true,
    this.duration = 500,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animationDuration = GtMotion.adaptiveDuration(
      context,
      duration.milliseconds,
    );

    return RepaintBoundary(
      child: AnimatedCrossFade(
        duration: animationDuration,
        alignment: Alignment.center,
        reverseDuration: animationDuration,
        crossFadeState: showFirst ? .showFirst : .showSecond,
        firstCurve: Curves.decelerate,
        secondCurve: Curves.decelerate,
        firstChild: _GtAnimatedFadeChild(child: child1),
        secondChild: _GtAnimatedFadeChild(child: child2),
      ),
    );
  }
}

/// Preserves the available width when [AnimatedCrossFade] places its top child
/// under loose horizontal constraints.
class _GtAnimatedFadeChild extends GtStatelessWidget {
  final Widget child;

  const _GtAnimatedFadeChild({required this.child});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(widthFactor: 1, child: child);
  }
}
