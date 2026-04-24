import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that prompts the user to take one or two actions (e.g., a primary
/// action and a dismiss option).
class GtProgressCard extends GtStatelessWidget {
  /// The main title of the action card.
  final String title;

  /// The secondary text or subtitle of the action card.
  final String subtitle;

  /// The visual variant of the card, which determines its background and button styles.
  final GtCardVariant variant;

  /// A callback function that is invoked when the primary action button is tapped.
  final OnPressed onContinue;

  /// The text to display on the primary action button.
  final String continueText;

  final String percentSubtext;

  final num maxValue;

  final num currentValue;

  double get fraction => currentValue / maxValue;
  String get percentage => (100 * fraction).clamp(0, 100).toStringAsFixed(0);

  /// Creates an action card with a primary action button.
  const GtProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.variant = .away,
    required this.maxValue,
    required this.currentValue,
    required this.continueText,
    required this.onContinue,
    required this.percentSubtext,
  }) : assert(
         currentValue <= maxValue,
         'Current value should be equal or less than max value',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueColor = variant.getProgressColor(palette);

    return GtCard(
      padding: context.insets.allDp(12.px),
      variant: variant,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: context.spacingMd,
        children: [
          Row(
            spacing: context.spacingsectionMd,
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  spacing: context.spacingSm,
                  crossAxisAlignment: .stretch,
                  children: [
                    GtText(title.upper, style: context.textStyles.buttonS()),
                    GtText(
                      subtitle,
                      style: context.textStyles.subHead2xs(
                        color: palette.text.sub,
                      ),
                    ),
                  ],
                ),
              ),
              FractionalTranslation(
                translation: Offset(0, -.15),
                child: Column(
                  mainAxisAlignment: .start,
                  children: [
                    GtText(
                      "$percentage%",
                      style: context.textStyles.h4(color: valueColor),
                    ),
                    GtText(
                      percentSubtext,
                      style: context.textStyles.buttonXs(
                        color: palette.text.sub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GtAnimatedProgress(
            value: fraction,
            valueColor: valueColor,
            inActiveColor: palette.bg.soft,
          ),
          const GtGap.yMd(),
          GtRaisedButton(
            onPressed: onContinue,
            variant: variant.buttonVariant,
            text: continueText,
            size: .xsmall,
            alignment: .centerLeft,
          ),
        ],
      ),
    );
  }
}
