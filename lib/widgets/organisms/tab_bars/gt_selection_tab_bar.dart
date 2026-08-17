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

  /// An optional custom padding to apply to the tab bar.
  final EdgeInsetsGeometry? padding;

  /// Whether to scroll the tab into view when selected.
  final bool autoScroll;

  /// Whether the shared active indicator glides between selected tabs.
  final bool enableIndicatorAnimation;

  /// Creates a [GtSelectionTabbar].
  const GtSelectionTabbar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onChangeTab,
    this.useAlternateStyle = false,
    this.style,
    this.padding,
    this.autoScroll = false,
    this.enableIndicatorAnimation = true,
  }) : assert(tabs.length > 0);

  @override
  State<GtSelectionTabbar<T>> createState() => _GtSelectionTabbarState<T>();
}

class _GtSelectionTabbarState<T> extends State<GtSelectionTabbar<T>> {
  final GlobalKey _tabRowKey = GlobalKey();
  late List<GlobalKey> _tabKeys;
  Rect? _indicatorRect;
  bool _measureScheduled = false;

  @override
  void initState() {
    super.initState();
    _tabKeys = List<GlobalKey>.generate(widget.tabs.length, (_) => GlobalKey());
    if (!widget.controller.hasValue) {
      widget.controller.value = widget.tabs.first;
    }
    widget.controller.addListener(_handleSelectionChanged);
    _scheduleIndicatorMeasure();
  }

  @override
  void didUpdateWidget(covariant GtSelectionTabbar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleSelectionChanged);
      if (!widget.controller.hasValue) {
        widget.controller.value = widget.tabs.first;
      }
      widget.controller.addListener(_handleSelectionChanged);
    }
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabKeys = List<GlobalKey>.generate(
        widget.tabs.length,
        (_) => GlobalKey(),
      );
      _indicatorRect = null;
    }
    _scheduleIndicatorMeasure();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleSelectionChanged);
    super.dispose();
  }

  void _handleSelectionChanged() {
    if (!mounted) return;
    setState(() {});
    _scheduleIndicatorMeasure();
  }

  void _scheduleIndicatorMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (!mounted) return;
      _measureIndicator();
    });
  }

  void _measureIndicator() {
    final activeTab = widget.controller.value;
    if (activeTab == null) {
      _clearIndicator();
      return;
    }
    final activeIndex = widget.tabs.indexOf(activeTab);
    if (activeIndex < 0 || activeIndex >= _tabKeys.length) {
      _clearIndicator();
      return;
    }

    final rowBox = _tabRowKey.currentContext?.findRenderObject();
    final tabBox = _tabKeys[activeIndex].currentContext?.findRenderObject();
    if (rowBox is! RenderBox || tabBox is! RenderBox) return;

    final offset = tabBox.localToGlobal(Offset.zero, ancestor: rowBox);
    final nextRect = offset & tabBox.size;
    if (_indicatorRect == nextRect) return;

    setState(() => _indicatorRect = nextRect);
  }

  void _clearIndicator() {
    if (_indicatorRect == null) return;
    setState(() => _indicatorRect = null);
  }

  void _handleTabSelected(GtTabData<T> newTab) {
    widget.controller.value = newTab;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChangeTab?.call(newTab.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAlt = widget.useAlternateStyle;
    final spacing = isAlt ? context.spacingSm : context.spacingBase;
    final tabs = widget.tabs;
    final value = widget.controller.value;
    final variant = widget.style?.variant ?? .primary;
    final indicatorRect = _indicatorRect;

    _scheduleIndicatorMeasure();

    return SingleChildScrollView(
      scrollDirection: .horizontal,
      padding: widget.padding ?? .zero,
      child: Stack(
        key: _tabRowKey,
        children: [
          if (indicatorRect != null)
            AnimatedPositioned(
              key: const Key('gt_selection_tab_indicator'),
              duration: widget.enableIndicatorAnimation
                  ? GtMotion.adaptiveDuration(context, GtMotion.fluid)
                  : Duration.zero,
              curve: GtSpringCurves.snappy,
              left: indicatorRect.left,
              top: indicatorRect.top,
              width: indicatorRect.width,
              height: indicatorRect.height,
              child: _GtTabIndicator(
                variant: variant,
                style: widget.style,
                borderRadius: isAlt
                    ? context.borderRadiusMd
                    : context.borderRadiusSm,
              ),
            ),
          Row(
            spacing: spacing,
            crossAxisAlignment: .center,
            children: [
              for (final (index, tab) in tabs.indexed)
                KeyedSubtree(
                  key: _tabKeys[index],
                  child: widget.useAlternateStyle
                      ? GtTabPill.selection(
                          text: tab.label,
                          style: widget.style,
                          value: tab,
                          activeValue: value,
                          icon: tab.icon,
                          autoScroll: widget.autoScroll,
                          showSelectedBackground: indicatorRect == null,
                          onSelect: _handleTabSelected,
                          variant: variant,
                        )
                      : GtTabPill(
                          text: tab.label,
                          style: widget.style,
                          value: tab,
                          activeValue: value,
                          icon: tab.icon,
                          autoScroll: widget.autoScroll,
                          showSelectedBackground: indicatorRect == null,
                          onSelect: _handleTabSelected,
                          variant: variant,
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GtTabIndicator extends GtStatelessWidget {
  final GtPillVariant variant;
  final GtTabPillStyle? style;
  final BorderRadius borderRadius;

  const _GtTabIndicator({
    required this.variant,
    required this.style,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color =
        style?.activeBgColor ??
        switch (variant) {
          .primary => palette.primary.base,
          .neutral => palette.bg.sub,
          .featured => palette.feature.base,
          .info => palette.information.base,
          .success => palette.success.base,
          .warning => palette.warning.base,
          .error => palette.error.base,
          .highlighted => palette.highlighted.base,
          .stable => palette.stable.base,
          .verified => palette.success.base,
          .away => palette.away.base,
          _ => palette.bg.strong,
        };

    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
    );
  }
}
