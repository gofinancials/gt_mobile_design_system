import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized pill widget intended for displaying informational text and badges.
///
/// Features a fully rounded, capsule-like shape and supports custom typography scaling.
/// Use [useDisplayFont] to swap standard body typography for larger display styles.
class GtInfoPill extends StatelessWidget {
  /// The informational text to display.
  final String text;

  /// The visual variant determining the color palette of the informational pill.
  final GtPillVariant? variant;

  /// An optional leading icon to display alongside the text. Rendered at size 18.
  final IconData? icon;

  /// An optional trailing icon widget to display after the text. Rendered at size 18.
  final IconData? trailing;

  /// The internal alignment of the content within the pill.
  final Alignment? alignment;

  /// Whether to display a subtle drop shadow beneath the informational pill.
  final bool showShadow;

  /// Whether to apply a display-level font style rather than standard body text styles.
  final bool useDisplayFont;

  /// Creates a [GtInfoPill].
  const GtInfoPill({
    super.key,
    required this.text,
    this.variant,
    this.icon,
    this.trailing,
    this.alignment,
    this.showShadow = false,
    this.useDisplayFont = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final verticalPadding = useDisplayFont ? 4.px : 2.px;
    TextStyle style = context.textStyles.bodyS(color: textColor);

    if (useDisplayFont) {
      style = context.textStyles.titleXs(color: textColor);
    }

    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 18);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 18);
    }

    return GtPill(
      text: text,
      bgColor: bgColor,
      borderColor: bgColor,
      icon: iconWidget,
      borderRadius: context.borderRadius4Xl,
      textStyle: style,
      padding: context.insets.symmetricDp(
        vertical: verticalPadding,
        horizontal: 8.px,
      ),
      trailing: trailingWidget,
      alignment: alignment,
      showShadow: showShadow,
      variant: variant ?? .strong,
    );
  }
}