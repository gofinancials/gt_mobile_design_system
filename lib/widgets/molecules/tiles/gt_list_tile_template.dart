import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly flexible base template for creating custom list tiles.
///
/// This template accepts arbitrary widgets for its slots ([leading], [title],
/// [subtitle], [trailing], [footer]) and abstracts away common boilerplate such
/// as standard paddings, row/column layouts, optional card wrapping, and haptic
/// feedback on tap.
class GtBaseListTileTemplate extends GtStatelessWidget {
  /// The primary content of the list tile, typically a text widget.
  final Widget title;

  /// Optional secondary content displayed below the title.
  final Widget? subtitle;

  /// An optional widget displayed at the start of the tile (e.g., an icon or avatar).
  final Widget? leading;

  /// An optional widget displayed at the end of the tile (e.g., a chevron or switch).
  final Widget? trailing;

  /// An optional widget displayed beneath the title and subtitle.
  final Widget? footer;

  /// The callback triggered when the tile is tapped. Includes light haptic feedback.
  final OnPressed? onTap;

  /// Vertical alignment of the leading, middle, and trailing elements.
  final CrossAxisAlignment crossAxisAlignment;

  /// Spacing between the leading, middle content, and trailing elements.
  final double? spacing;

  /// Spacing between the title and subtitle, if provided.
  final double? spacingToSubTitle;

  /// Spacing between the title/subtitle to footer, if provided.
  final double? spacingToFooter;

  /// Padding around the entire tile content.
  final EdgeInsetsGeometry? padding;

  /// If true, wraps the entire tile in a [GtCard].
  final bool asCard;

  /// The color of the card, if [asCard] is true.
  final Color? cardColor;

  /// The border radius of the card, if [asCard] is true.
  final BorderRadius? cardBorderRadius;

  /// The padding of the card, if [asCard] is true.
  final EdgeInsetsGeometry? cardPadding;

  /// Creates a [GtBaseListTileTemplate].
  const GtBaseListTileTemplate({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing,
    this.padding,
    this.asCard = false,
    this.cardColor,
    this.cardBorderRadius,
    this.cardPadding,
    this.spacingToFooter,
    this.spacingToSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        if (subtitle != null) ...[
          GtSizedBox(height: spacingToSubTitle ?? context.spacingXs),
          subtitle!,
        ],
        if (footer != null) ...[
          GtSizedBox(height: spacingToFooter ?? context.spacingSm),
          footer!,
        ],
      ],
    );

    Widget row = Row(
      spacing: spacing ?? context.spacingMd,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        ?leading,
        Expanded(child: content),
        ?trailing,
      ],
    );

    Widget child = Padding(
      padding: padding ?? context.insets.symmetricDp(vertical: 8.px),
      child: row,
    );

    if (asCard) {
      child = GtCard(
        color: cardColor,
        borderRadius: cardBorderRadius,
        padding: cardPadding,
        child: child,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: child,
      );
    }

    return child;
  }
}

/// A streamlined template tailored for text-based list tiles.
///
/// Automatically applies the design system's typography and palette to string
/// inputs for [title] and [subtitle], utilizing [GtBaseListTileTemplate] under
/// the hood.
class GtStandardTextTileTemplate extends GtStatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final OnPressed? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool asCard;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? cardColor;
  final BorderRadius? cardBorderRadius;
  final EdgeInsetsGeometry? cardPadding;

  const GtStandardTextTileTemplate({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.onTap,
    this.titleStyle,
    this.subtitleStyle,
    this.asCard = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cardColor,
    this.cardBorderRadius,
    this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = context.textStyles.subHeadS();
    final defaultSubStyle = context.textStyles.bodyXs(
      color: context.palette.text.sub,
    );

    return GtBaseListTileTemplate(
      title: GtText(title, style: titleStyle ?? defaultTitleStyle),
      subtitle: subtitle.hasValue
          ? GtText(subtitle, style: subtitleStyle ?? defaultSubStyle)
          : null,
      leading: leading,
      trailing: trailing,
      footer: footer,
      onTap: onTap,
      asCard: asCard,
      crossAxisAlignment: crossAxisAlignment,
      cardColor: cardColor,
      cardBorderRadius: cardBorderRadius,
      cardPadding: cardPadding,
    );
  }
}
