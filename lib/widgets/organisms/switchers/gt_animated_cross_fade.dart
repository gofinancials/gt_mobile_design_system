import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedFade extends GtStatefulWidget {
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
  State<StatefulWidget> createState() => _GtAnimatedFadeState();
}

class _GtAnimatedFadeState extends State<GtAnimatedFade> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: widget.duration.milliseconds,
      alignment: Alignment.center,
      reverseDuration: widget.duration.milliseconds,
      crossFadeState: widget.showFirst
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstCurve: Curves.decelerate,
      secondCurve: Curves.decelerate,
      firstChild: widget.child1,
      secondChild: widget.child2,
    );
  }
}
