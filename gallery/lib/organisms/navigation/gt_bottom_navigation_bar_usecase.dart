import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBottomNavigationBar', type: GtBottomNavigationBar)
Widget playgroundGtBottomNavigationBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtBottomNavigationBar',
    description: 'Documentation for GtBottomNavigationBar',
    code: '''
GtBottomNavigationBar(
  currentIndex: 0,
  onIndexChanged: (index) {},
  items: [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: "Home",
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.transfer,
      unselectedIcon: GtIcons.transfer,
      label: "Transfer",
    ),
  ],
)
''',
    child: GtBottomNavigationBar(
      currentIndex: 0,
      onIndexChanged: (index) {},
      items: [
        GtBottomNavigationItem(
          selectedIcon: GtIcons.homeFilled,
          unselectedIcon: GtIcons.home,
          label: "Home",
        ),
        GtBottomNavigationItem(
          selectedIcon: GtIcons.transfer,
          unselectedIcon: GtIcons.transfer,
          label: "Transfer",
        ),
      ],
    ),
  );
}
