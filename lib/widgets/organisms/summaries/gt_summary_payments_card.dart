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
  /// The title, entries and count preference for the card.
  final GtSummaryPaymentsSection section;

  /// Creates a [GtSummaryPaymentsCard].
  const GtSummaryPaymentsCard(this.section, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatarSize = context.dp(32.px);

    return GtSummaryCardShell(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          // Not a GtSectionHeader: that widget uppercases its title and pushes
          // any trailing widget to the far edge, where the count would read as
          // a separate figure rather than a qualifier on the word beside it.
          Row(
            spacing: context.spacingSm,
            children: [
              GtText(
                section.title,
                key: const Key('summary-payments-title'),
                style: context.textStyles.subHeadS(weight: .w600),
              ),
              if (section.showCount)
                GtText(
                  "• ${section.entries.length}",
                  key: const Key('summary-payments-count'),
                  style: context.textStyles.subHeadS(
                    color: context.palette.text.sub,
                  ),
                ),
            ],
          ),
          const GtGap.yLg(),
          for (final (index, entry) in section.entries.indexed)
            GtPaymentListTile(
              entry.name,
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
