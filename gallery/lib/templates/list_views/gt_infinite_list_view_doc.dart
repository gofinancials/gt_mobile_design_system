import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GtInfiniteListView)
Widget playgroundGtInfiniteListViewDoc(BuildContext context) {
  final hasMore = context.knobs.boolean(label: 'Has More Pages', initialValue: true);

  final codeSnippet = '''
GtInfiniteListView<Transaction>(
  itemBuilder: (context, item, index) {
    return GtTransactionListTile(
      item.title,
      amount: item.amount,
      isDebit: item.isDebit,
    );
  },
  onLoadMore: () async {
    // Load next page of data
  },
  onRefresh: () async {
    // Refresh data
  },
  hasMore: $hasMore,
  items: transactionsList,
)''';

  return GtWidgetDocPage(
    title: 'GtInfiniteListView',
    description: '''
<b>GtInfiniteListView</b> is an infinite-scroll list component designed for showing paginated lists (e.g. transaction histories).

It supports:
• Pull-to-refresh on mobile devices.
• Automatic load-more callbacks when the scroll offset approaches the bottom.
• Built-in indicator spinner while loading a page.''',
    code: codeSnippet,
    child: SizedBox(
      width: 360.px,
      height: 250.px,
      child: Center(
        child: GtText(
          'Select "Interactive Preview" in the sidebar\nto test the infinite scrolling list view in full screen.',
          style: context.textStyles.bodyM(color: context.palette.text.sub),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
