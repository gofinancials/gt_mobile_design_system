import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(
        child: GtText(
          'Home Page',
          style: context.textStyles.h4(),
          key: const ValueKey("home"),
        ),
      ),
      Center(
        child: GtText(
          'Payments Page',
          style: context.textStyles.h4(),
          key: const ValueKey("payments"),
        ),
      ),
      Center(
        child: GtText(
          'Products Page',
          style: context.textStyles.h4(),
          key: const ValueKey("products"),
        ),
      ),
      Center(
        child: GtText(
          'Cards Page',
          style: context.textStyles.h4(),
          key: const ValueKey("cards"),
        ),
      ),
    ];
    return GtDashboardScaffold(
      onClickSearch: () {},
      onClickHide: () {},
      onClickNotification: () {},
      onClickHelp: () {},
      userFullName: 'John Doe',
      data: [
        for (final (index, page) in pages.indexed)
          GtDashboardPageData(page: page, navItem: _items[index]),
      ],
    );
  }
}
