import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the styling for a [GtTabPill], allowing for custom color
/// configurations for both active and inactive states.
class GtTabPillStyle {
  /// The text color for the pill when it is in an inactive state.
  final Color? textColor;

  /// The background color for the pill when it is in an inactive state.
  final Color? bgColor;

  /// The text color for the pill when it is in an active (selected) state.
  final Color? activeTextColor;

  /// The visual variant of the pill, which determines default color treatments.
  final GtPillVariant? variant;

  /// The background color for the pill when it is in an active (selected) state.
  final Color? activeBgColor;

  /// Creates a style configuration for a [GtTabPill].
  const GtTabPillStyle({
    this.variant,
    this.textColor,
    this.bgColor,
    this.activeTextColor,
    this.activeBgColor,
  });
}

/// A specialized pill widget intended for tabbed selections.
///
/// Automatically toggles styles between selected and unselected states by comparing
/// the [value] against the [activeValue]. Triggers an automatic scroll into view when selected.
class GtTabPill<T> extends StatelessWidget {
  /// The unique underlying value represented by this tab pill.
  final T value;

  /// The currently active/selected value in the broader tab group.
  final T? activeValue;

  /// The primary tab text to display.
  final String text;

  /// The visual variant of the pill, which determines default color treatments.
  final GtPillVariant? variant;

  /// An optional leading icon to display alongside the text. Rendered at size 16.
  final IconData? icon;

  /// An optional trailing icon widget to display after the text. Rendered at size 16.
  final IconData? trailing;

  /// The alignment of the tab content within the pill wrapper.
  final Alignment? alignment;

  /// A callback triggered when the user taps to select the tab.
  final OnChanged<T> onSelect;

  /// The style configuration for this tab pill, allowing for custom color overrides.
  final GtTabPillStyle? style;

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
    this.style,
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
    GtTabPillStyle? style,
  }) = GtSelectionPill<T>;

  GtPillVariant get effectiveVariant => style?.variant ?? variant ?? .strong;

  /// Gets the appropriate text color based on the tab's current selection state.
  Color getTextColor(GtPalette palette) {
    if (!isSelected) {
      return style?.textColor ?? effectiveVariant.getTextColor(palette);
    }
    final activeColor = switch (effectiveVariant) {
      .neutral => palette.text.darkerSub,
      _ => palette.text.white,
    };
    return style?.activeTextColor ?? activeColor;
  }

  /// Gets the appropriate background color based on the tab's current selection state.
  Color getBgColor(GtPalette palette) {
    if (!isSelected) {
      return style?.bgColor ?? effectiveVariant.getBgColor(palette);
    }
    final activeColor = switch (effectiveVariant) {
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
    return style?.activeBgColor ?? activeColor;
  }

  /// Indicates whether this specific tab represents the active selected item.
  bool get isSelected => activeValue == value;

  @override
  Widget build(BuildContext context) {
    if (isSelected) context.scrollIntoView();
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

    return GtInkWell(
      borderRadius: context.borderRadiusSm,
      hapticFeedbackType: .selection,
      onTap: () => onSelect(value),
      child: GtPill(
        text: text.upper,
        bgColor: bgColor,
        constraints: const BoxConstraints(minHeight: 32),
        borderStyle: .none,
        textStyle: context.textStyles.button2s(color: textColor),
        icon: iconWidget,
        padding: context.insets.symmetricDp(vertical: 8.px, horizontal: 12.px),
        trailing: trailingWidget,
        alignment: alignment,
        variant: effectiveVariant,
      ),
    );
  }
}

/// A specialized selection pill widget intended for inline selectable items.
///
/// Similar to [GtTabPill], but features distinct unselected styling with a completely
/// transparent background and modified typography treatments.
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
    super.style,
  });

  @override
  Color getTextColor(GtPalette palette) {
    if (!isSelected) {
      return style?.textColor ?? palette.text.darkerSub;
    }
    final activeColor = super.getTextColor(palette);
    return style?.activeTextColor ?? activeColor;
  }

  @override
  Color getBgColor(GtPalette palette) {
    if (!isSelected) {
      return style?.bgColor ?? Colors.transparent;
    }
    final activeColor = super.getBgColor(palette);
    return style?.activeBgColor ?? activeColor;
  }

  @override
  Widget build(BuildContext context) {
    if (isSelected) context.scrollIntoView();
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

    return GtInkWell(
      borderRadius: context.borderRadiusMd,
      hapticFeedbackType: .selection,
      onTap: () => onSelect(value),
      child: GtPill(
        text: text.capitalise(),
        bgColor: bgColor,
        borderStyle: .none,
        borderRadius: context.borderRadiusMd,
        textStyle: context.textStyles.subHeadS(color: textColor),
        icon: iconWidget,
        padding: context.insets.symmetricDp(vertical: 4.px, horizontal: 12.px),
        trailing: trailingWidget,
        alignment: alignment,
        variant: effectiveVariant,
      ),
    );
  }
}
