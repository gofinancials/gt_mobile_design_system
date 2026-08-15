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
    final child = switch (layout) {
      .columns => _columns(context),
      .stacked => _stacked(context),
    };

    // The stacked layout is a GtInfoListTile, which wires up its own ink well.
    if (tile.onTap != null && layout == GtSummaryTileLayout.columns) {
      return GtInkWell(
        onTap: tile.onTap,
        borderRadius: context.borderRadiusSm,
        child: child,
      );
    }

    return child;
  }

  Widget _columns(BuildContext context) {
    final styles = context.textStyles;
    final imageSize = context.dp(20.px);

    Widget? image(AppImageData? data) {
      if (data == null) return null;
      return GtImage(image: data, width: imageSize, height: imageSize);
    }

    return GtDoubleColumnListTile(
      tile.label,
      value: tile.value,
      valuePrefix: image(tile.leading),
      valueSuffix: image(tile.trailing),
      labelTextStyle: styles.subHeadXs(color: context.palette.text.sub),
      valueTextStyle: styles.subHeadS(color: tile.valueColor),
      valueMaxLines: 1,
    );
  }

  Widget _stacked(BuildContext context) {
    return GtInfoListTile(
      tile.label,
      text: tile.value,
      onTap: tile.onTap,
      textStyle: context.textStyles.subHeadM(color: tile.valueColor),
    );
  }
}
