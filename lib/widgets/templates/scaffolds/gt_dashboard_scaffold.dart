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

  const GtDashboardPageData({required this.page, required this.navItem});

  @override
  List<Object?> get props => [page, navItem];
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
  /// Callback triggered when the search icon is pressed.
  final OnPressed onClickSearch;

  /// Callback triggered when the hide/visibility icon is pressed.
  final OnPressed onClickHide;

  /// Callback triggered when the notification icon is pressed.
  final OnPressed? onClickNotification;

  /// Callback triggered when the help icon is pressed.
  final OnPressed? onClickHelp;

  /// Optional avatar image data for the current user.
  final AppImageData? avatar;

  /// The full name of the user, used to generate initials if [avatar] is absent.
  final String? userFullName;

  /// A list of page data defining the body widgets and their bottom navigation configurations.
  final List<GtDashboardPageData> data;

  /// The initial page index to display when the dashboard is created.
  final int initialIndex;

  /// Optional callback triggered when the user navigates to a new page.
  final OnChanged<int>? onPageChanged;

  /// Creates a [GtDashboardScaffold].
  const GtDashboardScaffold({
    super.key,
    required this.onClickSearch,
    required this.onClickHide,
    this.onClickNotification,
    this.onClickHelp,
    this.avatar,
    this.userFullName,
    required this.data,
    this.initialIndex = 0,
    this.onPageChanged,
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
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPageNotifier = ValueNotifier<int>(widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = context.isIos || context.isMacos;
    final bgColors = context.palette.bg;
    final color = isIos ? bgColors.warm : bgColors.white;
    final pages = widget.data.pages;
    final navItems = widget.data.navItems;

    return GtRootPopScope(
      child: Scaffold(
        backgroundColor: color,
        extendBodyBehindAppBar: true,
        appBar: GtHomeAppBar(
          onClickSearch: widget.onClickSearch,
          onClickHide: widget.onClickHide,
          onClickNotification: widget.onClickNotification,
          avatar: widget.avatar,
          userFullName: widget.userFullName,
        ),
        body: CustomPaint(
          painter: GtHomeGradientPainter(
            color: context.palette.primary.alpha24,
          ),
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
        bottomNavigationBar: ListenableBuilder(
          listenable: Listenable.merge([_pageController, _currentPageNotifier]),
          builder: (_, child) => GtBottomNavigationBar(
            key: const PageStorageKey("gt-dashboard-nav-bar"),
            items: navItems,
            onTrailingTap: widget.onClickHelp,
            currentIndex: _currentPageNotifier.value,
            onIndexChanged: (index) {
              _pageController.animateToPage(
                index,
                duration: 300.milliseconds,
                curve: Curves.decelerate,
              );
            },
          ),
        ),
      ),
    );
  }
}
