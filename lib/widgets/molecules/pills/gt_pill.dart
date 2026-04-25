import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual variants available for status, button, and other pills.
/// Each variant determines the background, border, and text colors applied to the pill.
enum GtPillVariant {
  /// A strong emphasis variant, typically using solid, bold brand colors.
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

/// Internal extension to compute color schemes for [GtPillVariant] elements.
extension GtPillExtension on GtPillVariant? {
  /// Returns the appropriate text color for this pill variant based on the provided [palette].
  Color getTextColor(GtPalette palette) {
    return switch (this) {
      .primary => palette.primary.dark,
      .neutral => palette.text.sub,
      .featured => palette.feature.dark,
      .info => palette.information.dark,
      .success => palette.success.dark,
      .warning => palette.warning.dark,
      .error => palette.error.base,
      .highlighted => palette.highlighted.dark,
      .stable => palette.stable.dark,
      .verified => palette.verified.dark,
      .away => palette.away.dark,
      _ => palette.text.strong,
    };
  }

  /// Returns the appropriate border color for this pill variant based on the provided [palette].
  Color getBorderColor(GtPalette palette) {
    return switch (this) {
      .primary => palette.primary.alpha16,
      .neutral => palette.stroke.sub,
      .featured => palette.feature.light,
      .info => palette.information.light,
      .success => palette.success.light,
      .warning => palette.warning.light,
      .error => palette.error.light,
      .highlighted => palette.highlighted.light,
      .stable => palette.stable.light,
      .verified => palette.verified.light,
      .away => palette.away.base,
      _ => palette.bg.sub,
    };
  }

  /// Returns the appropriate background color for this pill variant based on the provided [palette].
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
      .verified => palette.verified.lighter,
      .away => palette.away.lighter,
      _ => palette.bg.soft,
    };
  }
}

/// Defines the available sizes for pill widgets, influencing padding and overall scale.
enum GtPillSize {
  /// The standard, default pill size used in most standard contexts.
  normal,

  /// A slightly larger pill size for better visibility or touch area.
  larger,
}

/// A foundational pill widget that displays text and an optional icon within a rounded container.
///
/// This serves as the base structure for other specialized pills (e.g., [GtStatusPill], [GtButtonPill]).
class GtPill extends StatelessWidget {
  /// The text to display inside the pill. In some implementations, this may be automatically converted to uppercase.
  final String text;

  /// An optional icon widget to display alongside the text.
  final Widget? icon;

  /// An optional icon widget to display after the text.
  final Widget? trailing;

  /// The internal padding of the pill. Defaults to 4 pixels on all sides if not provided.
  final EdgeInsets? padding;

  /// The fill or background color of the pill's container.
  final Color bgColor;

  /// The border color. If null, the border color defaults to the [bgColor], effectively hiding the border.
  final Color? borderColor;

  /// The color of the text. Icons will inherit this color unless overridden.
  final Color? textColor;

  /// The alignment of the content within the pill's internal bounds.
  final Alignment? alignment;

  /// Determines if a drop shadow is rendered beneath the pill container.
  final bool showShadow;

  /// The visual variant that informs context-based color calculations.
  final GtPillVariant variant;

  /// The custom border radius of the pill. Defaults to the theme's small border radius.
  final BorderRadius? borderRadius;

  /// The custom text style for the pill's text.
  final TextStyle? textStyle;

  /// Creates a [GtPill].
  const GtPill({
    super.key,
    required this.text,
    required this.variant,
    this.icon,
    this.trailing,
    this.padding,
    required this.bgColor,
    this.borderColor,
    this.textColor,
    this.alignment,
    this.showShadow = false,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    List<BoxShadow>? shadow;

    if (showShadow) {
      final shadowColor = variant.getTextColor(context.palette);
      shadow = context.shadows.pillShadow(shadowColor);
    }

    Widget child = Text.rich(
      TextSpan(
        children: [
          if (icon != null) ...[
            WidgetSpan(child: icon!),
            WidgetSpan(child: const GtGap.hSm()),
          ],
          TextSpan(text: text),
          if (trailing != null) ...[
            WidgetSpan(child: const GtGap.hSm()),
            WidgetSpan(child: trailing!),
          ],
        ],
        style: textStyle ?? context.textStyles.buttonXs(color: textColor),
      ),
      maxLines: 1,
    );

    child = AnimatedContainer(
      duration: 500.milliseconds,
      padding: padding ?? context.insets.allDp(4.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? context.borderRadiusSm,
        border: Border.all(color: borderColor ?? bgColor),
        boxShadow: shadow,
      ),
      child: child,
    );

    return Align(alignment: alignment ?? .center, child: child);
  }
}
