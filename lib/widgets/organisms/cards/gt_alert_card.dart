import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying alerts, typically with an icon, title, and subtitle,
/// and a distinct border.
class GtAlertCard extends GtStatelessWidget {
  /// The main title of the alert.
  final String title;

  /// The secondary text or subtitle of the alert.
  final String? subtitle;

  /// The icon to display in the alert card.
  final IconData icon;

  /// The visual variant of the card, which determines its background, border, and icon colors.
  final GtCardVariant variant;

  /// Creates a [GtAlertCard].
  const GtAlertCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.variant = .away,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);

    return GtCard(
      padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 12.px),
      variant: variant,
      border: BorderSide(color: borderColor),
      child: Row(
        crossAxisAlignment: .center,
        spacing: context.spacingMd,
        children: [
          GtSquareConstrainedBox(
            36,
            child: GtAlertIconCard(icon: icon, variant: variant),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                GtText(title, style: context.textStyles.bodyM()),
                GtText(
                  subtitle,
                  style: context.textStyles.body2Xs(color: palette.text.soft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GtAlertIconCard extends GtStatelessWidget {
  final IconData icon;
  final GtCardVariant variant;

  const GtAlertIconCard({super.key, required this.icon, this.variant = .away});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = variant.getTextColor(palette);
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: GtCard(
        borderRadius: context.borderRadiusXl,
        color: palette.bg.white,
        padding: .zero,
        child: Stack(
          children: [
            Positioned(
              top: context.dp(4.px),
              right: context.dp(4.px),
              child: GtSquareConstrainedBox(
                4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: palette.error.base,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GtIcon.withColor(
                icon,
                size: 24,
                color: iconColor,
                alignment: .center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
