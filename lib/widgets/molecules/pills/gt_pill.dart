import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual variants available for status and button pills.
enum GtStatusPillVariant {
  /// A strong emphasis variant, typically using solid, bold colors.
  strong,

  /// A neutral variant, typically using subdued gray or muted tones.
  neutral,

  /// A featured variant, typically used to highlight premium or special items.
  featured,

  /// An informational variant, typically using blue hues.
  info,

  /// A success variant, typically using green hues to indicate positive outcomes.
  success,

  /// A warning variant, typically using yellow or orange hues.
  warning,

  /// An error variant, typically using red hues to indicate failures or critical issues.
  error,

  /// A highlighted variant for general emphasis.
  highlighted,

  /// A stable variant, indicating a steady or unchanged state.
  stable,

  /// A verified variant, often synonymous with success but specifically for validation.
  verified,

  /// An away variant, typically indicating offline or inactive status.
  away,

  /// The primary brand variant.
  primary,
}

/// Internal extension to compute color schemes for pill variants.
extension on GtStatusPillVariant? {
  /// Returns the appropriate text color for the pill variant based on the provided [palette].
  Color getTextColor(GtPalette palette) {
    return switch (this) {
      .primary => palette.primary.dark,
      .neutral => palette.text.sub,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.dark,
      .warning => palette.warning.dark,
      .error => palette.error.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.success.base,
      .away => palette.away.base,
      _ => palette.text.strong,
    };
  }

  /// Returns the appropriate border color for the pill variant based on the provided [palette].
  Color getBorderColor(GtPalette palette) {
    return switch (this) {
      .primary => palette.primary.alpha16,
      .neutral => palette.text.soft,
      .featured => palette.feature.light,
      .info => palette.information.light,
      .success => palette.success.light,
      .warning => palette.warning.light,
      .error => palette.error.light,
      .highlighted => palette.highlighted.light,
      .stable => palette.stable.light,
      .verified => palette.success.light,
      .away => palette.away.light,
      _ => palette.text.strong.setOpacity(0.4),
    };
  }

  /// Returns the appropriate background color for the pill variant based on the provided [palette].
  Color getBgColor(GtPalette palette) {
    return switch (this) {
      .primary => palette.primary.alpha10,
      .neutral => palette.bg.weak,
      .featured => palette.feature.lighter,
      .info => palette.information.lighter,
      .success => palette.success.lighter,
      .warning => palette.warning.lighter,
      .error => palette.error.lighter,
      .highlighted => palette.highlighted.lighter,
      .stable => palette.stable.lighter,
      .verified => palette.success.lighter,
      .away => palette.away.lighter,
      _ => palette.text.strong.setOpacity(0.2),
    };
  }
}

/// A foundational pill widget that displays text and an optional icon within a rounded container.
class GtPill extends StatelessWidget {
  /// The text to display inside the pill. It will be automatically converted to uppercase.
  final String text;

  /// An optional icon widget to display alongside the text.
  final Widget? icon;

  /// The internal padding of the pill. Defaults to 4.px on all sides.
  final EdgeInsets? padding;

  /// The background color of the pill.
  final Color bgColor;

  /// The optional border color. If null, the border defaults to [bgColor].
  final Color? borderColor;

  /// The color of the text and potentially the icon (if it inherits the text color).
  final Color textColor;

  /// Creates a [GtPill].
  const GtPill({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    required this.bgColor,
    this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = GtText(
      text.upper,
      style: context.textStyles.buttonXs(color: textColor),
      textAlign: TextAlign.center,
      maxLines: 1,
    );

    if (icon != null) {
      child = Row(
        spacing: context.spacingSm,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [?icon, child],
      );
    }

    return Container(
      padding: padding ?? context.insets.allDp(4.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: context.borderRadiusSm,
        border: Border.all(color: borderColor ?? bgColor),
      ),
      child: child,
    );
  }
}

/// A specialized pill widget used to indicate status, featuring predefined color variants and a compact layout.
class GtStatusPill extends StatelessWidget {
  /// The status text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtStatusPillVariant? variant;

  /// An optional icon data to display. Rendered at size 11.
  final IconData? icon;

  /// Creates a [GtStatusPill].
  const GtStatusPill({super.key, required this.text, this.variant, this.icon});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);
    final borderColor = variant.getBorderColor(palette);
    Widget? iconWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 11);
    }

    return GtPill(
      text: text,

      bgColor: bgColor,
      icon: iconWidget,
      textColor: textColor,
      borderColor: borderColor,
      padding: context.insets.allDp(4.px),
    );
  }
}

/// A specialized pill widget intended for tags or interactive-looking badges.
///
/// Features slightly larger padding and a larger icon size compared to [GtStatusPill].
class GtButtonPill extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtStatusPillVariant? variant;

  /// An optional icon data to display. Rendered at size 14.
  final IconData? icon;

  /// Creates a [GtButtonPill].
  const GtButtonPill({super.key, required this.text, this.variant, this.icon});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = variant.getTextColor(palette);
    final bgColor = variant.getBgColor(palette);

    Widget? iconWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 14);
    }

    return GtPill(
      text: text,
      bgColor: bgColor,
      icon: iconWidget,
      textColor: textColor,
      padding: context.insets.allDp(6.px),
    );
  }
}
