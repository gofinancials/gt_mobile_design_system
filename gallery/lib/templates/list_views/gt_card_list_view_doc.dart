import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GtCardListView)
Widget playgroundGtCardListViewDoc(BuildContext context) {
  final isSliver = context.knobs.boolean(
    label: 'Sliver Form',
    initialValue: false,
  );

  final codeSnippet = isSliver
      ? '''
CustomScrollView(
  slivers: [
    GtCardListSliver<Transaction>(
      items: transactions,
      itemKey: (item) => ValueKey(item.id),
      itemBuilder: (context, item, index) {
        return GtTransactionListTile(
          item.title,
          amount: item.amount,
          isDebit: item.isDebit,
        );
      },
    ),
  ],
)'''
      : '''
GtCardListView<Transaction>(
  items: transactions,
  itemKey: (item) => ValueKey(item.id),
  itemBuilder: (context, item, index) {
    return GtTransactionListTile(
      item.title,
      amount: item.amount,
      isDebit: item.isDebit,
    );
  },
)''';

  return GtWidgetDocPage(
    title: 'GtCardListView',
    description: '''
<b>GtCardListView</b> builds a grouped card list: rows stitched into one continuous rounded card surface, the shape used for beneficiaries, transaction history, accounts and saved billers.

It provides:
• Lazy row building, so only the rows the viewport reaches are built.
• Separators drawn as divider tiles, which keep the card surface unbroken behind the gap — a bare gap would split the group into two boxes.
• Keys taken from the item rather than its index, so a row keeps its element when filtering or pagination moves it.
• A backgroundColor override applied to rows and separators alike, for a surface the variant defaults do not cover.

<b>GtCardListSliver</b> is the same list for use inside a CustomScrollView; prefer it there, since a shrink-wrapped list builds every row eagerly. Pagination composes on top by wrapping the host scroll view in a GtInfiniteListView.''',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "GtCardListView" in the sidebar\nto see the grouped card list.',
      icon: GtIcons.alarmClock,
    ),
  );
}
