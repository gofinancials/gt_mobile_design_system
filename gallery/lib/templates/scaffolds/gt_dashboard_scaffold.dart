import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final pageController = PageController(initialPage: 0);

@widgetbook.UseCase(name: 'Dashboard Scaffold', type: GtDashboardScaffold)
Widget playgroundGtDashboardScaffoldUseCase(BuildContext context) {
  return const _DashboardScaffoldPreview();
}

class _DashboardScaffoldPreview extends StatefulWidget {
  const _DashboardScaffoldPreview();

  @override
  State<_DashboardScaffoldPreview> createState() =>
      _DashboardScaffoldPreviewState();
}

class _DashboardScaffoldPreviewState extends State<_DashboardScaffoldPreview> {
  final List<GtBottomNavigationItem> _items = const [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: 'Home',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.paymentFilled,
      unselectedIcon: GtIcons.payment,
      label: 'Payments',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.productFilled,
      unselectedIcon: GtIcons.product,
      label: 'Products',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.cardFilled,
      unselectedIcon: GtIcons.card,
      label: 'Cards',
    ),
  ];

  List<GtDashboardPageData> get data => [
    GtDashboardPageData(
      page: Center(
        child: GtText(
          'Home Page',
          style: context.textStyles.h4(),
          key: const ValueKey("home"),
        ),
      ),
      backgroundColor: context.isIos || context.isMacos
          ? context.palette.bg.warm
          : null,
      appBar: GtHomeAppBar(
        onClickSearch: () {},
        onClickHide: () {},
        onClickNotification: () {},
      ),
      navItem: _items[0],
      showGradient: true,
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Payments"),
      page: Center(
        child: GtText(
          'Payments Page',
          style: context.textStyles.h4(),
          key: const ValueKey("payments"),
        ),
      ),
      navItem: _items[1],
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Products"),
      page: Center(
        child: GtText(
          'Products Page',
          style: context.textStyles.h4(),
          key: const ValueKey("products"),
        ),
      ),
      navItem: _items[2],
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Cards"),
      page: Center(
        child: GtText(
          'Cards Page',
          style: context.textStyles.h4(),
          key: const ValueKey("cards"),
        ),
      ),
      navItem: _items[3],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GtDashboardScaffold(
      onClickHelp: () {},
      data: data,
      pageController: pageController,
    );
  }
}
