import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A single label/value row within a receipt or confirmation card.
///
/// Renders [GtReceiptTileData] as a [GtDoubleColumnListTile] with the label
/// emphasised over the value. When the tile carries an `image`, it is rendered
/// as a 20dp suffix after the value; when it carries an `onTap`, the row is
/// wrapped in a [GtInkWell] (commonly used for tap-to-copy on references and
/// session IDs).
///
/// Shared by [GtReceiptBody] and [GtConfirmationBody].
class GtReceiptDetailTile extends GtStatelessWidget {
  /// The label, value, optional image and optional tap handler for this row.
  final GtReceiptTileData tile;

  /// Creates a [GtReceiptDetailTile].
  const GtReceiptDetailTile(this.tile, {super.key});

  @override
  Widget build(BuildContext context) {
    final imageSize = context.dp(20.px);
    final suffix = tile.image != null
        ? GtImage(image: tile.image!, width: imageSize, height: imageSize)
        : null;

    final child = GtDoubleColumnListTile(
      tile.label,
      value: tile.value,
      valueSuffix: suffix,
      highlightValue: false,
    );

    if (tile.onTap != null) {
      return GtInkWell(
        onTap: tile.onTap,
        borderRadius: context.borderRadiusSm,
        child: child,
      );
    }

    return child;
  }
}

/// The status pill displayed at the head of a receipt or confirmation screen.
///
/// Renders [GtReceiptStatusData] as an uppercased [GtStatusPill] whose variant,
/// icon and colours are derived from the status. The
/// [GtReceiptStatus.processing] status swaps the leading icon for a [GtSpinner]
/// to convey in-flight work. When the status carries an `onPressed`, the pill
/// is wrapped in a [GtInkWell].
///
/// Shared by [GtReceiptBody] and [GtConfirmationBody].
class GtReceiptStatusPill extends GtStatelessWidget {
  /// The status, optional custom title and optional tap handler for the pill.
  final GtReceiptStatusData status;

  /// Creates a [GtReceiptStatusPill].
  const GtReceiptStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final text = status.displayTitle;
    final borderColor = status.borderColor(context.palette);
    final padding = context.insets.symmetricDp(
      vertical: 6.px,
      horizontal: 8.px,
    );

    Color textColor = status.variant.getTextColor(context.palette);
    final iconSize = context.dp(13.px);
    Widget leading = GtIcon.withColor(
      status.icon ?? GtIcons.alert,
      color: textColor,
      size: iconSize,
    );

    if (status.variant == GtPillVariant.away) {
      leading = GtSquareConstrainedBox(
        iconSize,
        child: GtSpinner(
          size: iconSize,
          color: context.palette.away.base,
          strokeWidth: context.dp(2.px),
        ),
      );
      textColor = context.palette.away.base;
    }

    final pill = GtStatusPill.custom(
      text: text.upper,
      leading: leading,
      variant: status.variant,
      alignment: .centerLeft,
      textColor: textColor,
      borderColor: borderColor,
      padding: padding,
    );

    if (status.onPressed != null) {
      return GtInkWell(onTap: status.onPressed, child: pill);
    }

    return pill;
  }
}
