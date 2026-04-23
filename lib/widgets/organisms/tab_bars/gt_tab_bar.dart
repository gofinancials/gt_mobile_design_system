import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtTabbar<T> extends GtStatefulWidget {
  final List<GtTabData<T>> tabs;
  final GtTabController<T> controller;
  final OnChanged<T>? onChangeTab;
  final bool useAlternateStyle;

  const GtTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
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
    );
  }
}

class GtTabbarView<T> extends GtStatefulWidget {
  final GtTabController<T> controller;
  final Map<GtTabData, Widget> tabViews;

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
        return widget.tabViews[activeTab] ?? const Offstage();
      },
    );
  }
}
