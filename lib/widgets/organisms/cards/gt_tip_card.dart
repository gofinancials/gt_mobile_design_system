import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying tips or informational messages, often with a border and an icon.
class GtTipCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides border color. Null preserves the current default.
  final Color? borderColor;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides close button spacing in logical pixels. Null preserves the current default.
  final double? closeButtonSpacing;

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
    this.backgroundColor,
    this.padding,
    this.borderColor,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.closeButtonSpacing,
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
        color: backgroundColor,
        borderRadius: context.borderRadiusXl,
        padding:
            padding ??
            context.insets.symmetricDp(horizontal: 12.px, vertical: 16.px),
        border: BorderSide(color: this.borderColor ?? borderColor),
        variant: variant,
        child: Row(
          spacing: horizontalSpacing ?? context.spacingBase,
          crossAxisAlignment: .start,
          children: [
            GtIcon.withColor(
              icon,
              color: this.iconColor ?? iconColor,
              size: iconSize ?? context.dp(20.px),
              alignment: .topLeft,
            ),
            Expanded(
              child: Column(
                spacing: verticalSpacing ?? context.spacingSm,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: closeButtonSpacing ?? context.spacingBase,
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: GtText(
                          title,
                          style: GtTextStyleOverrides.resolve(
                            titleStyle,
                            context.textStyles.bodyS(),
                            titleColor,
                          ),
                        ),
                      ),
                      GtCancelButton(
                        onTap: onClose,
                        size: .xSmall,
                        color: palette.text.soft,
                      ),
                    ],
                  ),
                  GtRichText(
                    subtitle,
                    style: GtTextStyleOverrides.resolve(
                      subtitleStyle,
                      subStyle,
                      subtitleColor,
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
