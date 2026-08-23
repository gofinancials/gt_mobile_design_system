import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized pill widget intended for displaying informational text and badges.
///
/// Features a fully rounded, capsule-like shape and supports custom typography scaling.
/// Use [useDisplayFont] to swap standard body typography for larger display styles.
class GtInfoPill extends GtStatelessWidget {
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

  /// An alternative accessibility label for the informational content.
  final String? semanticsLabel;

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
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final verticalPadding = useDisplayFont ? 4.px : 2.px;
    TextStyle style = context.textStyles.bodyS(color: textColor);

    if (useDisplayFont) {
      style = context.textStyles.buttonXs(color: textColor);
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
      semanticsLabel: semanticsLabel,
    );
  }
}

/// A specialized pill widget intended for toast notifications and floating feedback banners.
///
/// Features a fully rounded, capsule-like shape with high-contrast filled backgrounds,
/// prominent text styling, and an integrated drop shadow for clear visibility over app content.
class GtToastPill extends GtStatelessWidget {
  /// The message or notification text to display.
  final String text;

  /// The visual variant determining the background and text color of the toast pill.
  final GtPillVariant? variant;

  /// An optional leading icon to display alongside the text. Rendered at size 18.
  final IconData? icon;

  /// An optional trailing icon widget to display after the text. Rendered at size 18.
  final IconData? trailing;

  /// The internal alignment of the content within the pill.
  final Alignment? alignment;

  /// An alternative accessibility label for the toast notification content.
  final String? semanticsLabel;

  /// Creates a [GtToastPill].
  const GtToastPill({
    super.key,
    required this.text,
    this.variant,
    this.icon,
    this.trailing,
    this.alignment,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = switch (variant) {
      .primary => palette.staticColors.white,
      _ => palette.text.white,
    };

    final bgColor = switch (variant) {
      .primary => palette.primary.darker,
      .neutral => palette.bg.surface,
      .featured => palette.feature.darker,
      .info => palette.information.darker,
      .success => palette.success.darker,
      .warning => palette.warning.darker,
      .error => palette.error.darker,
      .highlighted => palette.highlighted.darker,
      .stable => palette.stable.darker,
      .verified => palette.verified.darker,
      .away => palette.away.darker,
      _ => palette.bg.strong,
    };
    final style = context.textStyles.button2s(color: textColor);

    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 18);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 18);
    }

    return GtPill(
      text: text.upper,
      bgColor: bgColor,
      borderColor: bgColor,
      icon: iconWidget,
      borderRadius: context.borderRadius4Xl,
      textStyle: style,
      padding: context.insets.symmetricDp(vertical: 4.px, horizontal: 8.px),
      trailing: trailingWidget,
      alignment: alignment,
      showShadow: true,
      variant: variant ?? .strong,
      semanticsLabel: semanticsLabel,
    );
  }
}
