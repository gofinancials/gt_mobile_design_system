import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A single label/value row within a summary card.
///
/// Renders [GtSummaryTileData] in one of two layouts:
/// - [GtSummaryTileLayout.columns] puts the label and value side by side as a
///   [GtDoubleColumnListTile], with the value emphasised over the label. This
///   is the inverse of [GtReceiptDetailTile], which emphasises the label
///   because a receipt is read label-first.
/// - [GtSummaryTileLayout.stacked] puts the label above the value as a
///   [GtInfoListTile], for values with no room in a right-hand column.
///
/// In the columns layout the tile's images bracket the value rather than
/// following it, so a bank logo or recipient avatar leads the name it belongs
/// to while a category glyph trails it. The stacked layout has no image slots,
/// which is why [GtSummaryTileData.leading] and [GtSummaryTileData.trailing]
/// document themselves as ignored there.
class GtSummaryTile extends GtStatelessWidget {
  /// The label, value, optional images and optional tap handler for this row.
  final GtSummaryTileData tile;

  /// How the row is arranged. Defaults to [GtSummaryTileLayout.columns].
  final GtSummaryTileLayout layout;

  /// Creates a [GtSummaryTile].
  const GtSummaryTile(this.tile, {super.key, this.layout = .columns});

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (layout) {
      .columns => _GtSummaryColumnsTile(tile),
      .stacked => _GtSummaryStackedTile(tile),
    };

    // The stacked layout is a GtInfoListTile, which wires up its own ink well.
    if (tile.onTap != null && layout == .columns) {
      return GtInkWell(
        role: .button,
        onTap: tile.onTap,
        borderRadius: context.borderRadiusSm,
        child: child,
      );
    }

    return child;
  }
}

/// The side-by-side layout, with the value emphasised over the label.
class _GtSummaryColumnsTile extends GtStatelessWidget {
  /// The label, value and optional images for this row.
  final GtSummaryTileData tile;

  const _GtSummaryColumnsTile(this.tile);

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final leading = tile.leading;
    final trailing = tile.trailing;

    return GtDoubleColumnListTile(
      tile.label,
      value: tile.value,
      // Left null rather than given an empty widget, because the tile uses the
      // absence of a slot to decide its own spacing.
      valuePrefix: leading == null ? null : _GtSummaryTileImage(leading),
      valueSuffix: trailing == null ? null : _GtSummaryTileImage(trailing),
      labelTextStyle: styles.subHeadXs(color: context.palette.text.sub),
      valueTextStyle: styles.subHeadS(color: tile.valueColor),
      valueMaxLines: 1,
    );
  }
}

/// A bank logo, recipient avatar or category glyph bracketing the value.
class _GtSummaryTileImage extends GtStatelessWidget {
  /// The image to render.
  final AppImageData data;

  const _GtSummaryTileImage(this.data);

  @override
  Widget build(BuildContext context) {
    final size = context.dp(20.px);

    return GtImage(
      image: data,
      width: size,
      height: size,
      // The label and value beside it already name what the image depicts.
      isDecorative: true,
    );
  }
}

/// The stacked layout, with the label above the value.
class _GtSummaryStackedTile extends GtStatelessWidget {
  /// The label, value and optional tap handler for this row.
  final GtSummaryTileData tile;

  const _GtSummaryStackedTile(this.tile);

  @override
  Widget build(BuildContext context) {
    return GtInfoListTile(
      tile.label,
      text: tile.value,
      onTap: tile.onTap,
      textStyle: context.textStyles.subHeadM(color: tile.valueColor),
    );
  }
}
