import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized pill widget used to indicate status, featuring predefined color variants and a compact layout.
///
/// Automatically scales padding based on [size] and applies semantic colors using [variant].
class GtStatusPill extends StatelessWidget {
  /// The text indicating the status to display.
  final String text;

  /// The visual variant determining the semantic colors of the pill.
  final GtPillVariant? variant;

  /// An optional leading icon to display alongside the text. Rendered at size 11.
  final IconData? icon;

  /// An optional trailing icon to display after the text. Rendered at size 11.
  final IconData? trailing;

  /// The alignment of the content within the pill.
  final Alignment? alignment;

  /// The size variation of the status pill.
  final GtPillSize size;

  /// Creates a [GtStatusPill].
  const GtStatusPill({
    super.key,
    required this.text,
    this.variant,
    this.trailing,
    this.icon,
    this.alignment,
    this.size = .normal,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final borderColor = variant.getBorderColor(palette);
    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 11);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 11);
    }

    final padding = switch (size) {
      .larger => 6.px,
      _ => 4.px,
    };

    return GtPill(
      text: text.upper,
      bgColor: bgColor,
      icon: iconWidget,
      trailing: trailingWidget,
      textColor: textColor,
      borderColor: borderColor,
      padding: context.insets.allDp(padding),
      alignment: alignment,
      variant: variant ?? .strong,
    );
  }
}
