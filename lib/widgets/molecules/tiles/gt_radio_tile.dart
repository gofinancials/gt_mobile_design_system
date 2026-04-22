import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly customizable list tile containing a [GtRadio] button alongside text and other widgets.
///
/// This widget combines a [GtIndicatorTile] with a [GtRadio] to create a standard selection
/// row. It supports the same standard and conditional selection modes as the standalone radio button.
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

  /// An optional widget (typically an icon or image) to display at the start of the tile.
  final Widget? leading;

  /// The primary text to display in the tile.
  final String title;

  /// Optional secondary text to display below the [title].
  final String? subtitle;

  /// An optional widget to display below the main content of the tile.
  final Widget? footer;

  /// The visual style of the radio button. Defaults to [GtRadioStyle.standard].
  final GtRadioStyle radioStyle;

  /// Creates a standard [GtRadioTile] that compares [value] against [groupValue].
  const GtRadioTile(
    this.title, {
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.radioStyle = .standard,
    this.disabled = false,
    this.footer,
    this.activeColor,
    this.leading,
    this.subtitle,
  }) : condition = null;

  /// Creates a [GtRadioTile] whose active state is directly controlled by [condition].
  const GtRadioTile.conditional(
    this.title, {
    super.key,
    required this.value,
    required this.condition,
    required this.onChanged,
    this.radioStyle = .standard,
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
              style: radioStyle,
            );
          }
          return GtRadio(
            value: value,
            style: radioStyle,
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
