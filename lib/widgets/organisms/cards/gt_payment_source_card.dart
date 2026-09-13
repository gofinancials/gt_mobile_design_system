import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying a payment method, like a bank account, with balance details.
class GtPaymentSourceCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides account detail style. Null preserves the current default.
  final TextStyle? accountDetailStyle;

  /// Overrides account detail color. Null preserves the current default.
  final Color? accountDetailColor;

  /// Overrides balance style. Null preserves the current default.
  final TextStyle? balanceStyle;

  /// Overrides balance color. Null preserves the current default.
  final Color? balanceColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides balance spacing in logical pixels. Null preserves the current default.
  final double? balanceSpacing;

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
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.verticalSpacing,
    this.accountDetailStyle,
    this.accountDetailColor,
    this.balanceStyle,
    this.balanceColor,
    this.horizontalSpacing,
    this.balanceSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: onTap,
      child: GtCard(
        color: backgroundColor,
        padding: padding ?? context.insets.allDp(16.px),
        variant: variant,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          spacing: verticalSpacing ?? context.spacingLg,
          mainAxisSize: .min,
          children: [
            GtText(
              title,
              style: GtTextStyleOverrides.resolve(
                titleStyle,
                context.textStyles.subHead2s(color: context.palette.text.sub),
                titleColor,
              ),
            ),
            GtTransactionParticipantListTile(
              accountDetail,
              subtitle: balance,
              titleStyle: GtTextStyleOverrides.resolve(
                accountDetailStyle,
                context.textStyles.buttonS(),
                accountDetailColor,
              ),
              subStyle: GtTextStyleOverrides.resolve(
                balanceStyle,
                context.textStyles.subHead2xs(color: context.palette.text.soft),
                balanceColor,
              ),
              horizontalSpacing: horizontalSpacing,
              subSpacer: balanceSpacing == null
                  ? null
                  : SizedBox(height: balanceSpacing),
              crossAxisAlignment: .center,
              leading: icon,
              trailing: GtIcon(GtIcons.chevronDown, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
