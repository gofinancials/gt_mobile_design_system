import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInfiniteListView', type: GtInfiniteListView)
Widget playgroundGtInfiniteListViewUseCase(BuildContext context) {
  final items = List.generate(
    10,
    (i) => _SampleItem(
      id: '$i',
      name: 'Transaction ${i + 1}',
      amount: (i + 1) * 1000,
    ),
  );

  return GtWidgetDocPage(
    title: 'GtInfiniteListView',
    description:
        'A layout template providing pull-to-refresh and automatic pagination triggers for lists.',
    child: GtSizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const GtGap.ySm(),
              itemBuilder: (_, i) {
                final item = items[i];
                return GtTransactionListTile(
                  item.name,
                  subtitle: 'Ref: TXN-${item.id.padLeft(6, '0')}',
                  amount: item.amount,
                  isDebit: i.isEven,
                );
              },
            ),
          ),
        ],
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
