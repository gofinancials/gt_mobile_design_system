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

    // The scope is what makes the disabled state audible: IgnorePointer alone
    // removes the tap action but leaves the control announced as if it were
    // still available. See [GtDisabledScope] for why this is published downward
    // rather than annotated here.
    return GtDisabledScope(
      disabled: disabled,
      child: IgnorePointer(
        ignoring: disabled,
        child: AnimatedOpacity(
          duration: context.motionDuration(500.milliseconds),
          opacity: disabledOpacity,
          child: child,
        ),
      ),
    );
  }
}
