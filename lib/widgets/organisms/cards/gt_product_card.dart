import 'package:flutter/material.dart';
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

    return GtCard(
      padding: context.insets.allDp(12.px),
      variant: variant,
      onPressed: onTap,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        spacing: context.spacingSm,
        mainAxisSize: .min,
        children: [
          GtIcon.withColor(icon, color: iconColor, size: 24),
          if (footer == null) const Spacer() else const GtGap.ySm(),
          GtText(name, style: context.textStyles.subHeadS(), maxLines: 1),
          ?footer,
        ],
      ),
    );
  }
}

/// A full-width product row: a name and an optional description between
/// optional [leading] and [trailing] widgets.
///
/// Where [GtProductCard] is a compact tile for a grid, this is a row for a
/// list. The text column takes all the width [leading] and [trailing] leave,
/// so the card needs a bounded width — it cannot sit in a horizontally
/// scrolling list or directly inside another [Row] without an [Expanded].
///
/// The name is capped at one line; the description wraps freely. The text
/// column hugs its content, so by default it is pinned to the top beside a
/// taller [leading] — set [rowAlignment] to [CrossAxisAlignment.center] to
/// centre it instead.
///
/// [variant] only sets the background, which [color] overrides; the text
/// colours do not follow it. With [onTap] set, the whole card is a single
/// button announced by its contents, so make the [name] alone identify the
/// product.
///
/// @category Organisms
class GtProductInfoCard extends GtStatelessWidget {
  /// The name of the product or feature.
  ///
  /// Capped at one line, so a long name is cut off rather than wrapped — put
  /// detail in [description] instead. Rendered in [nameStyle].
  final String name;

  /// An optional widget before the text, such as an icon or an avatar.
  ///
  /// Drawn at its own size and lined up against the text by [rowAlignment],
  /// which stretches it to the card's full height when set to
  /// [CrossAxisAlignment.stretch].
  final Widget? leading;

  /// An optional widget after the text, such as a chevron or a status pill.
  ///
  /// Drawn at its own size and lined up against the text by [rowAlignment],
  /// which stretches it to the card's full height when set to
  /// [CrossAxisAlignment.stretch].
  final Widget? trailing;

  /// An optional short description under the [name].
  ///
  /// Wraps across as many lines as it needs. `null` or an empty string leaves
  /// it out, and the name alone fills the text column.
  final String? description;

  /// The visual variant of the card, which sets its background.
  ///
  /// Defaults to [GtCardVariant.normal]. Only the fill follows it — see
  /// [GtCardVariant.getBgColor] — and [color] overrides even that.
  final GtCardVariant variant;

  /// An optional callback invoked when the card is tapped.
  ///
  /// When set, the whole card becomes one button with press feedback. When
  /// `null` the card is inert.
  final OnPressed? onTap;

  /// Overrides the space between the card's edge and its content.
  ///
  /// Defaults to 16dp horizontally and 24dp vertically.
  final EdgeInsetsGeometry? padding;

  /// Overrides the style of the [name].
  ///
  /// Defaults to [GtTextStyles.subHeadS].
  final TextStyle? nameStyle;

  /// Overrides the style of the [description].
  ///
  /// Defaults to [GtTextStyles.subHeadXs] in the palette's sub text colour.
  final TextStyle? descriptionStyle;

  /// Overrides the card's background colour.
  ///
  /// Defaults to the [variant]'s tint from [GtCardVariant.getBgColor].
  final Color? color;

  /// How [leading], the text and [trailing] line up vertically.
  ///
  /// Defaults to [CrossAxisAlignment.start], which pins the text to the top
  /// beside a taller [leading]. [CrossAxisAlignment.stretch] needs the card
  /// to have a bounded height — a fixed-height parent or an [IntrinsicHeight]
  /// — and throws inside an unbounded list without one.
  final CrossAxisAlignment? rowAlignment;

  /// The gap between [leading], the text and [trailing].
  ///
  /// Defaults to the medium spacing token, 12dp. A value given here is used
  /// as-is in logical pixels, so scale it with `context.dp` to match the
  /// responsive default.
  final double? horizontalSpacing;

  /// How the [name] and [description] sit vertically within the text column.
  ///
  /// Defaults to [MainAxisAlignment.center]. The column hugs its content, so
  /// this only has an effect once the column is given spare height — that is,
  /// with [rowAlignment] set to [CrossAxisAlignment.stretch] on a card of
  /// bounded height, beside a [leading] or [trailing] taller than the text.
  final MainAxisAlignment? columnAlignment;

  /// The gap between the [name] and the [description].
  ///
  /// Defaults to the extra-small spacing token, 2dp, and has no effect without
  /// a description. Like [horizontalSpacing], a value given here is used as-is
  /// in logical pixels.
  final double? verticalSpacing;

  /// Creates a [GtProductInfoCard].
  const GtProductInfoCard({
    super.key,
    required this.name,
    this.color,
    this.leading,
    this.trailing,
    this.nameStyle,
    this.descriptionStyle,
    this.description,
    this.padding,
    this.rowAlignment,
    this.horizontalSpacing,
    this.columnAlignment,
    this.verticalSpacing,
    this.variant = .normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final descStyle = context.textStyles.subHeadXs(color: palette.text.sub);
    final defPadding = context.insets.symmetricDp(
      horizontal: 16.px,
      vertical: 24.px,
    );

    Widget? footer;

    if (description.hasValue) {
      footer = GtText(description, style: descriptionStyle ?? descStyle);
    }

    return GtCard(
      padding: padding ?? defPadding,
      variant: variant,
      onPressed: onTap,
      color: color,
      borderRadius: context.borderRadiusXl,
      child: Row(
        crossAxisAlignment: rowAlignment ?? .start,
        spacing: horizontalSpacing ?? context.spacingMd,
        mainAxisSize: .min,
        children: [
          ?leading,
          Expanded(
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisAlignment: columnAlignment ?? .center,
              mainAxisSize: .min,
              spacing: verticalSpacing ?? context.spacingXs,
              children: [
                GtText(
                  name,
                  style: nameStyle ?? context.textStyles.subHeadS(),
                  maxLines: 1,
                ),
                ?footer,
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
