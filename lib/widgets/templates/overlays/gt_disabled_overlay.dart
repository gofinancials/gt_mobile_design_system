import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtDisabledOverlay extends GtStatelessWidget {
  final Widget child;
  final bool disabled;
  final double disabledOpacity;

  const GtDisabledOverlay(
    this.disabled, {
    super.key,
    required this.child,
    this.disabledOpacity = .5,
  }) : assert(disabledOpacity >= 0 && disabledOpacity <= 1);

  @override
  Widget build(BuildContext context) {
    if (!disabled) return child;

    return IgnorePointer(
      ignoring: disabled,
      child: AnimatedOpacity(
        duration: 500.milliseconds,
        opacity: disabledOpacity,
        child: child,
      ),
    );
  }
}
