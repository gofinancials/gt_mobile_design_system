import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBottomNavigationBar', type: GtBottomNavigationBar)
Widget playgroundGtBottomNavigationBarUseCase(BuildContext context) {
  return const _BottomNavPlayground();
}

class _BottomNavPlayground extends StatefulWidget {
  const _BottomNavPlayground();

  @override
  State<_BottomNavPlayground> createState() => _BottomNavPlaygroundState();
}

class _BottomNavPlaygroundState extends State<_BottomNavPlayground> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final style = context.knobs.object.dropdown<GtBottomNavigationStyle>(
      label: 'Platform style',
      options: GtBottomNavigationStyle.values,
      initialOption: GtBottomNavigationStyle.ios,
      labelBuilder: (s) => switch (s) {
        .ios => 'iOS (floating)',
        .android => 'Android (Material)',
      },
    );

    final label1 = context.knobs.string(
      label: 'Item 1 Label',
      initialValue: 'Home',
    );
    final label2 = context.knobs.string(
      label: 'Item 2 Label',
      initialValue: 'Cards',
    );
    final label3 = context.knobs.string(
      label: 'Item 3 Label',
      initialValue: 'Settings',
    );
    final enableSelectionAnimation = context.knobs.boolean(
      label: 'Enable Selection Animation',
      initialValue: true,
    );

    return GtWidgetDocPage(
      title: 'GtBottomNavigationBar',
      description:
          'The standard app bottom navigation bar with state management and smooth tab transitioning.',
      code:
          '''
GtBottomNavigationBar(
  currentIndex: $_currentIndex,
  style: .${style.name},
  enableSelectionAnimation: $enableSelectionAnimation,
  onIndexChanged: (index) {
    // setState(() => currentIndex = index);
  },
  items: [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: "$label1",
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.cardFilled,
      unselectedIcon: GtIcons.card,
      label: "$label2",
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.gear,
      unselectedIcon: GtIcons.gear,
      label: "$label3",
    ),
  ],
  onTrailingTap: () {},
)''',
      child: GtBottomNavigationBar(
        currentIndex: _currentIndex,
        enableSelectionAnimation: enableSelectionAnimation,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        style: style,
        items: [
          GtBottomNavigationItem(
            selectedIcon: GtIcons.homeFilled,
            unselectedIcon: GtIcons.home,
            label: label1,
          ),
          GtBottomNavigationItem(
            selectedIcon: GtIcons.cardFilled,
            unselectedIcon: GtIcons.card,
            label: label2,
          ),
          GtBottomNavigationItem(
            selectedIcon: GtIcons.gear,
            unselectedIcon: GtIcons.gear,
            label: label3,
          ),
        ],
        onTrailingTap: () {},
      ),
    );
  }
}
