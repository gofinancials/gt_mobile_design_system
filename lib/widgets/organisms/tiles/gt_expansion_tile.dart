import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A custom expandable tile widget that reveals a list of [children] when expanded.
///
/// Wraps Flutter's [ExpansionTile] with custom trailing icon animations, auto-scroll behavior,
/// and design-system styling.
class GtExpansionTile extends GtStatefulWidget {
  /// The primary widget displayed in the header tile (title slot).
  final Widget leading;

  /// Icon displayed when the tile is expanded. Defaults to [GtIcons.chevronUp].
  final IconData expandIcon;

  /// Icon displayed when the tile is collapsed. Defaults to [GtIcons.chevronDown].
  final IconData collapseIcon;

  /// Optional color override for the trailing expand/collapse icon.
  final Color? iconColor;

  /// Optional size override for the trailing expand/collapse icon.
  final double? iconSize;

  /// The list of widgets displayed inside the expandable body.
  final List<Widget> children;

  /// Callback invoked whenever the expansion state changes (expands or collapses).
  final OnChanged<bool>? onExpandedChange;

  /// Whether to automatically scroll the tile into view upon expanding.
  ///
  /// Defaults to `true`.
  final bool autoScroll;

  /// Whether the tile is expanded by default upon initial render.
  ///
  /// Defaults to `false`.
  final bool isInitiallyExpanded;

  /// Optional padding for the list of [children].
  final EdgeInsetsGeometry? childrenPadding;

  /// Creates a [GtExpansionTile].
  const GtExpansionTile({
    super.key,
    required this.leading,
    required this.children,
    this.expandIcon = GtIcons.chevronUpOutline,
    this.collapseIcon = GtIcons.chevronDownOutline,
    this.iconColor,
    this.onExpandedChange,
    this.autoScroll = true,
    this.isInitiallyExpanded = false,
    this.iconSize,
    this.childrenPadding,
  });

  @override
  State<StatefulWidget> createState() => _GtExpansionTileState();
}

class _GtExpansionTileState extends State<GtExpansionTile> {
  late final ValueNotifier<bool> _expansionRef;

  @override
  void initState() {
    super.initState();
    _expansionRef = ValueNotifier(widget.isInitiallyExpanded);
  }

  @override
  void dispose() {
    _expansionRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const shape = Border();

    return ExpansionTile(
      collapsedShape: shape,
      shape: shape,
      trailing: BoolListener(
        valueListenable: _expansionRef,
        builder: (isExpanded) {
          return GtAnimatedSwitcher(
            child: Builder(
              key: ValueKey("expansion_trailing_icon_$isExpanded"),
              builder: (context) {
                return GtIcon.withColor(
                  !isExpanded ? widget.expandIcon : widget.collapseIcon,
                  color: widget.iconColor,
                  size: widget.iconSize ?? context.dp(20.px),
                );
              },
            ),
          );
        },
      ),
      tilePadding: context.insets.zero,
      childrenPadding: widget.childrenPadding ?? .zero,
      onExpansionChanged: (expansionValue) {
        _expansionRef.value = expansionValue;
        widget.onExpandedChange?.call(expansionValue);
        context.resetFocus();
        if (!widget.autoScroll || !expansionValue) return;
        context.scrollIntoView();
      },
      title: widget.leading,
      iconColor: widget.iconColor ?? context.palette.icon.strong,
      backgroundColor: Colors.transparent,
      initiallyExpanded: widget.isInitiallyExpanded,
      expandedCrossAxisAlignment: .stretch,
      children: widget.children,
    );
  }
}
