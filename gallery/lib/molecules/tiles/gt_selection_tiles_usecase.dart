import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSelectionTiles', type: GtSelectionListTile)
Widget gtSelectionListTileUseCase(BuildContext context) {
  final countries = [];

  return GtWidgetDocPage(
    title: "Selection Tiles",
    description: "List tiles designed for selecting items or navigating menus.",
    code: '''
GtSelectionListTile(
  'Settings',
  value: 'settings',
  isSelected: true,
  onSelect: (val) {},
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtMenuListTile"),
        GtMenuListTile<String>(
          context.knobs.string(label: 'Menu Title', initialValue: 'Settings'),
          value: 'settings',
          icon: Icons.settings,
          onSelect: (val) {},
        ),
        const GtGap.yLg(),
        
        GalleryPageSectionHeader(title: "GtSelectionListTile"),
        GtSelectionListTile<String>(
          context.knobs.string(label: 'Selection Title', initialValue: 'Choose Account'),
          value: 'savings',
          isSelected: context.knobs.boolean(label: 'Is Selected', initialValue: true),
          onSelect: (val) {},
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtSelectionColumnListTile"),
        GtSelectionColumnListTile<String>(
          context.knobs.string(label: 'Column Title', initialValue: 'Select Branch'),
          description: context.knobs.string(label: 'Column Description', initialValue: 'Head Office Branch'),
          value: 'head_office',
          isSelected: context.knobs.boolean(label: 'Is Selected', initialValue: true),
          onSelect: (val) {},
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtRoleSelectionListTile"),
        GtRoleSelectionListTile<String>(
          context.knobs.string(label: 'Role Title', initialValue: 'Administrator'),
          description: context.knobs.string(label: 'Role Description', initialValue: 'Full system access'),
          value: 'admin',
          isSelected: context.knobs.boolean(label: 'Is Selected', initialValue: true),
          onSelect: (val) {},
        ),
        const GtGap.yLg(),

        if (countries.isNotEmpty) ...[
          GalleryPageSectionHeader(title: "GtCountrySelectionListTile"),
          GtCountrySelectionListTile(
            countries.first,
            isSelected: context.knobs.boolean(label: 'Is Selected', initialValue: true),
            onSelect: (val) {},
          ),
        ],
      ],
    ),
  );
}
