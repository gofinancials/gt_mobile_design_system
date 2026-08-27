import 'dart:async';

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

  /// Whether the shared active indicator glides between selected tabs.
  final bool enableIndicatorAnimation;

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
    this.enableIndicatorAnimation = true,
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
      enableIndicatorAnimation: widget.enableIndicatorAnimation,
    );
  }
}

/// A widget that displays the content corresponding to the currently selected
/// tab.
///
/// Both constructors support horizontal swipes and stay synchronized with the
/// provided [controller]. The default constructor accepts preconstructed views,
/// while [GtTabbarView.lazy] builds pages on demand.
class GtTabbarView<T> extends GtStatefulWidget {
  /// The key used when a tab has no matching view or builder.
  static const emptyViewKey = Key('gt-empty-tab-view');

  /// The controller that dictates which tab view is currently visible.
  final GtTabController<T> controller;

  /// A map associating each tab value with its preconstructed view.
  final Map<T, Widget> tabViews;

  /// The ordered tabs displayed by this view.
  final List<GtTabData<T>> tabs;

  /// The on-demand view builders used by [GtTabbarView.lazy].
  final Map<T, WidgetBuilder> tabBuilders;

  /// The horizontal page scroll behavior.
  final ScrollPhysics physics;

  final bool _isLazy;

  /// Creates a swipeable tab view from preconstructed widgets.
  const GtTabbarView({
    super.key,
    required this.controller,
    required this.tabs,
    required this.tabViews,
    this.physics = const PageScrollPhysics(),
  }) : assert(tabs.length > 0),
       assert(tabs.length == tabViews.length),
       tabBuilders = const {},
       _isLazy = false;

  /// Creates a builder-backed tab view that constructs pages on demand.
  ///
  /// Horizontal swipes update [controller], while controller changes (such as
  /// a tap in [GtTabbar]) animate to the matching page. [tabs] defines the page
  /// order and must have one matching entry in [tabBuilders] for every value.
  const GtTabbarView.lazy({
    super.key,
    required this.controller,
    required this.tabs,
    required this.tabBuilders,
    this.physics = const PageScrollPhysics(),
  }) : assert(tabs.length > 0),
       assert(tabs.length == tabBuilders.length),
       tabViews = const {},
       _isLazy = true;

  @override
  State<GtTabbarView<T>> createState() => _GtTabbarViewState();
}

class _GtTabbarViewState<T> extends State<GtTabbarView<T>> {
  @override
  Widget build(BuildContext context) {
    assert(
      widget.tabs.every(
        (tab) => widget._isLazy
            ? widget.tabBuilders.containsKey(tab.value)
            : widget.tabViews.containsKey(tab.value),
      ),
      'Every tab must have a matching view or builder.',
    );

    return _GtSwipeableTabbarView<T>(
      controller: widget.controller,
      tabs: widget.tabs,
      physics: widget.physics,
      pageBuilder: (context, index) {
        final tab = widget.tabs[index];
        if (widget._isLazy) {
          return widget.tabBuilders[tab.value]?.call(context) ??
              const Offstage(key: GtTabbarView.emptyViewKey);
        }
        return widget.tabViews[tab.value] ??
            const Offstage(key: GtTabbarView.emptyViewKey);
      },
    );
  }
}

class _GtSwipeableTabbarView<T> extends GtStatefulWidget {
  final GtTabController<T> controller;
  final List<GtTabData<T>> tabs;
  final ScrollPhysics physics;
  final IndexedWidgetBuilder pageBuilder;

  const _GtSwipeableTabbarView({
    required this.controller,
    required this.tabs,
    required this.physics,
    required this.pageBuilder,
  });

  @override
  State<_GtSwipeableTabbarView<T>> createState() =>
      _GtSwipeableTabbarViewState<T>();
}

class _GtSwipeableTabbarViewState<T> extends State<_GtSwipeableTabbarView<T>> {
  late final PageController _pageController;
  bool _pageSyncScheduled = false;
  int? _programmaticTarget;

  @override
  void initState() {
    super.initState();
    _ensureValidSelection();
    _pageController = PageController(initialPage: _selectedIndex);
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _GtSwipeableTabbarView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      _ensureValidSelection();
      widget.controller.addListener(_handleControllerChanged);
    } else {
      _ensureValidSelection();
    }
    _schedulePageSync();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _pageController.dispose();
    super.dispose();
  }

  int get _selectedIndex {
    final activeValue = widget.controller.value?.value;
    final index = widget.tabs.indexWhere((tab) => tab.value == activeValue);
    return index < 0 ? 0 : index;
  }

  void _ensureValidSelection() {
    final activeValue = widget.controller.value?.value;
    final hasSelection = widget.tabs.any((tab) => tab.value == activeValue);
    if (!hasSelection) widget.controller.value = widget.tabs.first;
  }

  void _handleControllerChanged() => _syncPageWithController();

  void _schedulePageSync() {
    if (_pageSyncScheduled) return;
    _pageSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageSyncScheduled = false;
      if (mounted) _syncPageWithController();
    });
  }

  void _syncPageWithController() {
    if (!_pageController.hasClients) {
      _schedulePageSync();
      return;
    }

    final target = _selectedIndex;
    final current = _pageController.page?.round();
    if (current == target) return;

    final duration = GtMotion.adaptiveDuration(context, GtMotion.normal);
    if (duration == Duration.zero) {
      _programmaticTarget = null;
      _pageController.jumpToPage(target);
      return;
    }

    _programmaticTarget = target;
    unawaited(_animateToPage(target, duration));
  }

  Future<void> _animateToPage(int target, Duration duration) async {
    await _pageController.animateToPage(
      target,
      duration: duration,
      curve: GtSpringCurves.gentle,
    );
    if (!mounted || _programmaticTarget != target) return;

    _programmaticTarget = null;
    final settledPage = _pageController.page?.round() ?? target;
    _selectPage(settledPage);
  }

  void _handlePageChanged(int index) {
    if (_programmaticTarget != null) return;
    _selectPage(index);
  }

  void _selectPage(int index) {
    if (index < 0 || index >= widget.tabs.length) return;
    final tab = widget.tabs[index];
    if (widget.controller.value != tab) widget.controller.value = tab;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _programmaticTarget = null;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView.builder(
        controller: _pageController,
        physics: widget.physics,
        scrollDirection: Axis.horizontal,
        allowImplicitScrolling: false,
        itemCount: widget.tabs.length,
        onPageChanged: _handlePageChanged,
        itemBuilder: (context, index) {
          final tab = widget.tabs[index];
          return KeyedSubtree(
            key: ValueKey(tab.value),
            child: widget.pageBuilder(context, index),
          );
        },
      ),
    );
  }
}
