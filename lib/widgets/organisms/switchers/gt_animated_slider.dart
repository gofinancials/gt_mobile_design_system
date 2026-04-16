import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedSlider extends GtStatefulWidget {
  final Widget child;
  final int duration;
  final Axis axis;

  const GtAnimatedSlider({
    required this.child,
    this.duration = 300,
    this.axis = Axis.vertical,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GtAnimatedSliderState();
}

class _GtAnimatedSliderState extends State<GtAnimatedSlider> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          axis: widget.axis,
          child: child,
        );
      },
      duration: Duration(milliseconds: widget.duration),
      reverseDuration: Duration(milliseconds: widget.duration),
      child: widget.child,
    );
  }
}
