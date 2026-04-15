import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAnimatedSwitcher extends GtStatefulWidget {
  final Widget child;
  final int duration;

  const GtAnimatedSwitcher({
    required this.child,
    this.duration = 300,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GtAnimatedSwitcherState();
}

class _GtAnimatedSwitcherState extends State<GtAnimatedSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      duration: Duration(milliseconds: widget.duration),
      child: widget.child,
    );
  }
}
