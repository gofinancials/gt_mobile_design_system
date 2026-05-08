import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile designed to display a descriptive label and its corresponding text value.
///
/// This widget is commonly used for summarizing form inputs, displaying read-only
/// account information, or presenting key-value pairs in a clean, vertical layout.
///
/// It can be rendered as a standalone tile or wrapped in a stylized card using
/// the [GtInputListTile.asCard] constructor.
///
/// {@category Molecules}
class GtInputListTile extends GtStatelessWidget {
  /// The primary label or title for the information being displayed.
  final String label;

  /// The main text value or data associated with the [label].
  final String text;

  /// An optional widget, typically an icon, displayed at the start of the tile.
  final Widget? leading;

  /// A callback triggered when the tile is tapped.
  ///
  /// If provided, the tile becomes interactive and provides haptic feedback.
  final OnPressed? onTap;

  /// Optional custom [TextStyle] for the [text].
  ///
  /// If null, defaults to [GtTextStyles.subHeadS].
  final TextStyle? textStyle;

  /// Optional custom [TextStyle] for the [label].
  ///
  /// If null, defaults to [GtTextStyles.bodyXs] with a subtle color.
  final TextStyle? labelStyle;

  /// Internal flag to determine if the tile should be wrapped in a [GtCard].
  final bool _asCard;

  /// Creates a standard [GtInputListTile] without a card container.
  const GtInputListTile(
    this.label, {
    super.key,
    required this.text,
    this.leading,
    this.labelStyle,
    this.textStyle,
    this.onTap,
  }) : _asCard = false;

  /// Creates a [GtInputListTile] that is automatically wrapped in a [GtCard].
  const GtInputListTile.asCard(
    this.label, {
    super.key,
    required this.text,
    this.leading,
    this.textStyle,
    this.labelStyle,
    this.onTap,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? context.textStyles.subHeadS();
    final hintStyle = (labelStyle ?? context.textStyles.bodyXs()).copyWith(
      color: context.palette.text.sub,
    );

    Widget child = Column(
      spacing: context.spacingSm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtText(label, style: hintStyle),
        GtText(text, style: style),
      ],
    );

    if (leading != null) {
      child = Row(
        spacing: context.spacingBase,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tight(Size.square(20)),
            child: leading,
          ),
          Expanded(child: child),
        ],
      );
    }

    if (_asCard) {
      child = GtCard(borderRadius: context.borderRadiusXl, child: child);
    }

    return GtInkWell(borderRadius: .zero, onTap: onTap, child: child);
  }
}

/// A list tile that displays a label and a value, allowing the user to copy
/// the value to the clipboard by tapping the tile.
///
/// This is ideal for IDs, account numbers, or any data that the user might
/// need to use elsewhere. It includes a copy icon by default.
class GtCopyTile extends GtStatelessWidget {
  /// The icon displayed at the start of the tile, typically representing the data type.
  final IconData leading;

  /// The descriptive label for the data (e.g., "Account Number").
  final String label;

  /// The actual text value that will be copied to the clipboard when tapped.
  final String value;

  /// An optional callback executed after the [value] has been successfully copied.
  ///
  /// This can be used to show a toast or snackbar notification.
  final OnChanged<String>? onCopied;

  /// Creates a [GtCopyTile] for easy data copying.
  const GtCopyTile(
    this.label, {
    super.key,
    required this.value,
    required this.leading,
    this.onCopied,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final textColors = context.palette.text;

    return GtInkWell(
      borderRadius: .zero,
      onTap: () => onCopied?.call(value),
      child: Row(
        spacing: context.spacingBase,
        children: [
          GtIcon(leading, size: 20, alignment: Alignment.centerLeft),
          Expanded(
            child: GtText(
              label,
              textAlign: TextAlign.start,
              style: styles.subHeadXs(color: textColors.sub),
            ),
          ),
          Expanded(
            child: GtText(
              value,
              textAlign: TextAlign.end,
              style: styles.subHeadXs(),
            ),
          ),
          GtIcon(
            GtIcons.copyFilled,
            size: 16,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}

/// A list tile used to present instructional or informative text alongside a prominent icon.
///
/// This widget is useful for onboarding steps, feature explanations, or any
/// scenario where text needs to be visually associated with a specific icon.
class GtInstructionListTile extends GtStatelessWidget {
  /// The instructional or informative text to display.
  final String text;

  /// The icon to display alongside the text.
  final IconData icon;

  /// The visual style variant for the [icon].
  ///
  /// Defaults to [GtIconVariant.soft].
  final GtIconVariant? iconVariant;

  /// Optional custom [TextStyle] for the [text].
  ///
  /// If null, defaults to [GtTextStyles.bodyXs].
  final TextStyle? textStyle;

  /// An optional callback triggered when the tile is tapped.
  final OnPressed? onTap;

  /// Optional custom size for the [icon].
  ///
  /// If null, defaults to 24px.
  final double? iconSize;

  /// How the icon and text should be aligned vertically.
  ///
  /// Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a [GtInstructionListTile] with the given [text] and [icon].
  const GtInstructionListTile(
    this.text, {
    super.key,
    required this.icon,
    this.onTap,
    this.iconVariant,
    this.textStyle,
    this.iconSize,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      borderRadius: .zero,
      onTap: onTap,
      child: Row(
        spacing: context.spacingBase,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          GtIcon(
            icon,
            size: iconSize ?? context.dp(24.px),
            alignment: Alignment.topLeft,
            variant: iconVariant ?? GtIconVariant.soft,
          ),
          Expanded(
            child: GtText(
              text,
              style: textStyle ?? context.textStyles.bodyXs(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A list tile that displays a label and a value in a balanced two-column format.
///
/// The label is typically on the left, and the value (with optional prefix/suffix)
/// is on the right. This is often used in transaction details or summary screens.
class GtDoubleColumnListTile extends GtStatelessWidget {
  /// The text displayed in the left column, usually the field name.
  final String label;

  /// The text displayed in the right column, usually the field value.
  final String value;

  /// An optional widget displayed immediately before the [value].
  final Widget? valuePrefix;

  /// An optional widget displayed immediately after the [value].
  final Widget? valueSuffix;

  /// Whether to emphasize the [value] text over the [label].
  ///
  /// If true (default), the value uses a stronger style while the label is subtler.
  final bool highlightValue;

  /// Creates a [GtDoubleColumnListTile].
  const GtDoubleColumnListTile(
    this.label, {
    super.key,
    required this.value,
    this.valuePrefix,
    this.valueSuffix,
    this.highlightValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textStyles = context.textStyles;
    TextStyle labelStyle = textStyles.bodyS(color: palette.text.sub);
    TextStyle valueStyle = textStyles.subHeadS();

    if (!highlightValue) {
      labelStyle = labelStyle.copyWith(color: palette.text.strong);
      valueStyle = valueStyle.copyWith(color: palette.text.soft);
    }

    return Row(
      spacing: context.spacingBase,
      children: [
        Expanded(child: GtText(label, style: labelStyle)),
        ?valuePrefix,
        Text(value, style: valueStyle, textAlign: TextAlign.end),
        ?valueSuffix,
      ],
    );
  }
}

/// A minimalistic tile for displaying a small leading widget alongside a text label.
///
/// This is typically used for subtle inline information, such as help hints,
/// status indicators, or small informational notes within a larger context.
class GtSimpleInfoTile extends GtStatelessWidget {
  /// The widget to display at the start, such as a small status icon.
  final Widget leading;

  /// The informational text content.
  final String text;

  /// Creates a [GtSimpleInfoTile].
  const GtSimpleInfoTile({
    super.key,
    required this.leading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.spacingXs,
      mainAxisSize: .min,
      children: [
        GtSquareConstrainedBox(16, child: leading),
        GtText(
          text,
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
      ],
    );
  }
}
