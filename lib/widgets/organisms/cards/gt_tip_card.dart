import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying tips or informational messages, often with a border and an icon.
class GtTipCard extends GtStatelessWidget {
  /// The main title of the tip.
  final String title;

  /// The secondary text or subtitle of the tip.
  final String subtitle;

  /// If true, the tip card will be hidden (faded out).
  final bool hidden;

  /// The visual variant of the card, which determines its background, border, and icon colors.
  final GtCardVariant variant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// Creates a [GtTipCard].
  const GtTipCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = variant.getIconColor(palette);
    final borderColor = variant.getBorderColor(palette);

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        borderRadius: context.borderRadiusXl,
        padding: context.insets.symmetricDp(horizontal: 12.px, vertical: 16.px),
        border: BorderSide(color: borderColor),
        variant: variant,
        child: Row(
          spacing: context.spacingBase,
          crossAxisAlignment: .start,
          children: [
            GtIcon.withColor(
              GtIcons.circleInfo,
              color: iconColor,
              size: 20,
              alignment: .topLeft,
            ),
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: context.spacingBase,
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(child: GtText(title)),
                      GtCancelButton(
                        onTap: onClose,
                        size: 16,
                        color: palette.text.soft,
                      ),
                    ],
                  ),
                  GtText(
                    subtitle,
                    style: context.textStyles.bodyXs(
                      color: palette.text.darkerSub,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
