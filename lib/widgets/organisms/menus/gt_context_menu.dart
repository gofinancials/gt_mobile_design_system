import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtContextMenuItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final OnChanged<T> onSelect;

  const GtContextMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.onSelect,
  });
}

class GtContextMenu<T> extends GtStatelessWidget {
  final List<GtContextMenuItem<T>> items;
  final Widget anchor;

  const GtContextMenu({required this.items, required this.anchor, super.key})
    : assert(items.length > 0);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      constraints: BoxConstraints(maxWidth: context.dp(220.px)),
      position: PopupMenuPosition.under,
      color: context.palette.bg.weak,
      padding: context.insets.allDp(12.px),
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadius2Xl,
        side: BorderSide.none,
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceInOut,
        duration: 100.milliseconds,
        reverseDuration: 100.milliseconds,
      ),
      enableFeedback: true,
      itemBuilder: (context) {
        return [
          for (final item in items)
            PopupMenuItem(
              padding: .zero,
              height: context.dp(40.px),
              value: item.value,
              child: GtContextMenuTile(item: item),
            ),
        ];
      },
      child: anchor,
    );
  }
}

class GtPillContextMenu<T> extends GtStatelessWidget {
  final List<GtContextMenuItem<T>> items;
  final GtButtonPill anchor;

  const GtPillContextMenu({
    required this.items,
    required this.anchor,
    super.key,
  }) : assert(items.length > 0);

  @override
  Widget build(BuildContext context) {
    return GtContextMenu(items: items, anchor: anchor);
  }
}

class GtMoreContextMenu<T> extends GtStatelessWidget {
  final List<GtContextMenuItem<T>> items;

  const GtMoreContextMenu({required this.items, super.key})
    : assert(items.length > 0);

  @override
  Widget build(BuildContext context) {
    return GtContextMenu(items: items, anchor: GtIcon(GtIcons.moreHorizontal));
  }
}

class GtContextMenuTile<T> extends GtStatelessWidget {
  final GtContextMenuItem<T> item;

  const GtContextMenuTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => item.onSelect(item.value),
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingMd,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: GtText(item.label, style: context.textStyles.subHeadS()),
            ),
            GtIcon.withColor(
              item.icon,
              color: context.palette.primary.darker,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
