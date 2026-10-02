import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInfiniteListSliver', type: GtInfiniteListSliver)
Widget playgroundGtInfiniteListSliverUseCase(BuildContext context) {
  final isSkeleton = context.knobs.boolean(
    label: 'Skeleton (first page loading)',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtInfiniteListSliver',
    description:
        'The sliver form of the paginated list: it observes the host scroll view rather than a controller, and appends its loading footer to the scroll view. Scroll to the bottom to load the next page.',
    code: isSkeleton
        ? '''
GtCardListSliver.skeleton(
  itemCount: 8,
  semanticsLabel: 'Loading transactions',
  itemBuilder: (_, _) => const GtTransactionListTile.skeleton(),
)'''
        : null,
    child: GtSizedBox(
      height: 480,
      child: _InfiniteSliverDemo(isSkeleton: isSkeleton),
    ),
  );
}

/// A CustomScrollView with a header sliver above a paginated group of rows, the
/// arrangement the sliver form exists for.
class _InfiniteSliverDemo extends StatefulWidget {
  final bool isSkeleton;

  const _InfiniteSliverDemo({required this.isSkeleton});

  @override
  State<_InfiniteSliverDemo> createState() => _InfiniteSliverDemoState();
}

class _InfiniteSliverDemoState extends State<_InfiniteSliverDemo> {
  final _notifier = PaginatedDataNotifier<_SampleItem>(_SampleItem.page(1));

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  /// Appends the next page, then nudges the scroll position into it.
  Future<void> _loadMore(OnPressed nudge) async {
    final current = _notifier.value;
    _notifier.setLoading();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _notifier.value = current.addData(_SampleItem.page(current.next));
    nudge();
  }

  /// Drops back to the first page. The sliver form leaves refresh to the host,
  /// so the indicator wraps the scroll view here rather than the sliver.
  Future<void> _refresh() async {
    _notifier.setLoading();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _notifier.value = _SampleItem.page(1);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, data, _) {
        Widget list = GtInfiniteListSliver<_SampleItem>(
          data: data,
          onScrollEnd: _loadMore,
          child: GtCardListSliver<_SampleItem>(
            items: data.data,
            itemKey: (item) => ValueKey(item.uuid),
            itemBuilder: (context, item, index) => GtTransactionListTile(
              item.name,
              subtitle: 'Ref: TXN-${item.uuid.padLeft(6, '0')}',
              amount: item.amount,
              isDebit: index.isEven,
            ),
          ),
        );
        if (widget.isSkeleton) {
          list = GtCardListSliver.skeleton(
            itemCount: 8,
            semanticsLabel: 'Loading transactions',
            itemBuilder: (_, _) => const GtTransactionListTile.skeleton(),
          );
        }

        return RefreshIndicator.adaptive(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.insets.symmetricDp(vertical: 12.px),
                  child: GtText(
                    'Recent transactions',
                    style: context.textStyles.h6(),
                  ),
                ),
              ),
              list,
            ],
          ),
        );
      },
    );
  }
}

/// A sample row, identified by its uuid so pagination can key off it.
class _SampleItem extends Identifiable {
  final String name;
  final int amount;

  const _SampleItem({
    required super.uuid,
    required this.name,
    required this.amount,
  });

  /// Builds one page of ten sample rows, out of five pages in total.
  static PaginatedData<_SampleItem> page(int page) {
    final offset = (page - 1) * 10;
    return PaginatedData(
      page: page,
      pages: 5,
      limit: 10,
      updatedAt: DateTime.now(),
      data: List.generate(10, (i) {
        final index = offset + i;
        return _SampleItem(
          uuid: '$index',
          name: 'Transaction ${index + 1}',
          amount: (index + 1) * 1000,
        );
      }),
    );
  }

  @override
  List<Object?> get props => [uuid, name, amount];
}
