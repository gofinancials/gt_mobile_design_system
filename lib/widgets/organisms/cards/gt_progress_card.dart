import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that prompts the user to take one or two actions (e.g., a primary
/// action and a dismiss option).
class GtProgressCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// Overrides percentage style. Null preserves the current default.
  final TextStyle? percentageStyle;

  /// Overrides percentage color. Null preserves the current default.
  final Color? percentageColor;

  /// Overrides percent subtext style. Null preserves the current default.
  final TextStyle? percentSubtextStyle;

  /// Overrides percent subtext color. Null preserves the current default.
  final Color? percentSubtextColor;

  /// Overrides progress color. Null preserves the current default.
  final Color? progressColor;

  /// Overrides track color. Null preserves the current default.
  final Color? trackColor;

  /// Overrides button variant. Null preserves the current default.
  final GtButtonVariant? buttonVariant;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides text spacing in logical pixels. Null preserves the current default.
  final double? textSpacing;

  /// Overrides action spacing in logical pixels. Null preserves the current default.
  final double? actionSpacing;

  /// Overrides button color. Null preserves the current default.
  final Color? buttonColor;

  /// Overrides button text color. Null preserves the current default.
  final Color? buttonTextColor;

  /// Overrides button style. Null preserves the current default.
  final TextStyle? buttonStyle;

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
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.percentageStyle,
    this.percentageColor,
    this.percentSubtextStyle,
    this.percentSubtextColor,
    this.progressColor,
    this.trackColor,
    this.buttonVariant,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.textSpacing,
    this.actionSpacing,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonStyle,
  }) : assert(
         currentValue <= maxValue,
         'Current value should be equal or less than max value',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueColor = variant.getProgressColor(palette);

    return GtCard(
      color: backgroundColor,
      padding: padding ?? context.insets.allDp(12.px),
      variant: variant,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: verticalSpacing ?? context.spacingMd,
        children: [
          Row(
            spacing: horizontalSpacing ?? context.spacingSectionMd,
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  spacing: textSpacing ?? context.spacingSm,
                  crossAxisAlignment: .stretch,
                  children: [
                    GtText(
                      title.upper,
                      style: GtTextStyleOverrides.resolve(
                        titleStyle,
                        context.textStyles.buttonS(),
                        titleColor,
                      ),
                    ),
                    GtText(
                      subtitle,
                      style: GtTextStyleOverrides.resolve(
                        subtitleStyle,
                        context.textStyles.subHead2xs(color: palette.text.sub),
                        subtitleColor,
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
                      style: GtTextStyleOverrides.resolve(
                        percentageStyle,
                        context.textStyles.h4(color: valueColor),
                        percentageColor,
                      ),
                    ),
                    GtText(
                      percentSubtext,
                      style: GtTextStyleOverrides.resolve(
                        percentSubtextStyle,
                        context.textStyles.buttonXs(color: palette.text.sub),
                        percentSubtextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GtAnimatedProgress(
            value: fraction,
            valueColor: progressColor ?? valueColor,
            inActiveColor: trackColor ?? palette.bg.soft,
          ),
          (actionSpacing == null
              ? const GtGap.yMd()
              : SizedBox(height: actionSpacing)),
          GtRaisedButton(
            color: buttonColor,
            textColor: buttonTextColor,
            style: buttonStyle,
            onPressed: onContinue,
            variant: buttonVariant ?? variant.buttonVariant,
            text: continueText,
            size: .xsmall,
            alignment: .centerLeft,
          ),
        ],
      ),
    );
  }
}
