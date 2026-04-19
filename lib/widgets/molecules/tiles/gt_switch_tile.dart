import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly customizable list tile containing a [GtSwitch] alongside text and other widgets.
///
/// This widget combines a [GtIndicatorTile] with a [GtSwitch] to create a standard
/// toggle row, often used for settings or binary selections. Tapping anywhere on the
/// tile will toggle the switch, provided it is not [disabled].
class GtSwitchTile extends GtStatelessWidget {
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

  /// An optional widget (typically an icon or image) to display at the start of the tile.
  final Widget? leading;

  /// The primary text to display in the tile.
  final String title;

  /// Optional secondary text to display below the [title].
  final String? subtitle;

  /// An optional widget to display below the main content of the tile.
  final Widget? footer;

  /// Creates a [GtSwitchTile].
  const GtSwitchTile(
    this.title, {
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.focusNode,
    this.activeColor,
    this.footer,
    this.leading,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GtIndicatorTile(
      onTap: () {
        if (disabled) return;
        onChanged(!value);
      },
      title,
      subtitle: subtitle,
      icon: leading,
      footer: footer,
      trailing: GtSwitch(
        value: value,
        onChanged: onChanged,
        disabled: disabled,
        activeColor: activeColor,
        focusNode: focusNode,
      ),
    );
  }
}
