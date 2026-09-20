import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCardListView', type: GtCardListView)
Widget playgroundGtCardListViewUseCase(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Items',
    initialValue: 4,
    min: 1,
    max: 12,
    divisions: 11,
  );

  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.normal,
    labelBuilder: (value) => value.name,
  );

  final tinted = context.knobs.boolean(
    label: 'Custom Background',
    initialValue: false,
  );

  final items = List.generate(
    count,
    (i) => _SampleItem(
      id: '$i',
      name: 'Transaction ${i + 1}',
      amount: (i + 1) * 1000,
    ),
  );

  return GtWidgetDocPage(
    title: 'GtCardListView',
    description:
        'A lazily built list whose rows are stitched into one continuous card surface, with divider tiles between them.',
    child: GtSizedBox(
      height: 400,
      child: GtCardListView<_SampleItem>(
        items: items,
        variant: variant,
        backgroundColor: tinted ? context.palette.primary.alpha10 : null,
        itemKey: (item) => ValueKey(item.id),
        itemBuilder: (context, item, index) => GtTransactionListTile(
          item.name,
          subtitle: 'Ref: TXN-${item.id.padLeft(6, '0')}',
          amount: item.amount,
          isDebit: index.isEven,
        ),
      ),
    ),
  );
}

class _SampleItem {
  final String id;
  final String name;
  final int amount;
  const _SampleItem({
    required this.id,
    required this.name,
    required this.amount,
  });
}
