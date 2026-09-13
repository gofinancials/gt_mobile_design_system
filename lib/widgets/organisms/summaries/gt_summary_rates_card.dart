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
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides description style. Null preserves the current default.
  final TextStyle? descriptionStyle;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides rate name style. Null preserves the current default.
  final TextStyle? rateNameStyle;

  /// Overrides rate name color. Null preserves the current default.
  final Color? rateNameColor;

  /// Overrides rate style. Null preserves the current default.
  final TextStyle? rateStyle;

  /// Overrides rate color. Null preserves the current default.
  final Color? rateColor;

  /// Overrides rate background color. Null preserves the current default.
  final Color? rateBackgroundColor;

  /// Overrides rate padding. Null preserves the current default.
  final EdgeInsetsGeometry? ratePadding;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides action style. Null preserves the current default.
  final TextStyle? actionStyle;

  /// Overrides action color. Null preserves the current default.
  final Color? actionColor;

  /// The description, rates and optional navigation action for the card.
  final GtSummaryRatesSection rates;

  /// Creates a [GtSummaryRatesCard].
  const GtSummaryRatesCard(
    this.rates, {
    this.backgroundColor,
    this.padding,
    this.descriptionStyle,
    this.descriptionColor,
    this.verticalSpacing,
    this.rateNameStyle,
    this.rateNameColor,
    this.rateStyle,
    this.rateColor,
    this.rateBackgroundColor,
    this.ratePadding,
    this.horizontalSpacing,
    this.actionStyle,
    this.actionColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = context.dp(20.px);

    return GtSummaryCardShell(
      backgroundColor: backgroundColor,
      padding: padding,
      child: Column(
        spacing: verticalSpacing ?? context.spacingSectionSm,
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          // Full-strength rather than subdued: this line is the card's
          // heading, not a caption under one.
          GtText(
            rates.description,
            key: const Key('summary-rates-description'),
            style: GtTextStyleOverrides.resolve(
              descriptionStyle,
              context.textStyles.body2s(),
              descriptionColor,
            ),
          ),
          for (final (index, rate) in rates.rates.indexed)
            GtSuccessRateTile(
              textStyle: rateNameStyle,
              textColor: rateNameColor,
              percentageStyle: rateStyle,
              percentageColor: rateColor,
              percentageBackgroundColor: rateBackgroundColor,
              percentagePadding: ratePadding,
              horizontalSpacing: horizontalSpacing,
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
              style: actionStyle,
              textColor: actionColor,
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
