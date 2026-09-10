import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A single label/value row within a receipt, confirmation or transfer detail
/// card.
///
/// Renders [GtReceiptTileData] as a [GtDoubleColumnListTile]. When the tile
/// carries an `image`, it is rendered as a 20dp image beside the value, placed
/// by [imagePosition]; when it carries an `onTap`, the row is wrapped in a
/// [GtInkWell] (commonly used for tap-to-copy on references and session IDs);
/// and when it carries an `onInfoTap`, a tappable [GtIcons.info] glyph follows
/// the label.
///
/// Shared by [GtReceiptBody], [GtConfirmationBody] and [GtTransferDetailBody].
class GtReceiptDetailTile extends GtStatelessWidget {
  /// The label, value, optional image and optional tap handlers for this row.
  final GtReceiptTileData tile;

  /// Whether the value is emphasised over the label.
  ///
  /// Defaults to `false`: a strong label over a soft value, as on
  /// [GtReceiptBody] and [GtConfirmationBody]. [GtTransferDetailBody] passes
  /// `true` for a soft label over a strong value.
  final bool highlightValue;

  /// Where the tile's image sits relative to the value.
  ///
  /// Defaults to [GtReceiptTileImagePosition.trailing].
  final GtReceiptTileImagePosition imagePosition;

  /// Creates a [GtReceiptDetailTile].
  const GtReceiptDetailTile(
    this.tile, {
    super.key,
    this.highlightValue = false,
    this.imagePosition = .trailing,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = context.dp(20.px);
    final image = tile.image != null
        ? GtImage(
            image: tile.image!,
            width: imageSize,
            height: imageSize,
            isDecorative: true,
          )
        : null;

    Widget? info;
    if (tile.onInfoTap != null) {
      info = GtTapTarget(
        child: GtInkWell(
          key: const Key('receipt-tile-info'),
          role: .button,
          onTap: tile.onInfoTap,
          semanticsLabel: tile.displayInfoSemanticsLabel,
          excludeDescendantSemantics: true,
          borderRadius: context.borderRadiusSm,
          child: GtIcon.withColor(
            GtIcons.info,
            color: context.palette.icon.soft,
            size: context.dp(16.px),
          ),
        ),
      );
    }

    final child = GtDoubleColumnListTile(
      tile.label,
      value: tile.value,
      valuePrefix: imagePosition == .leading ? image : null,
      valueSuffix: imagePosition == .trailing ? image : null,
      labelSuffix: info,
      highlightValue: highlightValue,
    );

    if (tile.onTap != null) {
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
      return GtInkWell(role: .button, onTap: status.onPressed, child: pill);
    }

    return pill;
  }
}

/// A compact action button displayed beneath the amount on a receipt or
/// transfer detail screen.
///
/// Renders [GtReceiptAction] as a small [GtRaisedButton] with a leading icon,
/// taking its variant and any custom colours from the action's style.
///
/// Shared by [GtReceiptBody] and [GtTransferDetailBody].
class GtReceiptActionButton extends GtStatelessWidget {
  /// The label, icon, style and tap handler for this button.
  final GtReceiptAction action;

  /// How the button is positioned within the space it is given, forwarded to
  /// [GtRaisedButton.alignment].
  ///
  /// Defaults to [Alignment.center], which wraps the button in an [Align] that
  /// fills the available width. Pass `null` to size the button to its content,
  /// as [GtTransferDetailBody] does inside its [Wrap].
  final AlignmentGeometry? alignment;

  /// Creates a [GtReceiptActionButton].
  const GtReceiptActionButton({
    super.key,
    required this.action,
    this.alignment = .center,
  });

  @override
  Widget build(BuildContext context) {
    return GtRaisedButton(
      onPressed: action.onTap,
      text: action.label,
      variant: action.style.variant,
      alignment: alignment,
      size: .small,
      leading: action.icon,
      contentPadding: context.insets.symmetricDp(horizontal: 12.px),
      textColor: action.textColor(context.palette),
      color: action.color(context.palette),
    );
  }
}
