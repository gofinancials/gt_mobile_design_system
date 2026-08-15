import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The success-rate card of a [GtSummaryBody].
///
/// Surfaces the recipient bank's recent success rate at the point of decision,
/// so a sender can reconsider before confirming rather than after a transfer
/// stalls. Presents, from top to bottom:
/// - The [GtSummaryRatesSection.description] copy.
/// - One [GtSuccessRateTile] per entry.
/// - A [GtDashedDivider] and a navigation row, when the data carries an action.
///
/// Entries are [GtSuccessRateData], the same type [GtSuccessRateBody] consumes,
/// so the action typically opens the full sheet over the very same list.
class GtSummaryRatesCard extends GtStatelessWidget {
  /// The description, rates and optional navigation action for the card.
  final GtSummaryRatesSection rates;

  /// Creates a [GtSummaryRatesCard].
  const GtSummaryRatesCard(this.rates, {super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = context.dp(20.px);

    return GtSummaryCardShell(
      child: Column(
        spacing: context.spacingSectionSm,
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          // Full-strength rather than subdued: this line is the card's
          // heading, not a caption under one.
          GtText(
            rates.description,
            key: const Key('summary-rates-description'),
            style: context.textStyles.body2s(),
          ),
          for (final (index, rate) in rates.rates.indexed)
            GtSuccessRateTile(
              key: Key('summary-rate-$index'),
              text: rate.name,
              successRate: rate.rate,
              leading: switch (rate.logo) {
                AppImageData logo => GtImage(
                  image: logo,
                  width: logoSize,
                  height: logoSize,
                  isDecorative: true,
                ),
                _ => GtAvatar(size: logoSize, initials: rate.name.initials),
              },
            ),
          if (rates.hasAction) ...[
            const GtDashedDivider(),
            GtListTile(
              key: const Key('summary-rates-action'),
              text: rates.actionLabel!,
              onTap: rates.onAction,
              trailing: GtIcon(
                GtIcons.chevronRight,
                size: context.dp(16.px),
                variant: .soft,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
