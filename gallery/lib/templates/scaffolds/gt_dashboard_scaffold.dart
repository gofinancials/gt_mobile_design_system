import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final pageController = ValueNotifier(0);

@widgetbook.UseCase(name: 'GtDashboardScaffold', type: GtDashboardScaffold)
Widget playgroundGtDashboardScaffoldUseCase(BuildContext context) {
  final style = context.knobs.object.dropdown<GtBottomNavigationStyle>(
    label: 'Navigation Style',
    options: GtBottomNavigationStyle.values,
    initialOption: GtBottomNavigationStyle.ios,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtDashboardScaffold',
    description: 'A complete dashboard scaffold that coordinates pages, app bars, and bottom navigation states.',
    code: '''
GtDashboardScaffold(
  pageController: pageController,
  bottomNavigationStyle: GtBottomNavigationStyle.${style.name},
  data: [
    GtDashboardPageData(
      page: HomePage(),
      appBar: GtHomeAppBar(),
      navItem: GtBottomNavigationItem(
        selectedIcon: GtIcons.homeFilled,
        unselectedIcon: GtIcons.home,
        label: 'Home',
      ),
    ),
  ],
)''',
    child: GtEmptyStateCard(
      variant: GtCardVariant.normal,
      icon: GtIcons.alarmClock,
      description: 'Please refer to the "GtDashboardScaffold Gallery" page in Widgetbook to preview the active dashboard scaffold layout in its full-screen interactive context.',
    ),
  );
}

@widgetbook.UseCase(name: 'GtDashboardScaffold Gallery', type: GtDashboardScaffold)
Widget buildGtDashboardScaffoldGallery(BuildContext context) {
  return const _DashboardScaffoldPreview();
}

class _DashboardScaffoldPreview extends StatefulWidget {
  const _DashboardScaffoldPreview();

  @override
  State<_DashboardScaffoldPreview> createState() => _DashboardScaffoldPreviewState();
}

class _DashboardScaffoldPreviewState extends State<_DashboardScaffoldPreview> {
  final List<GtBottomNavigationItem> _items = const [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: 'Home',
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
          style: context.textStyles.h6(),
        ),
      ),
      appBar: GtHomeAppBar(
        userFullName: "Alex Lobaloba",
        onClickSearch: () {},
        onClickNotification: () {},
        onClickAvatar: () {},
      ),
      navItem: _items[0],
      showGradient: true,
    ),
    GtDashboardPageData(
      appBar: GtTitleAppBar(title: "Cards"),
      page: Center(
        child: GtText(
          'Cards Page',
          style: context.textStyles.h6(),
        ),
      ),
      navItem: _items[1],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GtDashboardScaffold(
      onClickHelp: () {},
      data: data,
      pageController: pageController,
      bottomNavigationStyle: context.knobs.object.dropdown<GtBottomNavigationStyle>(
        label: "Bottom Navigation Style",
        options: GtBottomNavigationStyle.values,
        initialOption: GtBottomNavigationStyle.ios,
        labelBuilder: (value) => value.name,
      ),
    );
  }
}
