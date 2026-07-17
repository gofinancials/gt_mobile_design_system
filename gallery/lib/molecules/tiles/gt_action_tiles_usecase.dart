import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtExportListTile', type: GtExportListTile)
Widget playgroundGtExportListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Export Statement',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Download transaction history as PDF.',
  );

  return GtWidgetDocPage(
    title: 'GtExportListTile',
    description:
        'A list tile tailored for export or share actions, displaying title, optional subtitle, and share icon.',
    code:
        '''
GtExportListTile(
  "$title",
  subtitle: "$subtitle",
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtExportListTile(
          title,
          subtitle: subtitle.isEmpty ? null : subtitle,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtDeviceListTile', type: GtDeviceListTile)
Widget playgroundGtDeviceListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Device Title',
    initialValue: 'iPhone 15 Pro',
  );
  final subtitle = context.knobs.string(
    label: 'Device Subtitle',
    initialValue: 'Active now • Lagos, Nigeria',
  );
  final isRemovable = context.knobs.boolean(
    label: 'Is Removable',
    initialValue: false,
  );

  final widget = isRemovable
      ? GtDeviceListTile.removable(
          title,
          subtitle: subtitle,
          icon: GtIcons.laptop,
          onRemove: () {},
          buttonText: "Remove",
        )
      : GtDeviceListTile(title, subtitle: subtitle, icon: GtIcons.android);

  return GtWidgetDocPage(
    title: 'GtDeviceListTile',
    description: 'A list tile for connected devices and active login sessions.',
    code: isRemovable
        ? '''
GtDeviceListTile.removable(
  "$title",
  subtitle: "$subtitle",
  icon: GtIcons.refreshSolid,
  onRemove: () {},
  buttonText: "Remove",
)'''
        : '''
GtDeviceListTile(
  "$title",
  subtitle: "$subtitle",
  icon: GtIcons.refreshSolid,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: widget,
      ),
    ),
  );
}
