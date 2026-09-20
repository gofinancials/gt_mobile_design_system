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

void main() {
  testWidgets('GtInfiniteListView requests a page at the end of the extent', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var requests = 0;

    await tester.pumpWidget(
      _ListTestApp(
        child: GtInfiniteListView<_Row>(
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
        child: GtInfiniteListView<_Row>(
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
        child: GtInfiniteListView<_Row>(
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
        child: GtInfiniteListView<_Row>(
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
        child: GtInfiniteListView<_Row>(
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
            GtInfiniteListSliver<_Row>(
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
            GtInfiniteListSliver<_Row>(
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
            GtInfiniteListSliver<_Row>(
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
}
