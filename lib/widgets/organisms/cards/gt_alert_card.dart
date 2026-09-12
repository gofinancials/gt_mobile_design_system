import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying alerts, typically with an icon, title, and subtitle,
/// and a distinct border.
class GtAlertCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides border color. Null preserves the current default.
  final Color? borderColor;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

  /// Overrides icon background color. Null preserves the current default.
  final Color? iconBackgroundColor;

  /// Overrides indicator color. Null preserves the current default.
  final Color? indicatorColor;

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
    this.backgroundColor,
    this.padding,
    this.borderColor,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.iconColor,
    this.iconBackgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);

    return GtCard(
      color: backgroundColor,
      padding:
          padding ??
          context.insets.symmetricDp(horizontal: 8.px, vertical: 12.px),
      variant: variant,
      border: BorderSide(color: this.borderColor ?? borderColor),
      child: Row(
        crossAxisAlignment: .center,
        spacing: horizontalSpacing ?? context.spacingMd,
        children: [
          GtSquareConstrainedBox(
            36,
            child: GtAlertIconCard(
              icon: icon,
              variant: variant,
              iconColor: iconColor,
              backgroundColor: iconBackgroundColor,
              indicatorColor: indicatorColor,
            ),
          ),
          Expanded(
            child: Column(
              spacing: verticalSpacing ?? 0,
              crossAxisAlignment: .start,
              children: [
                GtText(
                  title,
                  style: GtTextStyleOverrides.resolve(
                    titleStyle,
                    context.textStyles.bodyM(),
                    titleColor,
                  ),
                ),
                GtText(
                  subtitle,
                  style: GtTextStyleOverrides.resolve(
                    subtitleStyle,
                    context.textStyles.body2Xs(color: palette.text.soft),
                    subtitleColor,
                  ),
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
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides indicator color. Null preserves the current default.
  final Color? indicatorColor;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

  final IconData icon;
  final GtCardVariant variant;

  const GtAlertIconCard({
    this.backgroundColor,
    this.indicatorColor,
    this.iconColor,
    super.key,
    required this.icon,
    this.variant = .away,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = variant.getTextColor(palette);
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: GtCard(
        borderRadius: context.borderRadiusXl,
        color: backgroundColor ?? palette.bg.white,
        padding: .zero,
        child: Stack(
          children: [
            Positioned(
              top: context.dp(6.px),
              right: context.dp(6.px),
              child: GtSquareConstrainedBox(
                4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: indicatorColor ?? palette.error.base,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GtIcon.withColor(
                icon,
                size: 24,
                color: this.iconColor ?? iconColor,
                alignment: .center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
