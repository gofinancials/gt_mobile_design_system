import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtCheckBoxTile<T> extends GtStatelessWidget {
  /// The value represented by this checkbox.
  final T value;

  /// Whether this checkbox is currently checked/active.
  final bool isActive;

  /// Called when the checkbox is tapped and the value should change.
  final OnChanged<T> onChanged;

  /// The color to use when the checkbox is active.
  ///
  /// If null, defaults to the primary base color from the current palette.
  final Color? activeColor;

  /// Whether the checkbox is disabled and non-interactive.
  final bool disabled;

  /// The visual shape of the checkbox. Defaults to [GtCheckBoxShape.square].
  final GtCheckBoxShape shape;

  final Widget? leading;
  final Widget? footer;
  final String title;
  final String? subtitle;

  /// Creates a new [GtCheckBox] instance.
  const GtCheckBoxTile(
    this.title, {
    required this.value,
    required this.onChanged,
    required this.isActive,
    this.footer,
    this.disabled = false,
    this.shape = GtCheckBoxShape.square,
    this.activeColor,
    this.leading,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return GtIndicatorTile(
      onTap: () {
        if (disabled) return;
        onChanged(value);
      },
      title,
      subtitle: subtitle,
      icon: leading,
      footer: footer,
      trailing: GtCheckBox(
        value: value,
        onChanged: onChanged,
        isActive: isActive,
        disabled: disabled,
        shape: shape,
        activeColor: activeColor,
      ),
    );
  }
}
