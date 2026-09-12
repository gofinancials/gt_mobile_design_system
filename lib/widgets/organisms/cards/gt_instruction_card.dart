import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget used to display instructions or prompts for the user to take a
/// specific action, such as uploading a document or taking a photo.
class GtInstructionCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides the outlined border colour. Ignored while [isFilled] is true.
  final Color? borderColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides description style. Null preserves the current default.
  final TextStyle? descriptionStyle;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// Overrides icon spacing in logical pixels. Null preserves the current default.
  final double? iconSpacing;

  /// The primary widget, typically an icon, displayed at the top of the card.
  final Widget icon;

  /// The primary title or heading of the instruction.
  final String title;

  /// A detailed description providing further context or instructions.
  final String description;

  /// The visual variant of the card, determining its background and border styles.
  /// Defaults to [GtCardVariant.normal].
  final GtCardVariant variant;

  /// Whether the card should have a filled background instead of an outlined border.
  /// Defaults to false.
  final bool isFilled;

  /// The callback triggered when the card is tapped. Provides light haptic feedback.
  final OnPressed onPressed;

  /// Creates a [GtInstructionCard].
  const GtInstructionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    this.variant = .normal,
    this.isFilled = false,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.verticalSpacing,
    this.titleStyle,
    this.titleColor,
    this.descriptionStyle,
    this.descriptionColor,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);
    final bgColor = variant.getBgColor(palette);
    final textColor = variant.getTextColor(palette);
    final iconColor = variant.getIconColor(palette);

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusXl,
      onTap: onPressed,
      child: GtCard(
        color: backgroundColor ?? (isFilled ? bgColor : Colors.transparent),
        border: isFilled
            ? BorderSide.none
            : BorderSide(color: this.borderColor ?? borderColor, width: 1.5),
        borderRadius: context.borderRadiusXl,
        padding: padding ?? context.insets.allDp(32.px),
        child: Column(
          spacing: verticalSpacing ?? context.spacingBase,
          mainAxisAlignment: .center,
          children: [
            icon,
            (iconSpacing == null
                ? const GtGap.yMd()
                : SizedBox(height: iconSpacing)),
            GtText(
              title,
              style: GtTextStyleOverrides.resolve(
                titleStyle,
                context.textStyles.subHeadS(color: textColor),
                titleColor,
              ),
              textAlign: .center,
            ),
            GtText(
              description,
              style: GtTextStyleOverrides.resolve(
                descriptionStyle,
                context.textStyles.body2Xs(color: iconColor),
                descriptionColor,
              ),
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
