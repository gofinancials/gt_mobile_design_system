import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card used to represent a product or feature, usually in a grid.
class GtProductCard extends GtStatelessWidget {
  /// The name of the product or feature.
  final String name;

  /// The icon representing the product.
  final IconData icon;

  /// An optional short description of the product.
  final String? description;

  /// The visual variant of the card.
  final GtCardVariant variant;

  /// An optional callback function that is invoked when the card is tapped.
  final OnPressed? onTap;

  /// Creates a [GtProductCard].
  const GtProductCard({
    super.key,
    required this.name,
    required this.icon,
    this.description,
    this.variant = .normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = variant.getIconColor(palette);

    Widget? footer;

    if (description.hasValue) {
      footer = GtText(
        description,
        style: context.textStyles.body3Xs(color: palette.text.sub),
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: variant,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          spacing: context.spacingSm,
          mainAxisSize: .min,
          children: [
            GtIcon.withColor(icon, color: iconColor, size: 24),
            if (footer == null) const Spacer() else const GtGap.ySm(),
            GtText(name, style: context.textStyles.subHeadS()),
            ?footer,
          ],
        ),
      ),
    );
  }
}
