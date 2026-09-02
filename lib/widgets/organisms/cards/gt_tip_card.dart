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

  /// An optional custom text style for the [title].
  final TextStyle? titleStyle;

  /// An optional custom text style for the [subtitle].
  final TextStyle? subtitleStyle;

  /// The icon to display in the tip card. Default is [GtIcons.circleInfo]
  final IconData icon;

  /// The size of the icon. Default is 20
  final double? iconSize;

  /// Creates a [GtTipCard].
  const GtTipCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    required this.onClose,
    this.titleStyle,
    this.subtitleStyle,
    this.icon = GtIcons.circleInfo,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = variant.getIconColor(palette);
    final borderColor = variant.getBorderColor(palette);
    final subStyle = context.textStyles.bodyXs(color: palette.text.darkerSub);

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
              icon,
              color: iconColor,
              size: iconSize ?? context.dp(20.px),
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
                      Expanded(child: GtText(title, style: titleStyle)),
                      GtCancelButton(
                        onTap: onClose,
                        size: .xSmall,
                        color: palette.text.soft,
                      ),
                    ],
                  ),
                  GtRichText(subtitle, style: subtitleStyle ?? subStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
