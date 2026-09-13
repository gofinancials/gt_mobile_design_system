import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A tappable card that shows the account a payment is made from.
///
/// An optional [label] header, such as "Pay from", sits above a row holding
/// the [leading] logo, the [title] and [subTitle] lines, and a [trailing]
/// widget that defaults to a chevron hinting that another source can be
/// chosen.
class GtPaymentSourceCard extends GtStatelessWidget {
  /// Overrides the card background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides the card padding. Null preserves the current default of 16
  /// logical pixels on every side.
  final EdgeInsetsGeometry? padding;

  /// Overrides the [label] style. Null preserves the current default.
  final TextStyle? labelStyle;

  /// Overrides the [label] color, taking precedence over [labelStyle]. Null
  /// preserves the current default.
  final Color? titleColor;

  /// Overrides the space between the [label] and the row below it, in logical
  /// pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides the [title] style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides the [title] color, taking precedence over [titleStyle]. Null
  /// preserves the current default.
  final Color? accountDetailColor;

  /// Overrides the [subTitle] style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides the [subTitle] color, taking precedence over [subtitleStyle].
  /// Null preserves the current default.
  final Color? balanceColor;

  /// Overrides the space between [leading], the text and [trailing], in
  /// logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides the space between [title] and [subTitle], in logical pixels.
  /// Null preserves the current default.
  final double? subSpacing;

  /// The main line of the row, such as the account type and number.
  final String title;

  /// The secondary line under [title], such as the formatted balance.
  final String subTitle;

  /// An optional header shown above the row, such as "Pay from".
  final String? label;

  /// The widget shown before the text, such as a bank logo.
  final Widget leading;

  /// The widget shown after the text. Defaults to a chevron.
  final Widget? trailing;

  /// An optional description. It is not currently displayed.
  final String? description;

  /// The visual variant of the card. Defaults to [GtCardVariant.away].
  final GtCardVariant variant;

  /// Called when the card is tapped, such as to choose another payment
  /// source.
  final OnPressed? onTap;

  /// The radius of the painted card
  final BorderRadius? borderRadius;

  /// Creates a [GtPaymentSourceCard].
  const GtPaymentSourceCard({
    super.key,
    required this.title,
    required this.leading,
    this.description,
    this.variant = .away,
    this.onTap,
    required this.subTitle,
    this.label,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.labelStyle,
    this.subtitleStyle,
    this.titleColor,
    this.verticalSpacing,
    this.accountDetailColor,
    this.balanceColor,
    this.horizontalSpacing,
    this.subSpacing,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GtCard(
      color: backgroundColor,
      padding: padding ?? context.insets.allDp(16.px),
      variant: variant,
      borderRadius: borderRadius,
      onPressed: onTap,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        spacing: verticalSpacing ?? context.spacingLg,
        mainAxisSize: .min,
        children: [
          if (label.hasValue)
            GtText(
              label.value,
              style: GtTextStyleOverrides.resolve(
                labelStyle,
                context.textStyles.subHead2s(color: context.palette.text.sub),
                titleColor,
              ),
            ),
          GtTransactionParticipantListTile(
            title,
            subtitle: subTitle,
            titleStyle: GtTextStyleOverrides.resolve(
              titleStyle,
              context.textStyles.buttonS(),
              accountDetailColor,
            ),
            subStyle: GtTextStyleOverrides.resolve(
              subtitleStyle,
              context.textStyles.subHead2xs(color: context.palette.text.soft),
              balanceColor,
            ),
            horizontalSpacing: horizontalSpacing,
            subSpacer: subSpacing == null ? null : SizedBox(height: subSpacing),
            crossAxisAlignment: .center,
            leading: leading,
            trailing: trailing ?? GtIcon(GtIcons.chevronDown, size: 16),
          ),
        ],
      ),
    );
  }
}
