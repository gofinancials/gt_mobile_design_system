import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A comprehensive list tile for displaying progress towards a specific goal.
///
/// Includes a visual progress bar indicating the current amount vs the goal
/// amount, and an optional edit button.
class GtGoalProgressListTile extends GtStatelessWidget {
  /// The current accumulated or utilized amount towards the goal.
  final num currentAmount;

  /// The target or maximum amount for this goal.
  final num goalAmount;

  /// Optional custom text for the edit button. Defaults to localized "edit".
  final String? editText;

  /// An optional callback triggered when the edit button is tapped. If null, the button is hidden.
  final OnPressed? onEdit;

  /// Whether to wrap the tile in a [GtCard] with padding and rounded corners.
  ///
  /// Defaults to `true`.
  final bool asCard;

  /// The currency symbol to use for formatting the amounts.
  ///
  /// Defaults to [AppStrings.naira].
  final String currency;

  /// Creates a [GtGoalProgressListTile].
  const GtGoalProgressListTile({
    super.key,
    required this.currentAmount,
    required this.goalAmount,
    this.editText,
    this.onEdit,
    this.asCard = true,
    this.currency = AppStrings.naira,
  });

  /// Calculates the ratio of the utilized value to the maximum, capped at 1.0
  /// for the progress bar.
  double get _fraction => min((currentAmount / goalAmount), 1);

  /// The localized, currency-formatted string of the current utilized value.
  String get _formattedValue {
    return AppTextFormatter.formatCurrency(currentAmount, symbol: currency);
  }

  /// The localized, currency-formatted string of the remaining available amount.
  String get _formattedGoal {
    return AppTextFormatter.formatCurrency(goalAmount, symbol: currency);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (100 * _fraction).toStringAsFixed(0);

    Widget child = Column(
      spacing: context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: _formattedValue,
            children: [
              TextSpan(text: " ${"of".tr()} "),
              TextSpan(text: _formattedGoal),
              TextSpan(text: " ${AppStrings.dotSeparator} $percentage%"),
            ],
          ),
          style: context.textStyles.body2Xs(
            color: context.palette.text.darkerSub,
          ),
        ),
        GtAnimatedProgress(
          value: _fraction,
          valueColor: context.palette.primary.base,
        ),
        if (onEdit != null)
          GtTextButton(
            onPressed: () {
              onEdit?.call();
            },
            text: editText ?? "edit".tr(),
            variant: .featured,
            size: .small,
            alignment: .centerLeft,
            contentPadding: .zero,
          ),
      ],
    );

    if (asCard) {
      child = GtCard(
        borderRadius: context.borderRadiusXl,
        padding: context.insets.allDp(16.px),
        child: child,
      );
    }

    return child;
  }
}
