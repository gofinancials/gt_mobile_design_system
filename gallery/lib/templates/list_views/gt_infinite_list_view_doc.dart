import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Documentation', type: GtInfiniteListView)
Widget playgroundGtInfiniteListViewDoc(BuildContext context) {
  final isSliver = context.knobs.boolean(
    label: 'Sliver Form',
    initialValue: false,
  );

  final codeSnippet = isSliver
      ? '''
// The sliver form observes the host scroll view's own position, so it needs
// no controller, and its footer scrolls in with the content. Refresh stays
// with the host, since RefreshIndicator is a box widget.
RefreshIndicator.adaptive(
  onRefresh: loadFirstPage,
  child: CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: header),
      GtInfiniteListSliver<Transaction>(
        data: data,
        onScrollEnd: (nudge) async {
          await loadPage(data.next);
          nudge();
        },
        child: GtCardListSliver<Transaction>(
          items: data.data,
          itemKey: (item) => ValueKey(item.uuid),
          itemBuilder: (context, item, index) => GtTransactionListTile(
            item.title,
            amount: item.amount,
            isDebit: item.isDebit,
          ),
        ),
      ),
    ],
  ),
)'''
      : '''
// The box form wraps a scroll view, and shares its controller so it can see
// how close the viewport is to the end of the extent.
GtInfiniteListView<Transaction>(
  data: data,
  controller: controller,
  onScrollEnd: (nudge) async {
    await loadPage(data.next);
    nudge();
  },
  onRefresh: loadFirstPage,
  child: GtCardListView<Transaction>(
    items: data.data,
    controller: controller,
    itemKey: (item) => ValueKey(item.uuid),
    itemBuilder: (context, item, index) => GtTransactionListTile(
      item.title,
      amount: item.amount,
      isDebit: item.isDebit,
    ),
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtInfiniteListView',
    description: '''
<b>GtInfiniteListView</b> adds pull-to-refresh and automatic pagination around a scroll view it does not build, so the rows stay the caller's choice. It is driven by a <b>PaginatedData</b>, which tells it whether another page exists and whether one is already loading.

It supports:
• Pull-to-refresh, through an adaptive refresh indicator.
• A load-more callback fired as the viewport comes within <b>threshold</b> pixels of the end of the extent, on a downward scroll only.
• A nudge callback handed to that request, which slides the freshly appended page partly into view once it has settled.
• A single request at a time — the returned future is awaited, so a second scroll tick cannot ask for the same page twice.
• A loading footer while a page is in flight, replaceable through <b>loader</b>.

<b>GtInfiniteListSliver</b> is the same pagination for a CustomScrollView. It takes the enclosing scrollable's position instead of a controller, and appends its footer as a sliver so it scrolls in at the end of the content. Refresh belongs to the host there, which wraps its scroll view in a RefreshIndicator.''',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "GtInfiniteListView" or "GtInfiniteListSliver"\nin the sidebar to scroll a live paginated list.',
      icon: GtIcons.alarmClock,
    ),
  );
}
