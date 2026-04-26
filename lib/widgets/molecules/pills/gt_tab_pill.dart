import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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

  /// The visual variant determining the tab's foundational color structure.
  final GtPillVariant? variant;

  /// An optional leading icon to display alongside the text. Rendered at size 16.
  final IconData? icon;

  /// An optional trailing icon widget to display after the text. Rendered at size 16.
  final IconData? trailing;

  /// The alignment of the tab content within the pill wrapper.
  final Alignment? alignment;

  /// A callback triggered when the user taps to select the tab.
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

  /// Gets the appropriate text color based on the tab's current selection state.
  Color getTextColor(GtPalette palette) {
    if (!isSelected) return variant.getTextColor(palette);
    return switch (variant) {
      .neutral => palette.text.darkerSub,
      _ => palette.text.white,
    };
  }

  /// Gets the appropriate background color based on the tab's current selection state.
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
