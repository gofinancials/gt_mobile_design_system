import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A scrollable, horizontal tab bar that displays a list of selectable tabs.
///
/// This widget uses a [GtTabController] to manage the active tab state and
/// renders either standard or alternate (selection) style tab pills based on
/// the [useAlternateStyle] flag.
class GtSelectionTabbar<T> extends GtStatefulWidget {
  /// The list of tab data objects defining the labels, values, and icons for each tab.
  final List<GtTabData<T>> tabs;

  /// The controller that manages the currently selected tab.
  final GtTabController<T> controller;

  /// An optional callback triggered whenever the active tab changes.
  final OnChanged<T>? onChangeTab;

  /// Whether to use the alternate selection style ([GtSelectionPill])
  /// instead of the default tab style. Defaults to false.
  final bool useAlternateStyle;

  /// An optional custom style configuration to apply to the tab pills.
  final GtTabPillStyle? style;

  /// Creates a [GtSelectionTabbar].
  const GtSelectionTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
    this.style,
  }) : assert(tabs.length > 0);

  @override
  State<GtSelectionTabbar> createState() => _GtSelectionTabbarState();
}

class _GtSelectionTabbarState extends State<GtSelectionTabbar> {
  @override
  void initState() {
    super.initState();
    if (!widget.controller.hasValue) {
      widget.controller.value = widget.tabs.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAlt = widget.useAlternateStyle;
    final spacing = isAlt ? context.spacingSm : context.spacingBase;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final tabs = widget.tabs;
        final value = widget.controller.value;
        final variant = widget.style?.variant ?? .primary;

        return SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Row(
            spacing: spacing,
            crossAxisAlignment: .center,
            children: [
              for (final tab in tabs)
                if (widget.useAlternateStyle)
                  GtTabPill.selection(
                    text: tab.label,
                    style: widget.style,
                    value: tab,
                    activeValue: value,
                    icon: tab.icon,
                    onSelect: (newTab) {
                      widget.controller.value = newTab;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onChangeTab?.call(newTab.value);
                      });
                    },
                    variant: variant,
                  )
                else
                  GtTabPill(
                    text: tab.label,
                    style: widget.style,
                    value: tab,
                    activeValue: value,
                    icon: tab.icon,
                    onSelect: (newTab) {
                      widget.controller.value = newTab;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onChangeTab?.call(newTab.value);
                      });
                    },
                    variant: variant,
                  ),
            ],
          ),
        );
      },
    );
  }
}
