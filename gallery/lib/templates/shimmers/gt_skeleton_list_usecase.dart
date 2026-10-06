import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _rowPresets = [
  'GtTransactionListTile',
  'GtPaymentListTile',
  'GtInfoListTile',
  'GtListTile',
  'GtAccountListTile',
  'GtContactListTile',
  'GtSelectionListTile',
  'GtGoalProgressListTile',
  'GtStandardTextTileTemplate',
  'GtSectionHeader',
  'GtTransactionGroupHeader',
  'GtInboxCard',
  'GtBillCard',
  'GtBillCard.tile',
  'GtNotificationCard',
  'GtPaymentSourceCard',
  'GtAddressCard',
  'GtSummaryTile',
];

@widgetbook.UseCase(name: 'GtSkeletonList', type: GtSkeletonList)
Widget playgroundGtSkeletonListUseCase(BuildContext context) {
  final preset = context.knobs.object.dropdown<String>(
    label: 'Row',
    options: _rowPresets,
    initialOption: _rowPresets.first,
    labelBuilder: (v) => v,
  );
  final itemCount = context.knobs.int.slider(
    label: 'Item Count',
    initialValue: 6,
    min: 1,
    max: 20,
  );
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    initialValue: 8,
    min: 0,
    max: 24,
  );

  return GtWidgetDocPage(
    title: 'GtSkeletonList',
    description:
        'A list of skeleton rows standing in for a list that is still loading. Every row builder is the skeleton() of the row the list shows once it loads, so the skeleton keeps the real list\'s rhythm. Use GtSkeletonList.sliver inside a CustomScrollView.',
    code:
        '''
GtSkeletonList(
  itemCount: $itemCount,
  spacing: ${spacing.toStringAsFixed(0)},
  semanticsLabel: 'Loading',
  itemBuilder: (context, i) => ${_getRowCode(preset)},
)''',
    child: GtSizedBox(
      height: 480,
      child: GtSkeletonList(
        itemCount: itemCount,
        spacing: spacing,
        semanticsLabel: 'Loading',
        itemBuilder: (_, _) => _getRow(preset),
      ),
    ),
  );
}

String _getRowCode(String preset) {
  return switch (preset) {
    'GtBillCard.tile' => 'GtBillCard.tileSkeleton()',
    'GtSelectionListTile' => 'GtSelectionListTile<int>.skeleton(value: 0)',
    _ => '$preset.skeleton()',
  };
}

Widget _getRow(String preset) {
  return switch (preset) {
    'GtPaymentListTile' => GtPaymentListTile.skeleton(),
    'GtInfoListTile' => GtInfoListTile.skeleton(),
    'GtListTile' => GtListTile.skeleton(),
    'GtAccountListTile' => GtAccountListTile.skeleton(),
    'GtContactListTile' => GtContactListTile.skeleton(),
    'GtSelectionListTile' => const GtSelectionListTile<int>.skeleton(value: 0),
    'GtGoalProgressListTile' => GtGoalProgressListTile.skeleton(),
    'GtStandardTextTileTemplate' => GtStandardTextTileTemplate.skeleton(),
    'GtSectionHeader' => GtSectionHeader.skeleton(),
    'GtTransactionGroupHeader' => GtTransactionGroupHeader.skeleton(),
    'GtInboxCard' => GtInboxCard.skeleton(),
    'GtBillCard' => GtBillCard.skeleton(),
    'GtBillCard.tile' => GtBillCard.tileSkeleton(),
    'GtNotificationCard' => GtNotificationCard.skeleton(),
    'GtPaymentSourceCard' => GtPaymentSourceCard.skeleton(),
    'GtAddressCard' => GtAddressCard.skeleton(),
    'GtSummaryTile' => GtSummaryTile.skeleton(),
    _ => GtTransactionListTile.skeleton(),
  };
}
