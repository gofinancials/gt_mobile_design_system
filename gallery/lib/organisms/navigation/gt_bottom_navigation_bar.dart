import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Interactive preview for [GtBottomNavigationBar].
enum _BottomNavTabsPreset {
  fourTabs('4 tabs');

  final String label;
  const _BottomNavTabsPreset(this.label);

  List<GtBottomNavigationItem> get items {
    return switch (this) {
      _BottomNavTabsPreset.fourTabs => const [
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
      ],
    };
  }
}

@widgetbook.UseCase(
  name: 'Bottom Navigation Bar',
  type: GtBottomNavigationBar,
  path: '[Organisms]/Navigation',
)
Widget playgroundGtBottomNavigationBarUseCase(BuildContext context) {
  final preset = context.knobs.object.dropdown<_BottomNavTabsPreset>(
    label: 'Tabs preset',
    options: _BottomNavTabsPreset.values,
    initialOption: _BottomNavTabsPreset.fourTabs,
    labelBuilder: (value) => value.label,
  );
  final tabs = preset.items;

  return Scaffold(
    backgroundColor: GtColors.neutralWarm50.value,
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const GalleryPageHeader(
            title: 'Bottom Navigation Bar',
            rider: 'iOS-style floating bottom navigation playground.',
          ),
          const GtGap.yXl(),
          // Use case 1: Bottom nav with trailing help action.
          _BottomNavPreview(
            items: tabs,
            initialIndex: 0,
            withTrailingAction: true,
          ),
        ],
      ),
    ),
  );
}

class _BottomNavPreview extends StatefulWidget {
  final List<GtBottomNavigationItem> items;
  final int initialIndex;
  final bool withTrailingAction;

  const _BottomNavPreview({
    required this.items,
    this.initialIndex = 0,
    this.withTrailingAction = false,
  });

  @override
  State<_BottomNavPreview> createState() => _BottomNavPreviewState();
}

class _BottomNavPreviewState extends State<_BottomNavPreview> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return GtBottomNavigationBar(
      items: widget.items,
      currentIndex: _index,
      onIndexChanged: (index) => setState(() => _index = index),
      onTrailingTap: widget.withTrailingAction ? () {} : null,
    );
  }
}
