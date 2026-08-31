import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget that displays an empty state message, typically used when there is no data to show.
class GtEmptyStateCard extends GtStatelessWidget {
  /// The icon to display above the description. If null, no icon is shown.
  final IconData? icon;

  /// The text description explaining the empty state.
  final String description;

  /// The visual variant of the card, determining its background and border styles.
  /// Defaults to [GtCardVariant.normal].
  final GtCardVariant variant;

  /// A widget to display above the description. If null, no widget is shown.
  final Widget? image;

  /// A widget to display above the description. If null, no widget is shown.
  final Widget? footer;

  /// The space between the icon and the description. Defaults to [context.spacingBase].
  final double? spacing;

  /// The padding to apply to the card. Defaults to [context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px)].
  final EdgeInsetsGeometry? padding;

  /// The text style to apply to the description. Defaults to [context.textStyles.subHeadXs(color: context.palette.text.sub)].
  final TextStyle? style;

  /// The size of the icon. Defaults to 24.
  final double? iconSize;

  /// Creates a [GtEmptyStateCard].
  const GtEmptyStateCard({
    super.key,
    required this.icon,
    required this.description,
    this.variant = .normal,
    this.spacing,
    this.padding,
    this.footer,
    this.iconSize,
    this.style,
  }) : image = null;

  const GtEmptyStateCard.image({
    super.key,
    required this.image,
    required this.description,
    this.spacing,
    this.padding,
    this.variant = .normal,
    this.footer,
    this.style,
  }) : icon = null,
       iconSize = null;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.insets.symmetricDp(
      vertical: 24.px,
      horizontal: 16.px,
    );
    final defaultStyle = context.textStyles.subHeadXs(
      color: context.palette.text.sub,
    );
    final defaultIconSize = context.dp(24.px);

    return GtCard(
      variant: variant,
      padding: padding ?? defaultPadding,
      child: Column(
        spacing: spacing ?? context.spacingBase,
        mainAxisAlignment: .center,
        children: [
          if (icon != null) GtIcon(icon!, size: iconSize ?? defaultIconSize),
          ?image,
          GtText(description, style: style ?? defaultStyle, textAlign: .center),
          ?footer,
        ],
      ),
    );
  }
}

/// A card widget that displays an empty state message alongside a call-to-action button.
/// Typically used when there is no data to show, but the user can take an action to resolve it.
class GtActionableEmptyStateCard extends GtStatelessWidget {
  /// The icon displayed at the top of the card.
  final IconData icon;

  /// The primary title or heading of the empty state.
  final String title;

  /// A detailed description providing further context about the empty state.
  final String description;

  /// The visual variant of the card, determining its background and border styles.
  /// Defaults to [GtCardVariant.normal].
  final GtCardVariant variant;

  /// Whether the card should have a filled background instead of an outlined border.
  /// Defaults to false.
  final bool isFilled;

  /// The callback triggered when the action button is tapped.
  final OnPressed onPressed;

  /// The text to display on the action button.
  final String? buttontext;

  /// Creates a [GtActionableEmptyStateCard].
  const GtActionableEmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.buttontext,
    this.variant = .normal,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GtCard(
      variant: variant,
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 12.px),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          GtIcon(icon, size: 32),
          const GtGap.yBase(),
          GtText(
            title,
            style: context.textStyles.subHeadS(),
            textAlign: .center,
          ),
          const GtGap.ySm(),
          GtText(
            description,
            style: context.textStyles.subHead2xs(
              color: context.palette.text.sub,
            ),
            textAlign: .center,
          ),
          ...const GtGap.yBase() * 2,
          GtRaisedButton(onPressed: onPressed, text: buttontext, size: .xsmall),
        ],
      ),
    );
  }
}
