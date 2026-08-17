import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A tab bar widget that renders a horizontal list of selectable tabs.
///
/// This widget acts as a direct wrapper around [GtSelectionTabbar], exposing the
/// same configuration options for tabs, styles, and state management.
class GtTabbar<T> extends GtStatefulWidget {
  /// The list of tab data objects defining the labels, values, and icons for each tab.
  final List<GtTabData<T>> tabs;

  /// The controller that manages the currently selected tab.
  final GtTabController<T> controller;

  /// An optional callback triggered whenever the active tab changes.
  final OnChanged<T>? onChangeTab;

  /// Whether to use the alternate selection style instead of the default tab style. Defaults to false.
  final bool useAlternateStyle;

  /// An optional custom style configuration to apply to the tab pills.
  final GtTabPillStyle? style;

  /// An optional custom padding to apply to the tab bar.
  final EdgeInsetsGeometry? padding;

  /// Whether to scroll the tab into view when selected.
  final bool autoScroll;

  /// Creates a [GtTabbar].
  const GtTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
    this.style,
    this.padding,
    this.autoScroll = false,
  }) : assert(tabs.length > 0);

  @override
  State<GtTabbar<T>> createState() => _GtTabbarState<T>();
}

class _GtTabbarState<T> extends State<GtTabbar<T>> {
  @override
  Widget build(BuildContext context) {
    return GtSelectionTabbar(
      tabs: widget.tabs,
      controller: widget.controller,
      onChangeTab: widget.onChangeTab,
      useAlternateStyle: widget.useAlternateStyle,
      style: widget.style,
      padding: widget.padding,
      autoScroll: widget.autoScroll,
    );
  }
}

/// A widget that displays the content corresponding to the currently selected tab.
///
/// It listens to the provided [controller] and renders the matching widget from
/// the [tabViews] map. If no matching view is found for the active tab, it renders an [Offstage] widget.
class GtTabbarView<T> extends GtStatefulWidget {
  /// The controller that dictates which tab view is currently visible.
  final GtTabController<T> controller;

  /// A map associating each tab value of type [T] with its corresponding [Widget] view.
  final Map<T, Widget> tabViews;

  /// Creates a [GtTabbarView].
  const GtTabbarView({
    super.key,
    required this.controller,
    required this.tabViews,
  });

  @override
  State<GtTabbarView<T>> createState() => _GtTabbarViewState();
}

class _GtTabbarViewState<T> extends State<GtTabbarView<T>> {
  int? _previousIndex;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final activeTab = widget.controller.value;
        final keys = widget.tabViews.keys.toList(growable: false);
        final activeIndex = activeTab == null
            ? -1
            : keys.indexOf(activeTab.value);
        final previousIndex = _previousIndex ?? activeIndex;
        final direction = activeIndex >= previousIndex ? 1.0 : -1.0;
        _previousIndex = activeIndex;
        final activeKey = activeTab?.value;
        final activeView = widget.tabViews[activeKey] ?? const Offstage();
        final duration = GtMotion.adaptiveDuration(context, GtMotion.normal);

        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: GtSpringCurves.gentle,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            final isIncoming = child.key == ValueKey(activeKey);
            final offset = Offset(isIncoming ? direction : -direction, 0);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: offset,
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(key: ValueKey(activeKey), child: activeView),
        );
      },
    );
  }
}
