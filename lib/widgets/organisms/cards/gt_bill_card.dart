import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for representing a biller or a specific bill.
class GtBillCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides name style. Null preserves the current default.
  final TextStyle? nameStyle;

  /// Overrides name color. Null preserves the current default.
  final Color? nameColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

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
    this.backgroundColor,
    this.padding,
    this.nameStyle,
    this.nameColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  }) : _asTile = false,
       trailing = footer;

  /// Creates a bill card with a horizontal list tile layout.
  const GtBillCard.tile({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.nameStyle,
    this.nameColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  }) : _asTile = true;

  @override
  Widget build(BuildContext context) {
    final text = GtText(
      name,
      style: GtTextStyleOverrides.resolve(
        nameStyle,
        context.textStyles.subHeadS(),
        nameColor,
      ),
    );

    Widget child = GtCard(
      color: backgroundColor,
      padding: padding ?? context.insets.allDp(12.px),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        spacing: verticalSpacing ?? context.spacingSectionSm,
        children: [icon, text, ?trailing],
      ),
    );

    if (_asTile) {
      final trailer = GtIcon(GtIcons.chevronRight, variant: .soft, size: 14);
      child = GtBaseListTileTemplate(
        padding: padding,
        title: text,
        leading: icon,
        spacing: horizontalSpacing ?? context.spacingBase,
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
