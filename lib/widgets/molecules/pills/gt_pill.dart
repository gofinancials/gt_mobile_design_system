import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the visual variants available for status and button pills.
enum GtPillVariant {
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
extension on GtPillVariant? {
  /// Returns the appropriate text color for the pill variant based on the provided [palette].
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
      .verified => palette.success.dark,
      .away => palette.away.dark,
      _ => palette.text.strong,
    };
  }

  /// Returns the appropriate border color for the pill variant based on the provided [palette].
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
      .verified => palette.success.light,
      .away => palette.away.base,
      _ => palette.bg.sub,
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
      _ => palette.bg.soft,
    };
  }
}

/// Defines the available sizes for pill widgets.
enum GtPillSize {
  /// The standard, default pill size.
  normal,

  /// A slightly larger pill size for better visibility or touch area.
  larger,
}

/// A foundational pill widget that displays text and an optional icon within a rounded container.
class GtPill extends StatelessWidget {
  /// The text to display inside the pill. It will be automatically converted to uppercase.
  final String text;

  /// An optional icon widget to display alongside the text.
  final Widget? icon;

  /// An optional icon widget to display after the text.
  final Widget? trailing;

  /// The internal padding of the pill. Defaults to 4.px on all sides.
  final EdgeInsets? padding;

  /// The background color of the pill.
  final Color bgColor;

  /// The optional border color. If null, the border defaults to [bgColor].
  final Color? borderColor;

  /// The color of the text and potentially the icon (if it inherits the text color).
  final Color? textColor;

  /// The alignment of the child within the pill's container.
  final Alignment? alignment;

  /// Whether to display a drop shadow beneath the pill.
  final bool showShadow;

  /// The visual variant of the pill, determining its contextual colors.
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
      alignment: alignment == null ? .center : null,
      padding: padding ?? context.insets.allDp(4.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? context.borderRadiusSm,
        border: Border.all(color: borderColor ?? bgColor),
        boxShadow: shadow,
      ),
      child: child,
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return child;
  }
}

/// A specialized pill widget used to indicate status, featuring predefined color variants and a compact layout.
class GtStatusPill extends StatelessWidget {
  /// The status text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtPillVariant? variant;

  /// An optional icon data to display. Rendered at size 11.
  final IconData? icon;

  /// An optional icon widget to display after the text.
  final IconData? trailing;

  /// The alignment of the content within the pill.
  final Alignment? alignment;

  /// The size of the status pill.
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

/// A specialized pill widget intended for tags or interactive-looking badges.
///
/// Features slightly larger padding and a larger icon size compared to [GtStatusPill].
class GtButtonPill extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtPillVariant? variant;

  /// An optional icon data to display. Rendered at size 14.
  final IconData? icon;

  /// An optional icon widget to display after the text.
  final IconData? trailing;

  /// The alignment of the content within the pill.
  final Alignment? alignment;

  /// An optional callback triggered when the pill is tapped.
  final OnPressed? onTap;

  /// Whether to display a drop shadow beneath the pill.
  final bool showShadow;

  /// The size of the button pill.
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

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
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

/// A specialized pill widget intended for displaying informational text and badges.
///
/// Features a fully rounded, capsule-like shape and supports custom typography scaling.
class GtInfoPill extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtPillVariant? variant;

  /// An optional icon data to display. Rendered at size 14.
  final IconData? icon;

  /// An optional icon widget to display after the text.
  final IconData? trailing;

  /// The alignment of the content within the pill.
  final Alignment? alignment;

  /// Whether to display a drop shadow beneath the pill.
  final bool showShadow;

  /// Whether to use the display typography style instead of standard body text.
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

/// A specialized pill widget intended for tabbed selections.
///
/// Automatically handles selected and unselected states by comparing the [value]
/// against the [activeValue].
class GtTabPill<T> extends StatelessWidget {
  /// The underlying value represented by this tab.
  final T value;

  /// The currently active/selected value in the tab group.
  final T? activeValue;

  /// The text to display.
  final String text;

  /// The visual variant determining the colors of the pill.
  final GtPillVariant? variant;

  /// An optional icon data to display. Rendered at size 14.
  final IconData? icon;

  /// An optional icon widget to display after the text.
  final IconData? trailing;

  /// The alignment of the content within the pill.
  final Alignment? alignment;

  /// The callback triggered when the tab is selected.
  final OnChanged<T> onSelect;

  /// Creates a [GtTabPill].
  const GtTabPill({
    super.key,
    required this.text,
    required this.value,
    required this.activeValue,
    required this.onSelect,
    this.variant,
    this.icon,
    this.trailing,
    this.alignment = .centerLeft,
  });

  /// Creates a specialized selection variant of the tab pill.
  const factory GtTabPill.selection({
    Key? key,
    required String text,
    required T value,
    required T? activeValue,
    required OnChanged<T> onSelect,
    GtPillVariant variant,
    IconData? icon,
    IconData? trailing,
    Alignment? alignment,
  }) = GtSelectionPill<T>;

  /// Gets the appropriate text color based on the selection state.
  Color getTextColor(GtPalette palette) {
    if (!isSelected) return variant.getTextColor(palette);
    return switch (variant) {
      .neutral => palette.text.darkerSub,
      _ => palette.text.white,
    };
  }

  /// Gets the appropriate background color based on the selection state.
  Color getBgColor(GtPalette palette) {
    if (!isSelected) return variant.getBgColor(palette);
    return switch (variant) {
      .primary => palette.primary.base,
      .neutral => palette.bg.sub,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .error => palette.error.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.success.base,
      .away => palette.away.base,
      _ => palette.bg.strong,
    };
  }

  /// Automatically scrolls this tab into view if it is selected.
  void scrollIntoView(BuildContext context) {
    if (!isSelected) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(context);
    });
  }

  /// Whether this tab is currently the active selected tab.
  bool get isSelected => activeValue == value;

  @override
  Widget build(BuildContext context) {
    scrollIntoView(context);
    final palette = context.palette;
    final textColor = getTextColor(palette);
    final bgColor = getBgColor(palette);
    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 16);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 16);
    }

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: GtPill(
        text: text.upper,
        bgColor: bgColor,
        borderColor: bgColor,
        textStyle: context.textStyles.button2s(color: textColor),
        icon: iconWidget,
        padding: context.insets.symmetricDp(vertical: 8.px, horizontal: 12.px),
        trailing: trailingWidget,
        alignment: alignment,
        variant: variant ?? .strong,
      ),
    );
  }
}

/// A specialized selection pill widget intended for inline selectable items.
///
/// Similar to [GtTabPill], but features distinct unselected styling with a
/// transparent background and modified typography.
class GtSelectionPill<T> extends GtTabPill<T> {
  /// Creates a [GtSelectionPill].
  const GtSelectionPill({
    super.key,
    required super.text,
    required super.value,
    required super.activeValue,
    required super.onSelect,
    super.variant,
    super.icon,
    super.trailing,
    super.alignment = .centerLeft,
  });

  @override
  Color getTextColor(GtPalette palette) {
    if (!isSelected) return palette.text.darkerSub;
    return super.getTextColor(palette);
  }

  @override
  Color getBgColor(GtPalette palette) {
    if (!isSelected) return Colors.transparent;
    return super.getBgColor(palette);
  }

  @override
  Widget build(BuildContext context) {
    scrollIntoView(context);
    final palette = context.palette;
    final textColor = getTextColor(palette);
    final bgColor = getBgColor(palette);
    Widget? iconWidget;
    Widget? trailingWidget;

    if (icon != null) {
      iconWidget = GtIcon.withColor(icon!, color: textColor, size: 16);
    }

    if (trailing != null) {
      trailingWidget = GtIcon.withColor(trailing!, color: textColor, size: 16);
    }

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: GtPill(
        text: text.capitalise(),
        bgColor: bgColor,
        borderColor: bgColor,
        borderRadius: context.borderRadiusMd,
        textStyle: context.textStyles.subHeadS(color: textColor),
        icon: iconWidget,
        padding: context.insets.symmetricDp(vertical: 4.px, horizontal: 12.px),
        trailing: trailingWidget,
        alignment: alignment,
        variant: variant ?? .strong,
      ),
    );
  }
}
