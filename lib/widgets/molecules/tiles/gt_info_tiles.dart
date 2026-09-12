import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile designed to display a descriptive label and its corresponding text value.
///
/// This widget is commonly used for summarizing form inputs, displaying read-only
/// account information, or presenting key-value pairs in a clean, vertical layout.
///
class GtInfoListTile extends GtStatelessWidget {
  /// The primary label or title for the information being displayed.
  final String label;

  /// The main text value or data associated with the [label].
  final String text;

  /// An optional widget, typically an icon, displayed at the start of the tile.
  final Widget? trailing;

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

  /// Creates a [GtInfoListTile].
  const GtInfoListTile(
    this.label, {
    super.key,
    required this.text,
    this.trailing,
    this.labelStyle,
    this.textStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final textColors = context.palette.text;
    final style = textStyle ?? styles.subHead3M(heightPx: 0);
    final hintStyle = labelStyle ?? styles.bodyS(color: textColors.sub);

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Column(
          spacing: context.spacingSm,
          crossAxisAlignment: .stretch,
          children: [
            Row(
              crossAxisAlignment: .center,
              spacing: context.spacingSm,
              children: [
                Expanded(child: GtText(label, style: hintStyle)),
                ?trailing,
              ],
            ),
            GtText(text, style: style),
          ],
        ),
      ),
    );
  }
}

/// A statistical list tile designed to prominently display a key metric or data point.
///
/// This widget is commonly used for dashboards and summary screens to highlight
/// key values (e.g., account balances, counts, percentages) along with an optional trend icon.
///
/// It can be rendered as a standalone tile or wrapped in a stylized card using
/// the [GtStatListTile.asCard] constructor.
class GtStatListTile extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides value color. Null preserves the current default.
  final Color? valueColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// The primary label or title for the information being displayed.
  final String title;

  /// The main text value or data associated with the [title].
  final String value;

  /// An optional widget, typically an icon, displayed alongside the title.
  final Widget? icon;

  /// A callback triggered when the tile is tapped.
  ///
  /// If provided, the tile becomes interactive and provides haptic feedback.
  final OnPressed? onTap;

  /// Optional custom [TextStyle] for the [value].
  ///
  /// If null, defaults to [GtTextStyles.h5].
  final TextStyle? valueStyle;

  /// Optional custom [TextStyle] for the [title].
  ///
  /// If null, defaults to [GtTextStyles.buttonXs] with a subtle color.
  final TextStyle? titleStyle;

  /// if true, the value will be displayed in green color, else in red color
  final bool isPositive;

  /// Internal flag to determine if the tile should be wrapped in a [GtCard].
  final bool _asCard;

  /// Creates a standard [GtStatListTile] without a card container.
  const GtStatListTile(
    this.title, {
    super.key,
    required this.value,
    this.icon,
    this.titleStyle,
    this.valueStyle,
    this.onTap,
    this.isPositive = true,
    this.backgroundColor,
    this.padding,
    this.titleColor,
    this.valueColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  }) : _asCard = false;

  /// Creates a [GtStatListTile] that is automatically wrapped in a [GtCard].
  const GtStatListTile.asCard(
    this.title, {
    super.key,
    required this.value,
    this.icon,
    this.titleStyle,
    this.valueStyle,
    this.isPositive = true,
    this.onTap,
    this.backgroundColor,
    this.padding,
    this.titleColor,
    this.valueColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueColor = isPositive ? palette.success.base : palette.error.base;
    final style = valueStyle ?? context.textStyles.h5(color: valueColor);
    final defaultTitleStyle = context.textStyles.buttonXs(
      color: palette.text.sub,
    );

    Widget child = Column(
      spacing: verticalSpacing ?? context.spacingBase,
      crossAxisAlignment: .start,
      children: [
        Row(
          spacing: horizontalSpacing ?? context.spacingSm,
          children: [
            ?icon,
            Expanded(
              child: GtText(
                title.upper,
                style: GtTextStyleOverrides.resolve(
                  titleStyle,
                  defaultTitleStyle,
                  titleColor,
                ),
              ),
            ),
          ],
        ),
        GtText(
          value,
          style: GtTextStyleOverrides.resolve(
            valueStyle,
            style,
            this.valueColor,
          ),
        ),
      ],
    );

    if (_asCard) {
      child = GtCard(
        color: backgroundColor,
        borderRadius: context.borderRadiusXl,

        padding: padding ?? context.insets.allDp(8.px),
        child: child,
      );
    }

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: child,
    );
  }
}

/// A list tile designed to display a descriptive label and its corresponding text value.
///
/// This widget is commonly used for summarizing form inputs, displaying read-only
/// account information, or presenting key-value pairs in a clean, vertical layout.
///
/// It can be rendered as a standalone tile or wrapped in a stylized card using
/// the [GtInputListTile.asCard] constructor.
class GtInputListTile extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides label color. Null preserves the current default.
  final Color? labelColor;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

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
    this.backgroundColor,
    this.padding,
    this.labelColor,
    this.textColor,
    this.verticalSpacing,
    this.horizontalSpacing,
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
    this.backgroundColor,
    this.padding,
    this.labelColor,
    this.textColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? context.textStyles.subHeadS();
    final hintStyle =
        (labelStyle ??
        context.textStyles.bodyXs(color: context.palette.text.sub));

    Widget child = Column(
      spacing: verticalSpacing ?? context.spacingSm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtText(
          label,
          style: GtTextStyleOverrides.resolve(
            labelStyle,
            hintStyle,
            labelColor,
          ),
        ),
        GtText(
          text,
          style: GtTextStyleOverrides.resolve(textStyle, style, textColor),
        ),
      ],
    );

    if (leading != null) {
      child = Row(
        spacing: horizontalSpacing ?? context.spacingBase,
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
      child = GtCard(
        color: backgroundColor,
        padding: padding,
        borderRadius: context.borderRadiusXl,
        child: child,
      );
    }

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: child,
    );
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

  /// Creates a [GtCopyTile] for easy data copying.
  const GtCopyTile(
    this.label, {
    super.key,
    required this.value,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final textColors = context.palette.text;

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: () {
        context.copyText(value);
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
      role: .button,
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

  /// An optional widget displayed immediately after the [label], such as an
  /// info icon.
  ///
  /// The label shrinks to make room for it, so a long label is ellipsised
  /// rather than pushing the suffix out of view.
  final Widget? labelSuffix;

  /// The gap between the [value] and its [valuePrefix] or [valueSuffix].
  ///
  /// Defaults to 8dp.
  final double? valueSpacing;

  ///Maximum number of lines for the label.
  final int labelMaxLines;

  ///Maximum number of lines for the value.
  final int valueMaxLines;

  /// Whether to emphasize the [value] text over the [label].
  ///
  /// If true (default), the value uses a stronger style while the label is subtler.
  final bool highlightValue;

  /// Optional custom [TextStyle] for the [value].
  final TextStyle? valueTextStyle;

  /// Optional custom [TextStyle] for the [label].
  final TextStyle? labelTextStyle;

  /// Creates a [GtDoubleColumnListTile].
  const GtDoubleColumnListTile(
    this.label, {
    super.key,
    required this.value,
    this.valuePrefix,
    this.valueSuffix,
    this.labelSuffix,
    this.valueSpacing,
    this.labelMaxLines = 1,
    this.valueMaxLines = 2,
    this.highlightValue = true,
    this.valueTextStyle,
    this.labelTextStyle,
  }) : assert(
         highlightValue || (valueTextStyle == null && labelTextStyle == null),
         'valueTextStyle and labelTextStyle must be null if highlightValue is false',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette.text;
    final textStyles = context.textStyles;
    TextStyle labelStyle =
        labelTextStyle ?? textStyles.subHeadXs(color: palette.sub);
    TextStyle valueStyle = valueTextStyle ?? textStyles.subHeadXs();

    if (!highlightValue) {
      labelStyle = labelStyle.copyWith(color: palette.strong);
      valueStyle = valueStyle.copyWith(color: palette.soft);
    }

    Widget labelChild = GtText(
      label,
      style: labelStyle,
      maxLines: labelMaxLines,
      overflow: .ellipsis,
    );

    if (labelSuffix != null) {
      labelChild = Row(
        spacing: context.spacingSm,
        children: [
          Flexible(child: labelChild),
          labelSuffix!,
        ],
      );
    }

    return Row(
      spacing: context.spacingMd,
      children: [
        Expanded(flex: 4, child: labelChild),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: .end,
            spacing: valueSpacing ?? context.spacingBase,
            children: [
              ?valuePrefix,
              Flexible(
                child: GtText(
                  value,
                  style: valueStyle,
                  textAlign: TextAlign.end,
                  overflow: .ellipsis,
                  maxLines: valueMaxLines,
                ),
              ),
              ?valueSuffix,
            ],
          ),
        ),
      ],
    );
  }
}

/// A minimalistic tile for displaying a small leading widget alongside a text label.
///
/// This is typically used for subtle inline information, such as help hints,
/// status indicators, or small informational notes within a larger context.
class GtSimpleInfoTile extends GtStatelessWidget {
  /// Overrides style. Null preserves the current default.
  final TextStyle? style;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// The widget to display at the start, such as a small status icon.
  final Widget leading;

  /// The informational text content.
  final String text;

  /// Creates a [GtSimpleInfoTile].
  const GtSimpleInfoTile({
    super.key,
    required this.leading,
    required this.text,
    this.style,
    this.textColor,
    this.horizontalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: horizontalSpacing ?? context.spacingSm,
      mainAxisSize: .min,
      children: [
        GtSquareConstrainedBox(16, child: leading),
        FractionalTranslation(
          translation: Offset(0, .1),
          child: GtText(
            text,
            style: GtTextStyleOverrides.resolve(
              style,
              context.textStyles.bodyXs(color: context.palette.text.sub),
              textColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// A list tile designed to display a service or bank name alongside its operational success rate percentage pill.
///
/// Dynamically formats the [successRate] percentage (0.0 to 1.0) and applies semantic color
/// variants (stable for >= 90%, away for >= 80%, warning for >= 70%, and error below 70%).
///
/// {@category molecules}
/// {@category tiles}
class GtSuccessRateTile extends GtStatelessWidget {
  /// Overrides text style. Null preserves the current default.
  final TextStyle? textStyle;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides percentage padding. Null preserves the current default.
  final EdgeInsetsGeometry? percentagePadding;

  /// Overrides percentage style. Null preserves the current default.
  final TextStyle? percentageStyle;

  /// Overrides percentage color. Null preserves the current default.
  final Color? percentageColor;

  /// Overrides percentage background color. Null preserves the current default.
  final Color? percentageBackgroundColor;

  /// The widget to display at the start, such as an institution logo or avatar.
  final Widget leading;

  /// The informational text content, typically the bank or service name.
  final String text;

  /// The success rate of the transaction as a decimal between 0.0 and 1.0.
  final double successRate;

  /// Creates a [GtSuccessRateTile].
  const GtSuccessRateTile({
    super.key,
    required this.leading,
    required this.text,
    required this.successRate,
    this.textStyle,
    this.textColor,
    this.horizontalSpacing,
    this.percentagePadding,
    this.percentageStyle,
    this.percentageColor,
    this.percentageBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles;

    GtPillVariant variant = switch (successRate) {
      >= .9 => .stable,
      >= .8 => .away,
      >= .7 => .warning,
      _ => .error,
    };
    final percentage = (100 * successRate.clamp(0, 1)).round();
    final textColor = switch (variant) {
      .stable => palette.stable.dark,
      .away => palette.away.dark,
      .warning => palette.warning.dark,
      _ => palette.error.dark,
    };

    return Row(
      spacing: horizontalSpacing ?? context.spacingBase,
      children: [
        leading,
        Expanded(
          child: GtText(
            text,
            style: GtTextStyleOverrides.resolve(
              textStyle,
              style.subHeadS(weight: .w600),
              this.textColor,
            ),
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ),
        GtPill(
          text: "$percentage%",
          variant: variant,
          bgColor:
              percentageBackgroundColor ?? variant.getBgColor(context.palette),
          textColor: percentageColor ?? textColor,
          textStyle: GtTextStyleOverrides.resolve(
            percentageStyle,
            style.ratePill(color: textColor),
            percentageColor,
          ),
          borderRadius: context.borderRadius4Xl,
          padding:
              percentagePadding?.resolve(Directionality.of(context)) ??
              context.insets.symmetricDp(vertical: 4.px, horizontal: 8.px),
          alignment: .centerRight,
        ),
      ],
    );
  }
}
