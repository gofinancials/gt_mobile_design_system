import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _ListTestApp extends GtStatelessWidget {
  final Widget child;

  const _ListTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

class _Row extends Identifiable {
  const _Row(String uuid) : super(uuid: uuid);
}

/// Builds page state with [count] rows, on [page] of [pages].
PaginatedData<_Row> _data({
  int count = 40,
  int page = 1,
  int pages = 3,
  bool isLoading = false,
}) {
  return PaginatedData(
    page: page,
    pages: pages,
    limit: count,
    isLoading: isLoading,
    updatedAt: DateTime.now(),
    data: List.generate(count, (i) => _Row('$i')),
  );
}

/// A tall scroll view, so there is always extent to scroll through.
Widget _rows(ScrollController controller, {int count = 40}) {
  return ListView.builder(
    controller: controller,
    itemCount: count,
    itemBuilder: (context, index) => GtSizedBox(height: 80),
  );
}

/// A history that appends a page of [pageSize] rows on every request and
/// nudges once it has, as a consumer would.
///
/// Every page requested is recorded in [requested].
class _PagedHistory extends StatefulWidget {
  final ScrollController controller;
  final List<int> requested;
  final bool sliver;

  const _PagedHistory({
    required this.controller,
    required this.requested,
    this.sliver = false,
  });

  static const pageSize = 20;
  static const pages = 20;
  static const rowHeight = 60.0;

  @override
  State<_PagedHistory> createState() => _PagedHistoryState();
}

class _PagedHistoryState extends State<_PagedHistory> {
  int _page = 1;

  Future<void> _next(OnPressed nudge) async {
    widget.requested.add(_page + 1);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _page++);
    nudge();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data(
      count: _page * _PagedHistory.pageSize,
      page: _page,
      pages: _PagedHistory.pages,
    );
    final count = data.data.length;
    Widget row(BuildContext context, int index) {
      return GtSizedBox(height: _PagedHistory.rowHeight);
    }

    if (widget.sliver) {
      return CustomScrollView(
        controller: widget.controller,
        slivers: [
          GtInfiniteListSliver<String>(
            data: data,
            onScrollEnd: _next,
            child: SliverList.builder(itemCount: count, itemBuilder: row),
          ),
        ],
      );
    }

    return GtInfiniteListView<String>(
      data: data,
      controller: widget.controller,
      onRefresh: () async {},
      onScrollEnd: _next,
      child: ListView.builder(
        controller: widget.controller,
        itemCount: count,
        itemBuilder: row,
      ),
    );
  }
}

void main() {
  testWidgets('GtInfiniteListView requests a page at the end of the extent', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<String>(
          data: _data(),
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async => requests++,
          child: _rows(controller),
        ),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(requests, 1);
  });

  testWidgets('GtInfiniteListView holds off when there is no next page', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<String>(
          data: _data(page: 3, pages: 3),
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async => requests++,
          child: _rows(controller),
        ),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(requests, 0);
  });

  testWidgets('GtInfiniteListView holds off while a page is already loading', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<String>(
          data: _data(isLoading: true),
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async => requests++,
          child: _rows(controller),
        ),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(requests, 0);
  });

  testWidgets('GtInfiniteListView requests one page while one is in flight', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final pending = Completer<void>();
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<String>(
          data: _data(),
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) {
            requests++;
            return pending.future;
          },
          child: _rows(controller),
        ),
      ),
    );

    final max = controller.position.maxScrollExtent;
    controller.jumpTo(max - 20);
    await tester.pump();
    controller.jumpTo(max);
    await tester.pump();

    expect(requests, 1);

    pending.complete();
    await tester.pump();
  });

  testWidgets('GtInfiniteListView shows its footer while a page loads', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    Widget appWith(PaginatedData<_Row> data) {
      return _ListTestApp(
        child: GtInfiniteListView<String>(
          data: data,
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async {},
          child: _rows(controller),
        ),
      );
    }

    await tester.pumpWidget(appWith(_data()));
    expect(find.byType(GtProgress), findsNothing);

    await tester.pumpWidget(appWith(_data(isLoading: true)));
    expect(find.byType(GtProgress), findsOneWidget);
  });

  testWidgets('GtInfiniteListView fills a viewport a short page leaves empty', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<String>(
          data: _data(count: 2),
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async => requests++,
          child: _rows(controller, count: 2),
        ),
      ),
    );
    await tester.pump();

    expect(controller.position.maxScrollExtent, 0);
    expect(requests, 1);
  });

  testWidgets('GtInfiniteListView stops filling once a page comes back empty', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    Widget appWith(PaginatedData<_Row> data) {
      return _ListTestApp(
        child: GtInfiniteListView<String>(
          data: data,
          controller: controller,
          onRefresh: () async {},
          onScrollEnd: (nudge) async => requests++,
          child: _rows(controller, count: data.data.length),
        ),
      );
    }

    await tester.pumpWidget(appWith(_data(count: 2)));
    await tester.pump();
    expect(requests, 1);

    // The page came back with nothing in it, so the short viewport must not be
    // grounds for asking again.
    await tester.pumpWidget(appWith(_data(count: 2, page: 2)));
    await tester.pump();

    expect(requests, 1);
  });

  testWidgets(
    'GtInfiniteListSliver fills a viewport a short page leaves empty',
    (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      var requests = 0;

      await tester.pumpWidget(
        _ListTestApp(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              GtInfiniteListSliver<String>(
                data: _data(count: 2),
                onScrollEnd: (nudge) async => requests++,
                child: SliverList.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => GtSizedBox(height: 80),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(controller.position.maxScrollExtent, 0);
      expect(requests, 1);
    },
  );

  testWidgets('GtInfiniteListSliver paginates the host scroll view', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            GtInfiniteListSliver<String>(
              data: _data(),
              onScrollEnd: (nudge) async => requests++,
              child: SliverList.builder(
                itemCount: 40,
                itemBuilder: (context, index) => GtSizedBox(height: 80),
              ),
            ),
          ],
        ),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(requests, 1);
  });

  testWidgets('GtInfiniteListSliver re-attaches when the host position swaps', (
    tester,
  ) async {
    final first = ScrollController();
    final second = ScrollController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    var requests = 0;

    Widget appWith(ScrollController controller) {
      return _ListTestApp(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            GtInfiniteListSliver<String>(
              data: _data(),
              onScrollEnd: (nudge) async => requests++,
              child: SliverList.builder(
                itemCount: 40,
                itemBuilder: (context, index) => GtSizedBox(height: 80),
              ),
            ),
          ],
        ),
      );
    }

    await tester.pumpWidget(appWith(first));
    await tester.pumpWidget(appWith(second));

    second.jumpTo(second.position.maxScrollExtent);
    await tester.pump();

    expect(requests, 1);
  });

  testWidgets('GtInfiniteListSliver keeps its footer inside the scroll view', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ListTestApp(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            GtInfiniteListSliver<String>(
              data: _data(count: 2, isLoading: true),
              onScrollEnd: (nudge) async {},
              child: SliverList.builder(
                itemCount: 2,
                itemBuilder: (context, index) => GtSizedBox(height: 80),
              ),
            ),
          ],
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(GtProgress),
      ),
      findsOneWidget,
    );
  });
  for (final sliver in [false, true]) {
    final name = sliver ? 'GtInfiniteListSliver' : 'GtInfiniteListView';

    testWidgets('$name nudges without paging on by itself', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final requested = <int>[];

      await tester.pumpWidget(
        _ListTestApp(
          child: _PagedHistory(
            controller: controller,
            requested: requested,
            sliver: sliver,
          ),
        ),
      );

      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump();
      expect(requested, [2]);

      // Let page two land and the nudge play out.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      final settled = controller.offset;
      await tester.pumpAndSettle();

      // The nudge slid the new page into view...
      expect(controller.offset, greaterThan(settled));
      // ...without reaching the threshold that would ask for page three.
      final position = controller.position;
      expect(
        position.maxScrollExtent - position.pixels,
        greaterThan(kGtScrollEndThreshold),
      );

      // Nobody touches the screen for a while.
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      expect(requested, [2]);
    });
  }
}
