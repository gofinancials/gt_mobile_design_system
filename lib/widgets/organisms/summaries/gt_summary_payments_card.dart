import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The payee card of a bulk-payment summary.
///
/// Heads the card with the section title and, unless suppressed, the number of
/// payees — the one figure a sender checks before releasing a batch — then
/// lists each payee as a [GtPaymentListTile]: avatar, name, account number, and
/// the amount with its fee beneath.
class GtSummaryPaymentsCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides count style. Null preserves the current default.
  final TextStyle? countStyle;

  /// Overrides count color. Null preserves the current default.
  final Color? countColor;

  /// Overrides count spacing in logical pixels. Null preserves the current default.
  final double? countSpacing;

  /// Overrides header spacing in logical pixels. Null preserves the current default.
  final double? headerSpacing;

  /// Overrides name style. Null preserves the current default.
  final TextStyle? nameStyle;

  /// Overrides detail style. Null preserves the current default.
  final TextStyle? detailStyle;

  /// Overrides amount style. Null preserves the current default.
  final TextStyle? amountStyle;

  /// Overrides fees style. Null preserves the current default.
  final TextStyle? feesStyle;

  /// Overrides name color. Null preserves the current default.
  final Color? nameColor;

  /// Overrides detail color. Null preserves the current default.
  final Color? detailColor;

  /// Overrides amount color. Null preserves the current default.
  final Color? amountColor;

  /// Overrides fees color. Null preserves the current default.
  final Color? feesColor;

  /// Overrides entry padding. Null preserves the current default.
  final EdgeInsetsGeometry? entryPadding;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// The title, entries and count preference for the card.
  final GtSummaryPaymentsSection section;

  /// Creates a [GtSummaryPaymentsCard].
  const GtSummaryPaymentsCard(
    this.section, {
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.countStyle,
    this.countColor,
    this.countSpacing,
    this.headerSpacing,
    this.nameStyle,
    this.detailStyle,
    this.amountStyle,
    this.feesStyle,
    this.nameColor,
    this.detailColor,
    this.amountColor,
    this.feesColor,
    this.entryPadding,
    this.horizontalSpacing,
    this.verticalSpacing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = context.dp(32.px);

    return GtSummaryCardShell(
      backgroundColor: backgroundColor,
      padding: padding,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          // Not a GtSectionHeader: that widget uppercases its title and pushes
          // any trailing widget to the far edge, where the count would read as
          // a separate figure rather than a qualifier on the word beside it.
          Row(
            spacing: countSpacing ?? context.spacingSm,
            children: [
              GtText(
                section.title,
                key: const Key('summary-payments-title'),
                style: GtTextStyleOverrides.resolve(
                  titleStyle,
                  context.textStyles.subHeadS(weight: .w600),
                  titleColor,
                ),
              ),
              if (section.showCount)
                GtText(
                  "• ${section.entries.length}",
                  key: const Key('summary-payments-count'),
                  style: GtTextStyleOverrides.resolve(
                    countStyle,
                    context.textStyles.subHeadS(
                      color: context.palette.text.sub,
                    ),
                    countColor,
                  ),
                ),
            ],
          ),
          (headerSpacing == null
              ? const GtGap.yLg()
              : SizedBox(height: headerSpacing)),
          for (final (index, entry) in section.entries.indexed)
            GtPaymentListTile(
              entry.name,
              nameStyle: nameStyle,
              subtitleStyle: detailStyle,
              amountStyle: amountStyle,
              feesStyle: feesStyle,
              nameColor: nameColor,
              subtitleColor: detailColor,
              amountColor: amountColor,
              feesColor: feesColor,
              padding: entryPadding,
              horizontalSpacing: horizontalSpacing,
              verticalSpacing: verticalSpacing,
              key: Key('summary-payment-$index'),
              subtitle: entry.detail,
              amount: entry.amount,
              fees: entry.fees,
              onTap: entry.onTap,
              leadingSize: avatarSize,
              leading: switch (entry.avatar) {
                AppImageData image => GtAvatar(size: avatarSize, avatar: image),
                _ => GtAvatar(size: avatarSize, initials: entry.name.initials),
              },
            ),
        ],
      ),
    );
  }
}
