import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Represents a single page within the dashboard, coupling a [page] widget
/// with its corresponding [navItem] configuration for the bottom navigation bar.
///
/// [navItem] may be left out when the dashboard draws no bottom navigation:
/// a single-page dashboard, or one with
/// [GtDashboardScaffold.showBottomNavigation] set to false.
class GtDashboardPageData extends AppEquatable {
  /// The widget to be displayed as the page content.
  final Widget page;

  /// The navigation item configuration for this page in the bottom navigation bar.
  ///
  /// Required for every page while the bar is shown; see
  /// [GtDashboardScaffold.showBottomNavigation].
  final GtBottomNavigationItem? navItem;

  /// Whether to show the gradient background.
  final bool showGradient;

  /// The app bar to be displayed in the scaffold.
  final PreferredSizeWidget? appBar;

  /// The background color of the page.
  final Color? backgroundColor;

  /// Whether [page] is drawn as a skeleton of itself while its content loads.
  /// Defaults to false.
  ///
  /// Only this page's body is boned. The gradient, the [appBar] and the bottom
  /// navigation stay real, so the customer can still switch tabs, and each tab
  /// loads on its own. While this is set, pass [page] as it is with no data
  /// yet, or with placeholder data shaped like the real content:
  /// [GtAccountDetailSlides] with no accounts draws a placeholder balance in a
  /// skeleton, and lists can take a [GtSkeletonList]. The skeleton absorbs
  /// touches, so the page does not scroll until it lifts.
  ///
  /// The app bar loads separately; see [GtHomeAppBar.isLoading].
  final bool isLoading;

  /// What is announced while [isLoading] is set, such as "Loading your
  /// accounts". See [GtSkeleton.semanticsLabel].
  final String? loadingSemanticsLabel;

  /// Creates a [GtDashboardPageData] for [page], reached through [navItem].
  const GtDashboardPageData({
    required this.page,
    this.navItem,
    this.showGradient = false,
    this.appBar,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingSemanticsLabel,
  });

  @override
  List<Object?> get props => [
    page,
    navItem,
    showGradient,
    appBar,
    isLoading,
    loadingSemanticsLabel,
  ];
}

/// Utility extension on a list of [GtDashboardPageData] to easily extract
/// all [navItems] and [pages].
extension GtDashboardPageDataList on List<GtDashboardPageData> {
  /// Returns the [GtBottomNavigationItem]s of the pages that carry one.
  List<GtBottomNavigationItem> get navItems => [
    for (final e in this) ?e.navItem,
  ];

  /// Returns a list of all page [Widget]s from the page data.
  List<Widget> get pages => mapList((e) => e.page);
}

/// A specialized scaffold template for dashboard screens.
///
/// This scaffold provides a standardized layout including a [GtHomeAppBar],
/// an integrated [GtBottomNavigationBar] (derived from [data]), and a styled
/// background using [GtHomeGradientPainter]. It also manages a [PageView] to
/// handle navigation between the provided dashboard pages.
///
/// A page whose [GtDashboardPageData.isLoading] is set is drawn as a skeleton
/// of itself, inside the same gradient, app bar and bottom navigation.
///
/// A dashboard of a single page draws no bottom navigation, and
/// [showBottomNavigation] hides it for any number of pages. Without the bar the
/// page keeps its gradient, skeleton and root pop scope, its [SafeArea] clears
/// the bottom system inset, and [pageController] still switches pages.
///
/// @category Templates
class GtDashboardScaffold extends GtStatefulWidget {
  /// A list of page data defining the body widgets and their bottom navigation configurations.
  final List<GtDashboardPageData> data;

  /// The initial page index to display when the dashboard is created.
  final int initialIndex;

  /// Optional callback triggered when the user navigates to a new page.
  final OnChanged<int>? onPageChanged;

  /// Callback for the trailing circular action button (**iOS only**).
  final OnPressed onClickHelp;

  /// The page controller to control the page view.
  final ValueNotifier<int>? pageController;

  ///The style of the bottom navigation bar.
  final GtBottomNavigationStyle? bottomNavigationStyle;

  /// An accessible name for the trailing action, already localised.
  ///
  /// The action is icon-only, so without a name a screen reader announces it
  /// as an unlabelled button.
  final String? trailingSemanticsLabel;

  /// Whether the selection highlight and icon change should animate.
  final bool enableSelectionAnimation;

  /// Optional icon for the trailing action button (**iOS only**).
  final IconData trailingIcon;

  /// Whether the bottom navigation bar is drawn.
  ///
  /// Defaults to null, which shows the bar when there are two or more pages
  /// in [data] and hides it for one. Pass false to hide it whatever the number
  /// of pages, such as for a customer whose role restricts navigation, or true
  /// to insist on it, which needs two or more pages.
  ///
  /// While the bar is shown, every page must carry a
  /// [GtDashboardPageData.navItem].
  final bool? showBottomNavigation;

  /// Creates a [GtDashboardScaffold].
  const GtDashboardScaffold({
    super.key,
    required this.data,
    this.initialIndex = 0,
    this.onPageChanged,
    required this.onClickHelp,
    this.pageController,
    this.bottomNavigationStyle,
    this.trailingSemanticsLabel,
    this.enableSelectionAnimation = true,
    this.trailingIcon = GtIcons.helpInfo,
    this.showBottomNavigation,
  }) : assert(data.length > 0, 'GtDashboardScaffold requires a page'),
       assert(
         showBottomNavigation != true || data.length >= 2,
         'A bottom navigation bar needs two or more pages',
       );

  /// Whether the bottom navigation bar is drawn: [showBottomNavigation] when
  /// set, otherwise whether there are two or more pages.
  bool get showsBottomNavigation => showBottomNavigation ?? data.length >= 2;

  @override
  State<GtDashboardScaffold> createState() => _GtDashboardScaffoldState();
}

/// The state of a [GtDashboardScaffold], which tracks the page in view.
class _GtDashboardScaffoldState extends State<GtDashboardScaffold> {
  /// The index of the page in view: [GtDashboardScaffold.pageController] when
  /// one is supplied, otherwise one owned and disposed here.
  late final ValueNotifier<int> _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        widget.pageController ?? ValueNotifier(widget.initialIndex);
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    if (widget.pageController == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  /// Reports a page change through [GtDashboardScaffold.onPageChanged].
  void _pageListener() {
    widget.onPageChanged?.call(_pageController.value);
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.data.pages;
    final navItems = widget.data.navItems;
    final showsNavigation = widget.showsBottomNavigation;
    assert(
      !showsNavigation || navItems.length == pages.length,
      'Every page needs a navItem while the bottom navigation bar is shown',
    );
    final gradiantStart = switch (context.isInDarkMode) {
      true => context.palette.primary.darker,
      _ => context.palette.primary.base,
    };

    return GtRootPopScope(
      child: ListenableBuilder(
        listenable: _pageController,
        builder: (_, child) {
          int index = _pageController.value;

          final data = widget.data[index];
          final appBar = data.appBar;
          final bgColor = data.backgroundColor;

          Widget page = pages[index];
          if (data.isLoading) {
            page = GtSkeleton(
              semanticsLabel: data.loadingSemanticsLabel,
              child: page,
            );
          }

          Widget body = SafeArea(child: page);

          if (data.showGradient) {
            body = CustomPaint(
              painter: GtHomeGradientPainter(
                color: gradiantStart,
                endColor: context.palette.bg.warm,
              ),
              child: body,
            );
          }

          // Without a bar the body's SafeArea clears the bottom system inset,
          // since nothing else in the scaffold claims it.
          Widget? navigationBar;
          if (showsNavigation) {
            navigationBar = GtBottomNavigationBar(
              items: navItems,
              style: widget.bottomNavigationStyle,
              currentIndex: index,
              enableSelectionAnimation: widget.enableSelectionAnimation,
              onIndexChanged: (index) {
                if (navItems[index].onSelected != null) {
                  navItems[index].onSelected!(index);
                  return;
                }
                _pageController.value = index;
              },
            );
          }

          return Scaffold(
            backgroundColor: bgColor ?? context.palette.bg.white,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: appBar,
            body: body,
            bottomNavigationBar: navigationBar,
          );
        },
      ),
    );
  }
}
