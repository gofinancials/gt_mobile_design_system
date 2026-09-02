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
  final Widget? leading;

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

  /// The currency used for formatting the amount. Defaults to `AppStrings.naira`.
  final String currency;

  /// Determines if amount is masked
  final bool maskAmount;

  /// Optional custom style override for the [name] text.
  final TextStyle? nameStyle;

  /// Optional custom style override for the [subtitle] text.
  final TextStyle? subtitleStyle;

  /// Optional custom style override for the [amount] text.
  final TextStyle? amountStyle;

  /// Determines the maximum number of lines for the name and amount.
  final int? maxLines;

  /// Optional horizontal spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtTransactionListTile].
  const GtTransactionListTile(
    this.name, {
    super.key,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    this.leading,
    this.leadingSize = 36,
    this.onTap,
    this.currency = AppStrings.naira,
    this.maskAmount = false,
    this.nameStyle,
    this.subtitleStyle,
    this.amountStyle,
    this.maxLines = 1,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
  });

  String get _formattedAmount {
    if (maskAmount) return '*' * ("$amount".length).clamp(4, 10);
    final bool isLong = amount >= 100_000_000;
    final formatted = isLong
        ? amount.asCurrencyShort(currency)
        : amount.asCurrency(currency);
    if (!isDebit) return "+$formatted";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles;
    final amountColor = switch (isDebit) {
      true => palette.text.strong,
      _ => palette.success.darker,
    };
    Widget icon = GtSquareConstrainedBox(leadingSize, child: leading);

    if (leading == null) {
      final svgAsset = isDebit ? GtVectors.outflow : GtVectors.inflow;
      icon = GtSvg(
        svgAsset,
        width: leadingSize,
        height: leadingSize,
        isDecorative: true,
      );
    }

    final valueStyle = style.subHeadS(color: amountColor);
    final subStyle = style.subHeadXs(color: palette.text.sub);

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          children: [
            icon,
            Expanded(
              child: Column(
                spacing: verticalSpacing ?? context.spacingXs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: horizontalSpacing ?? context.spacingMd,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GtText(
                          name,
                          style: nameStyle ?? style.subHeadS(weight: .w600),
                          textAlign: TextAlign.start,
                          overflow: .ellipsis,
                          maxLines: maxLines,
                        ),
                      ),
                      GtText(
                        _formattedAmount,
                        style: amountStyle ?? valueStyle,
                        textAlign: .end,
                        overflow: .ellipsis,
                        maxLines: maxLines,
                      ),
                    ],
                  ),
                  GtText(
                    subtitle,
                    style: subtitleStyle ?? subStyle,
                    textAlign: TextAlign.end,
                    maxLines: 1,
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

/// A specialized list tile designed for payment and checkout summaries.
///
/// Displays payment [title], [subtitle] (e.g. account details or dates),
/// formatted monetary [amount], optional [fees] breakdown text, and leading icon/avatar.
///
/// {@category molecules}
/// {@category tiles}
class GtPaymentListTile extends GtStatelessWidget {
  /// The widget to display at the start of the tile, typically an icon or avatar.
  final Widget? leading;

  /// The primary title or name of the payment.
  final String title;

  /// Additional details about the payment, such as the account number, biller, or date.
  final String subtitle;

  /// The monetary value of the payment.
  final String amount;

  /// Optional fee or surcharge breakdown text displayed below the amount.
  final String? fees;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed? onTap;

  /// The size (width and height) of the square leading widget. Defaults to 32.
  final double leadingSize;

  /// The currency used for formatting the amount. Defaults to [AppStrings.naira].
  final String currency;

  /// Determines if the amount is masked.
  final bool maskAmount;

  /// Optional custom style override for the [title] text.
  final TextStyle? nameStyle;

  /// Optional custom style override for the [subtitle] text.
  final TextStyle? subtitleStyle;

  /// Optional custom style override for the [amount] text.
  final TextStyle? amountStyle;

  /// Optional horizontal spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtPaymentListTile].
  const GtPaymentListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.amount,
    this.fees,
    this.leading,
    this.leadingSize = 32,
    this.onTap,
    this.currency = AppStrings.naira,
    this.maskAmount = false,
    this.nameStyle,
    this.subtitleStyle,
    this.amountStyle,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles;
    final subStyle = style.subHead3_5xs(color: palette.text.sub);

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingBase,
          crossAxisAlignment: .start,
          children: [
            ?leading,
            Expanded(
              child: Row(
                spacing: horizontalSpacing ?? context.spacingBase,
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: Column(
                      spacing: context.spacingSm,
                      crossAxisAlignment: .start,
                      children: [
                        GtText(
                          title,
                          style: nameStyle ?? style.subHeadS(),
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        GtText(
                          subtitle,
                          style: subtitleStyle ?? subStyle,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .end,
                      children: [
                        GtText(
                          amount,
                          style: amountStyle ?? style.subHeadM(weight: .w600),
                          textAlign: .end,
                          maxLines: 1,
                        ),
                        if (fees.hasValue)
                          GtText(
                            fees,
                            style: subtitleStyle ?? subStyle,
                            textAlign: .end,
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                      ],
                    ),
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

  /// Custom styling for the [title] text.
  final TextStyle? titleStyle;

  /// Custom styling for the [superscript] text.
  final TextStyle? superscriptStyle;

  /// The maximum number of lines to display for the [title], [subtitle], and [superscript].
  final int? maxLines;

  /// Optional spacer widget to place between the subtitle and the trailing widget.
  final Widget? subSpacer;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

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
    this.titleStyle,
    this.superscriptStyle,
    this.maxLines,
    this.subSpacer,
    this.horizontalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.textStyles;
    final defaultSubStyle = style.subHead2xs(color: palette.text.soft);
    final defaultSupStyle = style.title2xs(color: palette.text.disabled);

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      spacing: horizontalSpacing ?? context.spacingMd,
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
                  style: superscriptStyle ?? defaultSupStyle,
                  maxLines: 1,
                ),
              GtText(
                title,
                style: titleStyle ?? style.buttonS(),
                maxLines: maxLines,
                overflow: maxLines != null ? .ellipsis : null,
              ),
              if (subtitle.hasValue) ...[
                subSpacer ?? const GtGap.ySm(),
                GtText(
                  subtitle,
                  style: subStyle ?? defaultSubStyle,
                  maxLines: maxLines,
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
