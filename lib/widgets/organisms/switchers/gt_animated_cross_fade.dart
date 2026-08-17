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

    if (animationDuration == Duration.zero) {
      return RepaintBoundary(child: showFirst ? child1 : child2);
    }

    return RepaintBoundary(
      child: AnimatedCrossFade(
        duration: animationDuration,
        alignment: Alignment.center,
        reverseDuration: animationDuration,
        crossFadeState: showFirst ? .showFirst : .showSecond,
        firstCurve: Curves.decelerate,
        secondCurve: Curves.decelerate,
        firstChild: child1,
        secondChild: child2,
      ),
    );
  }
}
