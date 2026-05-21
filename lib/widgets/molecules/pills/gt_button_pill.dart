import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized pill widget intended for tags or interactive-looking badges.
///
/// Features slightly larger padding and a larger icon size compared to [GtStatusPill].
/// Supports tapping interactions by utilizing [onTap].
class GtButtonPill extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The visual variant determining the color scheme of the button pill.
  final GtPillVariant? variant;

  /// An optional leading icon to display. Rendered at size 14.
  final IconData? icon;

  /// An optional trailing icon to display after the text. Rendered at size 14.
  final IconData? trailing;

  /// The alignment of the content within the button pill.
  final Alignment? alignment;

  /// An optional callback triggered when the user taps on the pill.
  final OnPressed? onTap;

  /// Whether to display a drop shadow beneath the button pill to indicate depth.
  final bool showShadow;

  /// The overall size configuration of the button pill.
  final GtPillSize size;

  /// Creates a [GtButtonPill].
  const GtButtonPill({
    super.key,
    required this.text,
    this.variant,
    this.icon,
    this.trailing,
    this.alignment,
    this.onTap,
    this.showShadow = false,
    this.size = .normal,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);

    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 14);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 14);
    }

    final padding = switch (size) {
      .larger => 8.px,
      _ => 6.px,
    };

    return GtInkWell(
      borderRadius: context.borderRadiusSm,
      onTap: onTap,
      child: GtPill(
        text: text.upper,
        bgColor: bgColor,
        borderColor: bgColor,
        icon: iconWidget,
        textColor: textColor,
        padding: context.insets.allDp(padding),
        trailing: trailingWidget,
        alignment: alignment,
        showShadow: showShadow,
        variant: variant ?? .strong,
      ),
    );
  }
}

/// A specialized pill widget designed to copy a specific value to the clipboard when tapped.
///
/// It visually resembles a standard [GtPill] but inherently handles the copy-to-clipboard
/// interaction and provides default text and icon styling.
class GtCopyPill extends GtStatelessWidget {
  /// The underlying value that will be copied to the clipboard when the pill is tapped.
  final String value;

  /// The text to display on the pill. If not provided, defaults to a localized 'copy' string.
  final String? text;

  /// An optional custom leading widget (typically an icon). Defaults to a file copy icon.
  final Widget? leading;

  /// The visual variant determining the color scheme of the pill. Defaults to [GtPillVariant.strong].
  final GtPillVariant variant;

  /// Creates a [GtCopyPill].
  const GtCopyPill(
    this.value, {
    super.key,
    this.text,
    this.leading,
    this.variant = .strong,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final defaultLeading = GtIcon(
      GtIcons.fileFilled,
      size: 13,
      variant: .disabled,
    );

    return GtInkWell(
      borderRadius: context.borderRadiusSm,
      onTap: () {
        context.copyTextToClipboard(value);
      },
      child: GtPill(
        icon: leading ?? defaultLeading,
        text: text?.upper ?? "copy".utr(),
        textStyle: context.textStyles.buttonXxs(color: textColor),
        variant: variant,
        textColor: textColor,
        bgColor: bgColor,
        padding: context.insets.allDp(4.px),
      ),
    );
  }
}
