import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtRadioTile<T> extends GtStatelessWidget {
  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// If this matches [value], the radio button will be drawn as active.
  final T? groupValue;

  /// A direct boolean condition to determine if the radio button is active.
  ///
  /// This is used exclusively when constructed with [GtRadio.conditional].
  final bool? condition;

  /// Called when the user selects this radio button.
  final OnChanged<T> onChanged;

  /// The color to use when the radio button is active.
  ///
  /// If null, defaults to the primary base color from the current palette.
  final Color? activeColor;

  /// Whether the radio button is disabled and non-interactive.
  final bool disabled;

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? footer;

  /// Creates a standard [GtRadio] that compares [value] against [groupValue].
  const GtRadioTile(
    this.title, {
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.disabled = false,
    this.footer,
    this.activeColor,
    this.leading,
    this.subtitle,
  }) : condition = null;

  /// Creates a [GtRadio] whose active state is directly controlled by [condition].
  const GtRadioTile.conditional(
    this.title, {
    super.key,
    required this.value,
    required this.condition,
    required this.onChanged,
    this.activeColor,
    this.footer,
    this.leading,
    this.subtitle,
    this.disabled = false,
  }) : groupValue = null;

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
      trailing: Builder(
        builder: (context) {
          if (condition != null) {
            return GtRadio.conditional(
              value: value,
              condition: condition,
              onChanged: onChanged,
              disabled: disabled,
              activeColor: activeColor,
            );
          }
          return GtRadio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            disabled: disabled,
            activeColor: activeColor,
          );
        },
      ),
    );
  }
}
