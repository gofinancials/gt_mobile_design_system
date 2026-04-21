import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying a payment method, like a bank account, with balance details.
class GtPaymentSourceCard extends GtStatelessWidget {
  /// The title of the payment source (e.g., "Checking Account").
  final String title;

  /// The current balance, formatted as a string.
  final String balance;

  /// Details of the account (e.g., account number).
  final String accountDetail;

  /// The icon representing the payment source (e.g., a bank logo).
  final Widget icon;

  /// An optional description.
  final String? description;

  /// The visual variant of the card.
  final GtCardVariant variant;

  /// An optional callback function that is invoked when the card is tapped.
  final OnPressed? onTap;

  /// Creates a [GtPaymentSourceCard].
  const GtPaymentSourceCard({
    super.key,
    required this.title,
    required this.icon,
    this.description,
    this.variant = .away,
    this.onTap,
    required this.balance,
    required this.accountDetail,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: variant,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          spacing: context.spacingLg,
          mainAxisSize: .min,
          children: [
            GtText(title, style: context.textStyles.subHead2s(color: context.palette.text.sub)),
            GtTransactionParticipantListTile(accountDetail, subtitle: balance, crossAxisAlignment: .center, leading: icon),
          ],
        ),
      ),
    );
  }
}