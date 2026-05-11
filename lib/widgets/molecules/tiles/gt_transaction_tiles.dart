import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A collection of specialized list tiles for transaction-related UI.
///
/// Includes [GtTransactionListTile] for displaying financial transactions
/// and [GtTransactionParticipantListTile] for displaying participants (sender/receiver).

/// A specialized list tile for displaying financial transactions.
///
/// Includes the transaction name, amount (styled conditionally based on whether
/// it is a debit), and a subtitle for details like the date.
///
/// {@category molecules}
/// {@category tiles}
class GtTransactionListTile extends GtStatelessWidget {
  /// The widget to display at the start of the tile, typically an icon or logo.
  final Widget leading;

  /// The name or description of the transaction.
  final String name;

  /// Additional details about the transaction, such as the date or time.
  final String subtitle;

  /// The monetary value of the transaction.
  final num amount;

  /// Indicates whether the transaction is a debit (true) or credit (false). Affects the color styling of the amount.
  final bool isDebit;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed? onTap;

  /// The size (width and height) of the square leading widget. Defaults to 36.
  final double leadingSize;

  /// Creates a [GtTransactionListTile].
  const GtTransactionListTile(
    this.name, {
    super.key,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.leading,
    this.leadingSize = 36,
    this.onTap,
  });

  String get _formattedAmount {
    final formatted = AppTextFormatter.formatCurrency(amount, symbol: "N");
    if (!isDebit) return "+$formatted";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final amountColor = switch (isDebit) {
      true => palette.text.strong,
      _ => palette.success.darker,
    };

    return GtInkWell(
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            GtSquareConstrainedBox(leadingSize, child: leading),
            Expanded(
              child: Column(
                spacing: context.spacingXs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: context.spacingSm,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GtText(
                          name,
                          style: context.textStyles.subHeadM(),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      GtText(
                        _formattedAmount,
                        style: context.textStyles.subHeadS(color: amountColor),
                      ),
                    ],
                  ),
                  GtText(
                    subtitle,
                    style: context.textStyles.bodyXs(color: palette.text.sub),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A list tile specifically designed to display the participants (sender or
/// receiver) of a transaction, showing a superscript label (e.g., 'to', 'from').
///
/// {@category molecules}
/// {@category tiles}
class GtTransactionParticipantListTile extends GtStatelessWidget {
  /// The primary name or title of the participant.
  final String title;

  /// Optional additional details about the participant, such as an account number or balance.
  final String? subtitle;

  /// A small label displayed above the title, indicating the role or direction (e.g., 'to', 'from').
  final String? superscript;

  /// An optional widget to display at the start of the tile, typically an avatar or logo.
  final Widget? leading;

  /// An optional widget to display at the end of the tile, typically an action icon.
  final Widget? trailing;

  /// How the children should be placed along the cross axis.
  ///
  /// Defaults to [CrossAxisAlignment.end].
  final CrossAxisAlignment crossAxisAlignment;

  /// Custom styling for the [subtitle] text.
  final TextStyle? subStyle;

  /// Creates a [GtTransactionParticipantListTile].
  const GtTransactionParticipantListTile(
    this.title, {
    super.key,
    this.subtitle,
    this.leading,
    this.crossAxisAlignment = CrossAxisAlignment.end,
    this.trailing,
    this.superscript,
    this.subStyle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      spacing: context.spacingMd,
      children: [
        ?leading,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: switch (crossAxisAlignment) {
              .center => MainAxisAlignment.center,
              .start => MainAxisAlignment.start,
              _ => MainAxisAlignment.end,
            },
            children: [
              if (superscript.hasValue)
                GtText(
                  superscript?.upper,
                  style: context.textStyles.title2xs(
                    color: palette.text.disabled,
                  ),
                ),
              GtText(title, style: context.textStyles.h7()),
              if (subtitle.hasValue) ...[
                const GtGap.ySm(),
                GtText(
                  subtitle,
                  style:
                      subStyle ??
                      context.textStyles.subHead2xs(color: palette.text.soft),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          ConstrainedBox(
            constraints: BoxConstraints.tight(Size.square(24)),
            child: trailing,
          ),
      ],
    );
  }
}
