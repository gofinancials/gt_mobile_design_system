import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile designed to display a label and its corresponding text value,
/// often used for summarizing form inputs or displaying read-only data.
///
/// Can optionally be rendered inside a stylized card using [GtInputListTile.asCard].
class GtInputListTile extends GtStatelessWidget {
  /// The primary label or title for the input data.
  final String label;

  /// The corresponding text value or data displayed alongside the label.
  final String text;

  /// An optional widget, typically an icon, displayed at the start of the tile.
  final Widget? leading;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed? onTap;

  /// Custom text style to apply to the [text].
  final TextStyle? textStyle;

  /// Custom text style to apply to the [label].
  final TextStyle? labelStyle;
  final bool _asCard;

  /// Creates a standard [GtInputListTile] without a card wrapper.
  const GtInputListTile(
    this.label, {
    super.key,
    required this.text,
    this.leading,
    this.labelStyle,
    this.textStyle,
    this.onTap,
  }) : _asCard = false;

  /// Creates a [GtInputListTile] wrapped inside a stylized [GtCard].
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

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: child,
    );
  }
}

/// A list tile designed to display a label and a value that can be easily
/// copied to the device clipboard upon tapping.
class GtCopyTile extends GtStatelessWidget {
  /// The icon to display at the start of the tile.
  final IconData leading;

  /// The descriptive label for the data being copied.
  final String label;

  /// The actual text value that will be copied to the clipboard.
  final String value;

  /// An optional callback executed immediately after the [value] is copied.
  final OnPressed? onCopied;

  /// Creates a [GtCopyTile].
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

    return InkWell(
      onTap: () {
        context.copyTextToClipboard(value);
        onCopied?.call();
      },
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

/// A list tile used to present instructional text alongside an icon.
class GtInstructionListTile extends GtStatelessWidget {
  /// The instructional text to display.
  final String text;

  /// The icon to display alongside the instruction.
  final IconData icon;

  /// The variant style applied to the [icon]. Defaults to [GtIconVariant.soft].
  final GtIconVariant? iconVariant;

  /// Custom color to apply to the instructional [text].
  final Color? textColor;

  /// An optional callback triggered when the instruction is tapped.
  final OnPressed? onTap;

  /// Creates a [GtInstructionListTile].
  const GtInstructionListTile(
    this.text, {
    super.key,
    required this.icon,
    this.onTap,
    this.iconVariant,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Row(
        spacing: context.spacingBase,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GtIcon(
            icon,
            size: context.dp(24.px),
            alignment: Alignment.topLeft,
            variant: iconVariant ?? GtIconVariant.soft,
          ),
          Expanded(
            child: GtText(
              text,
              style: context.textStyles.bodyS(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// A list tile that displays a label and a value in a two-column row format.
class GtDoubleColumnListTile extends GtStatelessWidget {
  /// The text displayed in the left column.
  final String label;

  /// The text displayed in the right column.
  final String value;

  /// An optional widget displayed immediately before the [value].
  final Widget? valuePrefix;

  /// An optional widget displayed immediately after the [value].
  final Widget? valueSuffix;

  /// If true, emphasizes the [value] text over the [label]. Defaults to true.
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
