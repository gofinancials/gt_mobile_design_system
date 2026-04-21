import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile used to display information about a specific limit, showing a
/// label, a value, and an optional leading icon.
class GtLimitInfoListTile extends GtStatelessWidget {
  /// The descriptive label for the limit.
  final String label;

  /// The formatted string representation of the current limit value.
  final String value;

  /// An optional icon to display at the start of the tile. Defaults to [GtIcons.gauge].
  final IconData? leading;

  /// Creates a [GtLimitInfoListTile].
  const GtLimitInfoListTile(
    this.label, {
    super.key,
    this.leading,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.spacingMd,
      children: [
        GtIcon(leading ?? GtIcons.gauge, size: 20),
        Expanded(
          child: Column(
            spacing: context.spacingSm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(
                label,
                style: context.textStyles.bodyXs(
                  color: context.palette.text.sub,
                ),
              ),
              GtText(value, style: context.textStyles.subHeadM()),
            ],
          ),
        ),
      ],
    );
  }
}

/// A comprehensive list tile for displaying and editing a limit.
///
/// Includes a visual progress bar indicating the used amount vs the maximum
/// amount, and an optional edit button.
class GtLimitEditListTile extends GtStatelessWidget {
  /// The name or category of the limit being displayed.
  final String category;

  /// The current utilized amount of the limit.
  final num value;

  /// The maximum allowable amount for this limit.
  final num max;

  /// An optional callback triggered when the info icon next to the category is tapped.
  final OnPressed? onTapInfo;

  /// Optional custom text for the edit button. Defaults to localized "edit".
  final String? editText;

  /// An optional callback triggered when the edit button is tapped. If null, the button is hidden.
  final OnPressed? onEdit;

  /// Creates a [GtLimitEditListTile].
  const GtLimitEditListTile(
    this.category, {
    super.key,
    required this.value,
    required this.max,
    this.editText,
    this.onTapInfo,
    this.onEdit,
  });

  /// Calculates the ratio of the utilized value to the maximum, capped at 1.0
  /// for the progress bar.
  double get _fraction => min((value / max), 1);

  /// Calculates the remaining available amount of the limit.
  num get _remainder => max - value;

  /// The localized, currency-formatted string of the current utilized value.
  String get _formattedValue => AppTextFormatter.formatCurrency(value);

  /// The localized, currency-formatted string of the remaining available amount.
  String get _formattedRemainder => AppTextFormatter.formatCurrency(_remainder);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacingSm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.spacingBase,
                children: [
                  Text.rich(
                    TextSpan(
                      text: category,
                      children: [
                        TextSpan(text: " "),
                        WidgetSpan(
                          child: GtIcon(GtIcons.info, size: 18, variant: .soft),
                        ),
                      ],
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (onTapInfo == null) return;
                          HapticFeedback.lightImpact();
                          onTapInfo?.call();
                        },
                    ),
                    style: context.textStyles.subHeadM(),
                  ),
                  GtText(
                    _formattedValue,
                    style: context.textStyles.body2Xs(
                      color: context.palette.text.darkerSub,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              GtRaisedButton(
                onPressed: () {
                  onEdit?.call();
                },
                text: editText ?? "edit".tr(),
                variant: .neutral,
                size: .small,
                leading: GtIcons.pencil,
              ),
          ],
        ),
        const GtGap.ySm(),
        GtAnimatedProgress(
          value: _fraction,
          valueColor: context.palette.primary.base,
        ),
        const GtGap.ySm(),
        Align(
          alignment: Alignment.centerRight,
          child: GtText(
            "$_formattedRemainder ${"remaining".tr()}",
            style: context.textStyles.subHead2xs(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}