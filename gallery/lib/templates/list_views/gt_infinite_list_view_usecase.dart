import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive Preview',
  type: GtInfiniteListView,
)
Widget playgroundGtInfiniteListViewUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(label: 'Is Loading', initialValue: false);
  final hasMore = context.knobs.boolean(label: 'Has More Pages', initialValue: true);
  final itemCount = context.knobs.int.slider(
    label: 'Item Count',
    min: 0,
    max: 20,
    initialValue: 12,
  );

  final items = List.generate(
    itemCount,
    (i) => _SampleItem(id: '$i', name: 'Transaction ${i + 1}', amount: (i + 1) * 1000),
  );

  return GtWidgetDocPage(
    title: 'GtInfiniteListView',
    description: 'Infinite-scroll list with pull-to-refresh. Mock data shown — pagination is simulated.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: context.insets.allDp(24.px),
          child: Row(
            children: [
              Expanded(
                child: GtText(
                  '$itemCount items (${hasMore ? 'more available' : 'last page'})',
                  style: context.textStyles.bodyS(
                    color: context.palette.text.sub,
                  ),
                ),
              ),
              if (isLoading) ...[
                GtSpinner(size: 16),
                const SizedBox(width: 8),
                GtText('Loading...', style: context.textStyles.bodyXs()),
              ],
            ],
          ),
        ),
        const GtGap.yMd(),
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
  );
}

class _SampleItem {
  final String id;
  final String name;
  final int amount;
  const _SampleItem({required this.id, required this.name, required this.amount});
}
