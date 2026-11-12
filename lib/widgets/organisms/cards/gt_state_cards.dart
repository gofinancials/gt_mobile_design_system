import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget that displays an empty state message, typically used when there is no data to show.
///
/// From the top: an [icon] or [image], an optional bold [title], the grey
/// [description], and an optional [footer] such as a button. With a [title],
/// the title and description sit together as one block, 4dp apart, as in the
/// Flex invoicing lists' "You don't have any item" card.
class GtEmptyStateCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// An optional heading drawn between the [icon] or [image] and the
  /// [description], such as "You don't have any item". If null, no title is
  /// shown and the card looks as it does without one.
  final String? title;

  /// The text style to apply to the [title]. Defaults to
  /// [GtTextStyles.labelS] at weight 600, as [GtActionableEmptyStateCard]
  /// draws its title.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

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

  /// The space between the description and the [footer]. Defaults to
  /// [spacing], so a card that sets only [spacing] keeps one gap throughout.
  ///
  /// Set it where the design separates the button more than the icon, such as
  /// the Flex invoicing lists' empty cards: 8dp under the icon and 12dp above
  /// the button.
  final double? footerSpacing;

  /// The padding to apply to the card. Defaults to [context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px)].
  final EdgeInsetsGeometry? padding;

  /// The text style to apply to the description. Defaults to [GtTextStyles.bodyXs] at weight 500, in the palette's sub text colour.
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
    this.footerSpacing,
    this.padding,
    this.footer,
    this.iconSize,
    this.style,
    this.backgroundColor,
    this.descriptionColor,
    this.iconColor,
    this.title,
    this.titleStyle,
    this.titleColor,
  }) : image = null;

  /// Creates a [GtEmptyStateCard] headed by [image] instead of an icon.
  const GtEmptyStateCard.image({
    super.key,
    required this.image,
    required this.description,
    this.spacing,
    this.footerSpacing,
    this.padding,
    this.variant = .normal,
    this.footer,
    this.style,
    this.backgroundColor,
    this.descriptionColor,
    this.iconColor,
    this.title,
    this.titleStyle,
    this.titleColor,
  }) : icon = null,
       iconSize = null;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.insets.symmetricDp(
      vertical: 24.px,
      horizontal: 16.px,
    );
    final defaultStyle = context.textStyles.bodyXs(
      color: context.palette.text.sub,
      weight: .w500,
    );
    final defaultIconSize = context.dp(24.px);
    final gap = spacing ?? context.spacingBase;

    Widget text = GtText(
      description,
      style: GtTextStyleOverrides.resolve(
        style,
        defaultStyle,
        descriptionColor,
      ),
      textAlign: .center,
    );
    if (title case final String title) {
      // The title and description read as one block, closer to each other
      // than to the icon above or the footer below.
      text = Column(
        spacing: context.spacingSm,
        mainAxisSize: .min,
        children: [
          GtText(
            title,
            style: GtTextStyleOverrides.resolve(
              titleStyle,
              context.textStyles.labelS(weight: .w600),
              titleColor,
            ),
            textAlign: .center,
          ),
          text,
        ],
      );
    }

    final content = <Widget>[
      if (icon != null)
        iconColor == null
            ? GtIcon(icon!, size: iconSize ?? defaultIconSize)
            : GtIcon.withColor(
                icon!,
                color: iconColor!,
                size: iconSize ?? defaultIconSize,
              ),
      ?image,
      text,
    ];

    return GtCard(
      variant: variant,
      color: backgroundColor,
      padding: padding ?? defaultPadding,
      // Gaps are laid explicitly rather than through the column's spacing,
      // so the one above the footer can differ from the rest.
      child: Column(
        mainAxisAlignment: .center,
        children: [
          for (final (index, child) in content.indexed) ...[
            if (index > 0) SizedBox(height: gap),
            child,
          ],
          if (footer case final footer?) ...[
            SizedBox(height: footerSpacing ?? gap),
            footer,
          ],
        ],
      ),
    );
  }
}

/// A card widget that displays an empty state message alongside a call-to-action button.
/// Typically used when there is no data to show, but the user can take an action to resolve it.
class GtActionableEmptyStateCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides description style. Null preserves the current default.
  final TextStyle? descriptionStyle;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides icon spacing in logical pixels. Null preserves the current default.
  final double? iconSpacing;

  /// Overrides action spacing in logical pixels. Null preserves the current default.
  final double? actionSpacing;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

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
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.descriptionStyle,
    this.descriptionColor,
    this.verticalSpacing,
    this.iconSpacing,
    this.actionSpacing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GtCard(
      color: backgroundColor,
      variant: variant,
      padding:
          padding ??
          context.insets.symmetricDp(vertical: 24.px, horizontal: 12.px),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          iconColor == null
              ? GtIcon(icon, size: 32)
              : GtIcon.withColor(icon, color: iconColor!, size: 32),
          (iconSpacing == null
              ? const GtGap.yBase()
              : SizedBox(height: iconSpacing)),
          GtText(
            title,
            style: GtTextStyleOverrides.resolve(
              titleStyle,
              context.textStyles.labelS(weight: .w600),
              titleColor,
            ),
            textAlign: .center,
          ),
          (verticalSpacing == null
              ? const GtGap.ySm()
              : SizedBox(height: verticalSpacing)),
          GtText(
            description,
            style: GtTextStyleOverrides.resolve(
              descriptionStyle,
              context.textStyles.subHead2xs(color: context.palette.text.sub),
              descriptionColor,
            ),
            textAlign: .center,
          ),
          if (actionSpacing == null)
            ...const GtGap.yBase() * 2
          else
            SizedBox(height: actionSpacing),
          GtRaisedButton(onPressed: onPressed, text: buttontext, size: .xsmall),
        ],
      ),
    );
  }
}
