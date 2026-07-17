import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLimitTiles', type: GtLimitInfoListTile)
Widget gtLimitTilesUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Limit Tiles",
    description: "Tiles for displaying limits and limit progress.",
    code: '''
GtLimitInfoListTile(
  'Daily Transfer Limit',
  value: 'N500,000.00',
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtLimitInfoListTile"),
        GtLimitInfoListTile(
          context.knobs.string(label: 'Limit Label', initialValue: 'Daily Transfer Limit'),
          value: context.knobs.string(label: 'Limit Value', initialValue: 'N500,000.00'),
        ),
        const GtGap.yLg(),
        
        GalleryPageSectionHeader(title: "GtLimitEditListTile"),
        GtLimitEditListTile(
          context.knobs.string(label: 'Category', initialValue: 'Transfers'),
          value: 150000.0,
          max: 500000.0,
          onEdit: () {},
        ),
      ],
    ),
  );
}
