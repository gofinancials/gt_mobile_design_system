import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized switch widget used to toggle between on and off states.
///
/// [GtSwitch] wraps a [CupertinoSwitch] and applies the application's design
/// system colors, triggers haptic feedback on toggle, and handles a disabled
/// state using [GtDisabledOverlay].
class GtSwitch extends GtStatelessWidget {
  /// The current state of the switch. If true, the switch is in the "on" position.
  final bool value;

  /// Whether the switch is disabled.
  ///
  /// If true, the switch ignores user interaction and applies a disabled visual state.
  final bool disabled;

  /// Called when the user toggles the switch.
  final OnChanged<bool> onChanged;

  /// An optional focus node to control the focus state of this widget.
  final FocusNode? focusNode;

  /// The color to use when the switch is in the "on" (true) state.
  ///
  /// If null, defaults to the design system's success base color.
  final Color? activeColor;

  /// Creates a [GtSwitch].
  const GtSwitch({
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.disabled = false,
    this.activeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = activeColor ?? palette.success.base;
    final inActiveColor = palette.bg.sub;
    final thumbColor = palette.staticColors.white;
    final computedColor = !value ? inActiveColor : color;

    return GtDisabledOverlay(
      disabled,
      child: CupertinoSwitch(
        value: value,
        onChanged: (value) {
          if (disabled) return;
          HapticFeedback.selectionClick();
          onChanged(value);
        },
        focusNode: focusNode,
        activeTrackColor: color,
        inactiveTrackColor: inActiveColor,
        inactiveThumbColor: thumbColor,
        thumbColor: thumbColor,
        trackOutlineColor: WidgetStatePropertyAll(computedColor),
        trackOutlineWidth: const WidgetStatePropertyAll(0),
      ),
    );
  }
}
