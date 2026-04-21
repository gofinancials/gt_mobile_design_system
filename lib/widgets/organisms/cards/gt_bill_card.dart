import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for representing a biller or a specific bill.
class GtBillCard extends GtStatelessWidget {
  /// The name of the biller or bill.
  final String name;

  /// The icon representing the biller.
  final Widget icon;

  /// An optional callback function that is invoked when the card is tapped.
  final OnPressed? onTap;

  /// Internal flag to render as a tile.
  final bool _asTile;

  /// Creates a standard bill card with a stacked layout.
  const GtBillCard({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  }) : _asTile = false;

  /// Creates a bill card with a horizontal list tile layout.
  const GtBillCard.tile({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  }) : _asTile = true;

  @override
  Widget build(BuildContext context) {
    final text = GtText(name, style: context.textStyles.subHeadS());
    final iconWidget = GtSquareConstrainedBox(24, child: icon);

    Widget child = GtCard(
      padding: context.insets.allDp(12.px),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        spacing: context.spacingSectionSm,
        children: [iconWidget, text],
      ),
    );

    if (_asTile) {
      child = GtBaseListTileTemplate(
        title: text,
        leading: iconWidget,
        spacing: context.spacingBase,
        trailing: GtIcon(GtIcons.chevronRight, variant: .soft, size: 14),
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: child,
    );
  }
}