import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtMenuListTile', type: GtMenuListTile)
Widget playgroundGtMenuListTileUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Menu Title',
    initialValue: 'Settings',
  );

  return GtWidgetDocPage(
    title: 'GtMenuListTile',
    description:
        'A generic list tile used for rendering menu items or options.',
    code:
        '''
GtMenuListTile<String>(
  "$text",
  value: "settings",
  icon: Icons.settings,
  onSelect: (val) {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtMenuListTile<String>(
          text,
          value: 'settings',
          icon: Icons.settings,
          onSelect: (val) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtSelectionListTile', type: GtSelectionListTile)
Widget playgroundGtSelectionListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Selection Title',
    initialValue: 'Choose Account',
  );
  final isSelected = context.knobs.boolean(
    label: 'Is Selected',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtSelectionListTile',
    description:
        'A generic selection list tile displaying a prominent checkmark when active.',
    code:
        '''
GtSelectionListTile<String>(
  "savings",
  text: "$title",
  isSelected: $isSelected,
  onSelect: (val) {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtSelectionListTile<String>(
          title,
          value: 'savings',
          isSelected: isSelected,
          onSelect: (val) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtSelectionColumnListTile',
  type: GtSelectionColumnListTile,
)
Widget playgroundGtSelectionColumnListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Column Title',
    initialValue: 'Select Branch',
  );
  final description = context.knobs.string(
    label: 'Column Description',
    initialValue: 'Head Office Branch',
  );
  final isSelected = context.knobs.boolean(
    label: 'Is Selected',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtSelectionColumnListTile',
    description:
        'A selection tile displaying a checkbox alongside stacked title and description columns.',
    code:
        '''
GtSelectionColumnListTile<String>(
  "$title",
  description: "$description",
  value: "head_office",
  isSelected: $isSelected,
  onSelect: (val) {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtSelectionColumnListTile<String>(
          title,
          description: description,
          value: 'head_office',
          isSelected: isSelected,
          onSelect: (val) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtRoleSelectionListTile',
  type: GtRoleSelectionListTile,
)
Widget playgroundGtRoleSelectionListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Role Title',
    initialValue: 'Administrator',
  );
  final description = context.knobs.string(
    label: 'Role Description',
    initialValue: 'Full system access',
  );
  final isSelected = context.knobs.boolean(
    label: 'Is Selected',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtRoleSelectionListTile',
    description:
        'A specialized role selection list tile highlighting features for authorized user roles.',
    code:
        '''
GtRoleSelectionListTile<String>(
  "$title",
  description: "$description",
  value: "admin",
  isSelected: $isSelected,
  onSelect: (val) {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtRoleSelectionListTile<String>(
          title,
          description: description,
          value: 'admin',
          isSelected: isSelected,
          onSelect: (val) {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtCountrySelectionListTile',
  type: GtCountrySelectionListTile,
)
Widget playgroundGtCountrySelectionListTileUseCase(BuildContext context) {
  final showCountryCode = context.knobs.boolean(
    label: 'Show Country Code',
    initialValue: true,
  );
  final isSelected = context.knobs.boolean(
    label: 'Is Selected',
    initialValue: true,
  );

  final country = Country(
    dial: "234",
    iSO31661Alpha2: "NG",
    countryName: "Nigeria",
  );

  return GtWidgetDocPage(
    title: 'GtCountrySelectionListTile',
    description:
        'A specialized country selection list tile showing country flag, name, dial code, and checkmark.',
    code:
        '''
GtCountrySelectionListTile(
  Country(dial: "234", iSO31661Alpha2: "NG", countryName: "Nigeria"),
  showCountryCode: $showCountryCode,
  isSelected: $isSelected,
  onSelect: (val) {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtCountrySelectionListTile(
          country,
          showCountryCode: showCountryCode,
          isSelected: isSelected,
          onSelect: (val) {},
        ),
      ),
    ),
  );
}
