import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget used to display instructions or prompts for the user to take a
/// specific action, such as uploading a document or taking a photo.
class GtInstructionCard extends GtStatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);
    final bgColor = variant.getBgColor(palette);
    final textColor = variant.getTextColor(palette);
    final iconColor = variant.getIconColor(palette);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: GtCard(
        color: isFilled ? bgColor : Colors.transparent,
        border: isFilled
            ? BorderSide.none
            : BorderSide(color: borderColor, width: 1.5),
        borderRadius: context.borderRadiusXl,
        padding: context.insets.allDp(32.px),
        child: Column(
          spacing: context.spacingBase,
          mainAxisAlignment: .center,
          children: [
            icon,
            const GtGap.yMd(),
            GtText(
              title,
              style: context.textStyles.subHeadS(color: textColor),
              textAlign: .center,
            ),
            GtText(
              description,
              style: context.textStyles.body2Xs(color: iconColor),
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
