import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionTiles', type: GtExportListTile)
Widget gtActionTilesUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Action Tiles",
    description: "Tiles for specific actions like export or device management.",
    code: '''
GtExportListTile(
  'Export Statement',
  format: 'PDF',
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtExportListTile"),
        GtExportListTile('Export Statement', onTap: () {}),
        const SizedBox(height: 32),

        GalleryPageSectionHeader(title: "GtDeviceListTile"),
        GtDeviceListTile(
          'iPhone 13 Pro',
          subtitle: 'Lagos, Nigeria',
          icon: Icons.phone_iphone,
        ),
      ],
    ),
  );
}
