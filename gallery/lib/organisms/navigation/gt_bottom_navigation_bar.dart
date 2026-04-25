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

String _styleLabel(GtBottomNavigationStyle s) {
  return switch (s) {
    GtBottomNavigationStyle.ios => 'iOS (floating)',
    GtBottomNavigationStyle.android => 'Android (Material)',
  };
}

@widgetbook.UseCase(name: 'Bottom Navigation Bar', type: GtBottomNavigationBar)
Widget playgroundGtBottomNavigationBarUseCase(BuildContext context) {
  final preset = context.knobs.object.dropdown<_BottomNavTabsPreset>(
    label: 'Tabs preset',
    options: _BottomNavTabsPreset.values,
    initialOption: _BottomNavTabsPreset.fourTabs,
    labelBuilder: (value) => value.label,
  );
  final style = context.knobs.object.dropdown<GtBottomNavigationStyle>(
    label: 'Platform style',
    options: GtBottomNavigationStyle.values,
    initialOption: GtBottomNavigationStyle.ios,
    labelBuilder: _styleLabel,
  );
  final tabs = preset.items;

  final rider = style == GtBottomNavigationStyle.ios
      ? 'iOS-style floating bottom navigation playground.'
      : 'Android-style bottom navigation playground.';

  return Scaffold(
    backgroundColor: context.palette.bg.neutralWarm50,
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GalleryPageHeader(title: 'Bottom Navigation Bar', rider: rider),
          const GtGap.yXl(),
          if (style == GtBottomNavigationStyle.ios)
            _BottomNavPreviewIos(
              items: tabs,
              initialIndex: 0,
              withTrailingAction: true,
            ),
        ],
      ),
    ),
    bottomNavigationBar: style == GtBottomNavigationStyle.android
        ? _BottomNavAndroidPreview(items: tabs, initialIndex: 0)
        : null,
  );
}

/// iOS floating bar preview (in-page, optional trailing pill).
class _BottomNavPreviewIos extends StatefulWidget {
  final List<GtBottomNavigationItem> items;
  final int initialIndex;
  final bool withTrailingAction;

  const _BottomNavPreviewIos({
    required this.items,
    this.initialIndex = 0,
    this.withTrailingAction = false,
  });

  @override
  State<_BottomNavPreviewIos> createState() => _BottomNavPreviewIosState();
}

class _BottomNavPreviewIosState extends State<_BottomNavPreviewIos> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return GtBottomNavigationBar(
      style: GtBottomNavigationStyle.ios,
      items: widget.items,
      currentIndex: _index,
      onIndexChanged: (index) => setState(() => _index = index),
      onTrailingTap: widget.withTrailingAction ? () {} : null,
    );
  }
}

/// Android [BottomNavigationBar] host for gallery [Scaffold.bottomNavigationBar].
class _BottomNavAndroidPreview extends StatefulWidget {
  final List<GtBottomNavigationItem> items;
  final int initialIndex;

  const _BottomNavAndroidPreview({required this.items, this.initialIndex = 0});

  @override
  State<_BottomNavAndroidPreview> createState() =>
      _BottomNavAndroidPreviewState();
}

class _BottomNavAndroidPreviewState extends State<_BottomNavAndroidPreview> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return GtAndroidBottomNavigationBar(
      items: widget.items,
      currentIndex: _index,
      onIndexChanged: (index) => setState(() => _index = index),
    );
  }
}
