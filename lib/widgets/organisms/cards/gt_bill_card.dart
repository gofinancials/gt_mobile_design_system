import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for representing a biller or a specific bill.
class GtBillCard extends GtStatelessWidget {
  /// The name of the biller or bill.
  final String name;

  /// The icon representing the biller.
  final Widget icon;

  /// The icon representing the actio prompt.
  final Widget? trailing;

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
    Widget? footer,
  }) : _asTile = false,
       trailing = footer;

  /// Creates a bill card with a horizontal list tile layout.
  const GtBillCard.tile({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    this.trailing,
  }) : _asTile = true;

  @override
  Widget build(BuildContext context) {
    final text = GtText(name, style: context.textStyles.subHeadS());

    Widget child = GtCard(
      padding: context.insets.allDp(12.px),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        spacing: context.spacingSectionSm,
        children: [icon, text, ?trailing],
      ),
    );

    if (_asTile) {
      final trailer = GtIcon(GtIcons.chevronRight, variant: .soft, size: 14);
      child = GtBaseListTileTemplate(
        title: text,
        leading: icon,
        spacing: context.spacingBase,
        trailing: trailing ?? trailer,
      );
    }

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusXl,
      onTap: onTap,
      child: child,
    );
  }
}
