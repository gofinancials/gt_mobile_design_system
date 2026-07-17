import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInfoTiles', type: GtSimpleInfoTile)
Widget gtInfoTilesUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Information Tiles",
    description: "Various tiles for displaying informational data, instructions, and copyable text.",
    code: '''
GtDoubleColumnListTile(
  'Date',
  value: 'Oct 24, 2023',
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtCopyTile"),
        GtCopyTile(
          context.knobs.string(label: 'Copy Label', initialValue: 'Account Number'),
          value: context.knobs.string(label: 'Copy Value', initialValue: '0029384820'),
          leading: Icons.account_balance,
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtInstructionListTile"),
        GtInstructionListTile(
          context.knobs.string(label: 'Instruction', initialValue: 'Please verify your email address to proceed.'),
          icon: Icons.info_outline,
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtDoubleColumnListTile"),
        GtDoubleColumnListTile(
          context.knobs.string(label: 'Label', initialValue: 'Date'),
          value: context.knobs.string(label: 'Value', initialValue: 'Oct 24, 2023'),
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtSimpleInfoTile"),
        GtSimpleInfoTile(
          leading: const GtIcon(Icons.info, size: 16),
          text: context.knobs.string(label: 'Info Text', initialValue: 'Fee: N10.00'),
        ),
      ],
    ),
  );
}
