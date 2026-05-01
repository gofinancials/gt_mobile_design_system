import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A highly customizable context menu widget that opens a list of choices.
///
/// It uses a [MenuAnchor] internally to display a dropdown of [GtContextMenuItem]s
/// when the user interacts with the [anchor] widget. When opened, it applies a
/// backdrop blur effect behind the menu.
class GtContextMenu<T> extends GtStatefulWidget {
  /// The list of items to display in the context menu.
  final List<GtContextMenuItem<T>> items;

  /// The widget that triggers the context menu when tapped.
  final Widget anchor;

  /// An optional tooltip message displayed when hovering or long-pressing the anchor.
  final String? tooltip;

  /// An optional focus node to control the focus state of the menu.
  final FocusNode? focusNode;

  /// Creates a [GtContextMenu].
  GtContextMenu({
    required this.items,
    required this.anchor,
    this.focusNode,
    this.tooltip,
    super.key,
  }) : assert(items.hasValue);

  @override
  State<StatefulWidget> createState() => _GtContextMenuState<T>();
}

class _GtContextMenuState<T> extends State<GtContextMenu<T>> {
  late final FocusNode _focusNode;
  late final MenuController _menuController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _menuController = MenuController();
  }

  void _toggle() {
    if (_menuController.isOpen) {
      return _menuController.close();
    }
    _menuController.open();
  }

  @override
  void dispose() {
    _menuController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      crossAxisUnconstrained: false,
      controller: _menuController,
      childFocusNode: _focusNode,
      alignmentOffset: Offset(0, 8),
      builder: (context, controller, child) {
        final isOpened = controller.isOpen;
        if (isOpened) {
          return BackdropFilter(
            filter: context.backdropFilters.contextMenuBlur(),
            child: child,
          );
        }
        return child!;
      },
      style: MenuStyle(
        visualDensity: .adaptivePlatformDensity,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: context.borderRadius2Xl,
            side: BorderSide.none,
          ),
        ),
        side: WidgetStatePropertyAll(BorderSide.none),
        shadowColor: WidgetStatePropertyAll(context.shadowColor),
        maximumSize: WidgetStatePropertyAll(
          Size(context.dp(300.px), .infinity),
        ),
        backgroundColor: WidgetStatePropertyAll(context.palette.bg.weak),
        padding: WidgetStatePropertyAll(
          context.insets.symmetricDp(vertical: 12.px),
        ),
        elevation: WidgetStatePropertyAll(2),
      ),
      menuChildren: [
        for (final item in widget.items)
          GtContextMenuTile(item: item, subAction: _menuController.close),
      ],
      child: Tooltip(
        message: widget.tooltip ?? "Gt Context Menu",
        textStyle: context.textStyles.body2Xs(
          color: context.palette.text.white,
        ),
        decoration: BoxDecoration(
          color: context.palette.bg.strong,
          borderRadius: context.borderRadiusSm,
        ),
        padding: context.insets.allDp(6.px),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _toggle();
          },
          child: widget.anchor,
        ),
      ),
    );
  }
}

/// A specialized context menu that uses a [GtButtonPill] as its trigger anchor.
///
/// This is a convenience widget that wraps [GtContextMenu] to ensure the anchor
/// is consistently styled as a pill button.
class GtPillContextMenu<T> extends GtStatelessWidget {
  /// The list of items to display in the context menu.
  final List<GtContextMenuItem<T>> items;

  /// The pill button widget used to trigger the menu.
  final GtButtonPill anchor;

  /// An optional tooltip message.
  final String? tooltip;

  /// Creates a [GtPillContextMenu].
  const GtPillContextMenu({
    required this.items,
    required this.anchor,
    this.tooltip,
    super.key,
  }) : assert(items.length > 0);

  @override
  Widget build(BuildContext context) {
    return GtContextMenu(
      items: items,
      tooltip: tooltip,
      anchor: IgnorePointer(child: anchor),
    );
  }
}

/// A specialized context menu that uses a standard "more" (ellipsis) icon as its trigger.
///
/// Typically used in app bars or list tiles to reveal secondary actions.
class GtMoreContextMenu<T> extends GtStatelessWidget {
  /// The list of items to display in the context menu.
  final List<GtContextMenuItem<T>> items;

  /// An optional tooltip message.
  final String? tooltip;

  /// Creates a [GtMoreContextMenu].
  const GtMoreContextMenu({required this.items, super.key, this.tooltip})
    : assert(items.length > 0);

  @override
  Widget build(BuildContext context) {
    return GtContextMenu(
      items: items,
      tooltip: tooltip,
      anchor: GtIcon(GtIcons.moreHorizontal, size: 20),
    );
  }
}

/// A widget representing an individual item within a [GtContextMenu].
///
/// Displays a text label and an icon, and handles tap interactions.
class GtContextMenuTile<T> extends GtStatelessWidget {
  /// The data and configuration for this menu item.
  final GtContextMenuItem<T> item;

  /// An optional callback executed just before the item's own `onTap` is called.
  /// Commonly used by the parent menu to close itself.
  final OnPressed? subAction;

  /// Creates a [GtContextMenuTile].
  const GtContextMenuTile({required this.item, this.subAction, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        subAction?.call();
        item.onTap();
      },
      child: Container(
        padding: context.insets.symmetricDp(vertical: 8.px, horizontal: 12.px),
        constraints: BoxConstraints(minHeight: 40),
        child: Row(
          spacing: context.spacingsectionMd,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GtText(
                item.label.capitalise(true),
                style: context.textStyles.subHeadS(),
                maxLines: 1,
                overflow: .ellipsis,
              ),
            ),
            GtIcon.withColor(
              item.icon,
              color: context.palette.primary.dark,
              size: 20,
              alignment: .centerRight,
            ),
          ],
        ),
      ),
    );
  }
}
