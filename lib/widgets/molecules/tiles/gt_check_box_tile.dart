import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly customizable list tile containing a [GtCheckBox] alongside text and other widgets.
///
/// This widget combines a [GtIndicatorTile] with a [GtCheckBox] to create a standard
/// selection row. Tapping anywhere on the tile will trigger the [onChanged] callback
/// with the associated [value], provided it is not [disabled].
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

  /// An optional widget (typically an icon or image) to display at the start of the tile.
  ///
  /// When [indicatorPosition] is [GtIndicatorPosition.leading], it follows the
  /// checkbox, so the row reads checkbox, [leading], [title].
  final Widget? leading;

  /// Where the checkbox sits relative to the [title]. Defaults to
  /// [GtIndicatorPosition.trailing].
  final GtIndicatorPosition indicatorPosition;

  /// Horizontal gap between the tile's checkbox, [leading] and [title], in
  /// **design pixels**.
  ///
  /// When `null`, uses [BuildContext.spacingLg] (~16dp). Otherwise passed
  /// through [BuildContext.dp] via [num.px].
  final double? spacingPx;

  /// An optional widget to display below the main content of the tile.
  final Widget? footer;

  /// The primary text to display in the tile.
  final String title;

  /// Optional secondary text to display below the [title].
  final String? subtitle;

  /// Custom padding to apply to the tile.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Creates a [GtCheckBoxTile].
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
    this.padding,
    super.key,
    this.titleStyle,
    this.subtitleStyle,
    this.indicatorPosition = GtIndicatorPosition.trailing,
    this.spacingPx,
  });

  @override
  Widget build(BuildContext context) {
    final checkBox = GtCheckBox(
      value: value,
      onChanged: onChanged,
      isActive: isActive,
      disabled: disabled,
      shape: shape,
      activeColor: activeColor,
    );

    Widget? icon = leading;
    Widget? trailing = checkBox;

    if (indicatorPosition == .leading) {
      icon = checkBox;
      trailing = null;

      if (leading != null) {
        final gapPx = spacingPx;
        icon = Row(
          mainAxisSize: .min,
          spacing: gapPx == null ? context.spacingLg : context.dp(gapPx.px),
          children: [checkBox, ?leading],
        );
      }
    }

    return GtIndicatorTile(
      onTap: () {
        if (disabled) return;
        onChanged(value);
      },
      padding: padding,
      title,
      subtitle: subtitle,
      icon: icon,
      footer: footer,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      trailing: trailing,
      spacingPx: spacingPx,
    );
  }
}
