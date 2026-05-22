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

  /// Creates a [GtTabbar].
  const GtTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
    this.style,
    this.padding,
  }) : assert(tabs.length > 0);

  @override
  State<GtTabbar> createState() => _GtTabbarState();
}

class _GtTabbarState extends State<GtTabbar> {
  @override
  Widget build(BuildContext context) {
    return GtSelectionTabbar(
      tabs: widget.tabs,
      controller: widget.controller,
      onChangeTab: widget.onChangeTab,
      useAlternateStyle: widget.useAlternateStyle,
      style: widget.style,
      padding: widget.padding,
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
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final activeTab = widget.controller.value;
        return widget.tabViews[activeTab?.value] ?? const Offstage();
      },
    );
  }
}
