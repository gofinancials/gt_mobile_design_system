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

  /// The accessible name announced for this switch.
  ///
  /// [CupertinoSwitch] publishes the on/off state on its own, but nothing
  /// names the control. Without a label the user hears "on" with no indication
  /// of what is on.
  final String? semanticsLabel;

  /// A description of what toggling this switch does.
  final String? semanticHint;

  /// Creates a [GtSwitch].
  const GtSwitch({
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.disabled = false,
    this.activeColor,
    this.semanticsLabel,
    this.semanticHint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = activeColor ?? palette.success.base;
    final inActiveColor = palette.bg.sub;
    final thumbColor = palette.staticColors.white;
    final computedColor = !value ? inActiveColor : color;

    return RepaintBoundary(
      child: GtDisabledOverlay(
        disabled,
        child: GtSemantics(
          // CupertinoSwitch publishes its own toggled and enabled state, so
          // this annotation contributes only the name it lacks. See
          // [GtSemanticRole.delegated].
          role: .delegated,
          label: semanticsLabel,
          hint: semanticHint,
          // CupertinoSwitch is focusable, and a focusable node does not fold
          // into an enclosing annotation on its own. Without merging, the name
          // and the switch are two separate stops for the user.
          mergeDescendants: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.dp(28.px)),
            child: CupertinoSwitch(
              value: value,
              // A null callback is what makes CupertinoSwitch announce itself
              // as disabled. Swallowing the callback instead left the control
              // announced as available while doing nothing when activated.
              onChanged: disabled
                  ? null
                  : (value) {
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
          ),
        ),
      ),
    );
  }
}
