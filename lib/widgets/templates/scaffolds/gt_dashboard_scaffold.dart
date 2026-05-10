import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Represents a single page within the dashboard, coupling a [page] widget
/// with its corresponding [navItem] configuration for the bottom navigation bar.
class GtDashboardPageData extends AppEquatable {
  /// The widget to be displayed as the page content.
  final Widget page;

  /// The navigation item configuration for this page in the bottom navigation bar.
  final GtBottomNavigationItem navItem;

  /// Whether to show the gradient background.
  final bool showGradient;

  /// The app bar to be displayed in the scaffold.
  final PreferredSizeWidget? appBar;

  /// The background color of the page.
  final Color? backgroundColor;

  const GtDashboardPageData({
    required this.page,
    required this.navItem,
    this.showGradient = false,
    this.appBar,
    this.backgroundColor,
  });

  @override
  List<Object?> get props => [page, navItem, showGradient, appBar];
}

/// Utility extension on a list of [GtDashboardPageData] to easily extract
/// all [navItems] and [pages].
extension GtDashboardPageDataList on List<GtDashboardPageData> {
  /// Returns a list of all [GtBottomNavigationItem]s from the page data.
  List<GtBottomNavigationItem> get navItems => mapList((e) => e.navItem);

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

  final PageController? pageController;

  /// Creates a [GtDashboardScaffold].
  const GtDashboardScaffold({
    super.key,
    required this.data,
    this.initialIndex = 0,
    this.onPageChanged,
    required this.onClickHelp,
    this.pageController,
  }) : assert(data.length >= 2, "Data must be at least 2");

  @override
  State<GtDashboardScaffold> createState() => _GtDashboardScaffoldState();
}

class _GtDashboardScaffoldState extends State<GtDashboardScaffold> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController =
        widget.pageController ??
        PageController(initialPage: widget.initialIndex);
    _currentPageNotifier = ValueNotifier<int>(widget.initialIndex);
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.data.pages;
    final navItems = widget.data.navItems;

    return GtRootPopScope(
      child: ListenableBuilder(
        listenable: Listenable.merge([_pageController, _currentPageNotifier]),
        builder: (_, child) {
          final index = _currentPageNotifier.value;
          final data = widget.data[index];
          final appBar = data.appBar;
          final bgColor = data.backgroundColor;
          Widget body = child ?? const SizedBox.shrink();

          if (data.showGradient) {
            body = CustomPaint(
              painter: GtHomeGradientPainter(
                color: context.palette.primary.alpha24,
              ),
              child: body,
            );
          }

          return Scaffold(
            backgroundColor: bgColor ?? context.palette.bg.white,
            extendBodyBehindAppBar: true,
            appBar: appBar,
            body: body,
            bottomNavigationBar: GtBottomNavigationBar(
              key: const PageStorageKey("gt-dashboard-nav-bar"),
              items: navItems,
              onTrailingTap: widget.onClickHelp,
              currentIndex: index,
              onIndexChanged: (index) {
                if (navItems[index].onSelected != null) {
                  navItems[index].onSelected!(index);
                  return;
                }
                _pageController.jumpToPage(index);
              },
            ),
          );
        },
        child: SafeArea(
          child: PageView.builder(
            key: const PageStorageKey("gt-dashboard-page-view"),
            controller: _pageController,
            onPageChanged: (index) {
              widget.onPageChanged?.call(index);
              _currentPageNotifier.value = index;
            },
            itemBuilder: (_, index) => pages[index],
            itemCount: pages.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
