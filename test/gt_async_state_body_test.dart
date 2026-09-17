import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _Item extends Identifiable {
  const _Item(String id) : super(uuid: id);
}

const _empty = 'Nothing here yet';
const _errorTitle = 'Something went wrong';
const _dataKey = Key('data-arm');

class _AsyncStateTestApp extends GtStatelessWidget {
  final Widget child;

  const _AsyncStateTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

Widget _body(FutureListData<_Item> task, {OnPressed? onRetry}) {
  return _AsyncStateTestApp(
    child: GtAsyncStateBody(
      task: task,
      emptyDescription: _empty,
      emptyIcon: GtIcons.file,
      errorTitle: _errorTitle,
      retryLabel: onRetry == null ? null : 'Retry',
      onRetry: onRetry,
      builder: (context) => const GtText('data', key: _dataKey),
    ),
  );
}

void main() {
  const item = _Item('1');

  group('GtAsyncStateArm.of', () {
    test('a pristine task is loading, never empty', () {
      expect(
        GtAsyncStateArm.of(const FutureListData<_Item>.pristine()),
        GtAsyncStateArm.loading,
      );
    });

    test('data wins over a refresh in flight', () {
      final task = FutureListData<_Item>(
        data: const [item],
        isLoading: true,
        updatedAt: DateTime.now(),
      );

      expect(GtAsyncStateArm.of(task), GtAsyncStateArm.data);
    });

    test('data wins over an error arriving over cached data', () {
      final task = FutureListData<_Item>(
        data: const [item],
        error: const TaskError(message: 'Network unreachable'),
        updatedAt: DateTime.now(),
      );

      expect(GtAsyncStateArm.of(task), GtAsyncStateArm.data);
    });

    test('an error with no data is the error arm', () {
      final task = FutureListData<_Item>(
        error: const TaskError(message: 'Network unreachable'),
        updatedAt: DateTime.now(),
      );

      expect(GtAsyncStateArm.of(task), GtAsyncStateArm.error);
    });

    test('a completed result with no data is empty', () {
      final task = FutureListData<_Item>(updatedAt: DateTime.now());

      expect(GtAsyncStateArm.of(task), GtAsyncStateArm.empty);
    });

    test('a pristine single-value task is loading', () {
      expect(
        GtAsyncStateArm.of(const FutureData<_Item>.pristine()),
        GtAsyncStateArm.loading,
      );
    });
  });

  testWidgets('a pristine task shows the spinner, not the empty card', (
    tester,
  ) async {
    await tester.pumpWidget(_body(const FutureListData<_Item>.pristine()));

    expect(find.byType(GtSpinner), findsOneWidget);
    expect(find.text(_empty), findsNothing);
    expect(find.byKey(_dataKey), findsNothing);
  });

  testWidgets('a completed empty result shows the empty card', (tester) async {
    await tester.pumpWidget(
      _body(FutureListData<_Item>(updatedAt: DateTime.now())),
    );

    expect(find.byType(GtEmptyStateCard), findsOneWidget);
    expect(find.text(_empty), findsOneWidget);
    expect(find.byType(GtSpinner), findsNothing);
  });

  testWidgets('an error with no data shows a retryable error state', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      _body(
        FutureListData<_Item>(
          error: const TaskError(message: 'Network unreachable'),
          updatedAt: DateTime.now(),
        ),
        onRetry: () => retries++,
      ),
    );

    final status = tester.widget<GtStatusState>(find.byType(GtStatusState));
    expect(status.title, _errorTitle);
    expect(status.subtitle, 'Network unreachable');

    await tester.tap(find.byType(GtRaisedButton));
    await tester.pump();

    expect(retries, 1);
  });

  testWidgets('a refresh over data keeps the data arm on screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _body(
        FutureListData<_Item>(
          data: const [item],
          isLoading: true,
          updatedAt: DateTime.now(),
        ),
      ),
    );

    expect(find.byKey(_dataKey), findsOneWidget);
    expect(find.byType(GtSpinner), findsNothing);
  });

  testWidgets('an error over data keeps the data arm on screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _body(
        FutureListData<_Item>(
          data: const [item],
          error: const TaskError(message: 'Network unreachable'),
          updatedAt: DateTime.now(),
        ),
      ),
    );

    expect(find.byKey(_dataKey), findsOneWidget);
    expect(find.byType(GtStatusState), findsNothing);
  });

  testWidgets('the loading override replaces the spinner', (tester) async {
    const skeletonKey = Key('skeleton');

    await tester.pumpWidget(
      _AsyncStateTestApp(
        child: GtAsyncStateBody(
          task: const FutureListData<_Item>.pristine(),
          emptyDescription: _empty,
          errorTitle: _errorTitle,
          loading: const SizedBox(key: skeletonKey, height: 48),
          builder: (context) => const GtText('data', key: _dataKey),
        ),
      ),
    );

    expect(find.byKey(skeletonKey), findsOneWidget);
    expect(find.byType(GtSpinner), findsNothing);
  });

  group('GtAsyncStateSliver', () {
    testWidgets('is a sliver render object, not a box wrapper', (tester) async {
      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(updatedAt: DateTime.now()),
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
                empty: const SliverToBoxAdapter(child: GtText(_empty)),
              ),
            ],
          ),
        ),
      );

      final renderObject = tester.renderObject(find.byType(GtAsyncStateSliver));
      expect(renderObject, isA<RenderSliver>());
      expect(renderObject, isA<RenderSliverPadding>());
    });

    testWidgets('switches to the arm sliver and never boxes it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(updatedAt: DateTime.now()),
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
                empty: const SliverToBoxAdapter(child: GtText(_empty)),
              ),
            ],
          ),
        ),
      );

      expect(find.text(_empty), findsOneWidget);
      expect(find.byKey(_dataKey), findsNothing);
      expect(find.byType(SliverFillRemaining), findsNothing);
      expect(find.byType(GtAsyncStateBody), findsNothing);
    });

    testWidgets('keeps a million-row data sliver lazy', (tester) async {
      final items = [for (var i = 0; i < 1000000; i++) _Item('$i')];

      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(
                  data: items,
                  updatedAt: DateTime.now(),
                ),
                sliver: SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) =>
                      SizedBox(height: 100, child: GtText('row $i')),
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('row 0'), findsOneWidget);
      expect(find.text('row 999999'), findsNothing);
      expect(find.byType(SizedBox).evaluate().length, lessThan(100));
    });

    testWidgets('keeps a loading skeleton sliver lazy too', (tester) async {
      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: const FutureListData<_Item>.pristine(),
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
                loading: SliverList.builder(
                  itemCount: 10000,
                  itemBuilder: (context, i) =>
                      SizedBox(height: 64, child: GtText('skeleton $i')),
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('skeleton 0'), findsOneWidget);
      expect(find.text('skeleton 9999'), findsNothing);
      expect(find.byType(SliverFillRemaining), findsNothing);
    });

    testWidgets('renders nothing for an arm left null', (tester) async {
      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(updatedAt: DateTime.now()),
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
              ),
            ],
          ),
        ),
      );

      final sliver = tester.renderObject<RenderSliverPadding>(
        find.byType(GtAsyncStateSliver, skipOffstage: false),
      );
      expect(sliver.child, isNull);
      expect(sliver.geometry!.scrollExtent, 0);
      expect(find.byKey(_dataKey), findsNothing);
    });

    testWidgets('pads every arm with the fallback inset by default', (
      tester,
    ) async {
      for (final task in [
        FutureListData<_Item>(updatedAt: DateTime.now()),
        FutureListData<_Item>(data: const [item], updatedAt: DateTime.now()),
      ]) {
        await tester.pumpWidget(
          _AsyncStateTestApp(
            child: CustomScrollView(
              slivers: [
                GtAsyncStateSliver(
                  task: task,
                  sliver: const SliverToBoxAdapter(
                    child: GtText('data', key: _dataKey),
                  ),
                  empty: const SliverToBoxAdapter(child: GtText(_empty)),
                ),
              ],
            ),
          ),
        );

        final sliver = tester.renderObject<RenderSliverPadding>(
          find.byType(GtAsyncStateSliver),
        );
        // The data arm is inset too — the fallback is not arm-conditional.
        expect(sliver.resolvedPadding!.horizontal, greaterThan(0));
      }
    });

    testWidgets('honours a caller-supplied padding, including zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(updatedAt: DateTime.now()),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
                empty: const SliverToBoxAdapter(child: GtText(_empty)),
              ),
            ],
          ),
        ),
      );

      var sliver = tester.renderObject<RenderSliverPadding>(
        find.byType(GtAsyncStateSliver),
      );
      expect(
        sliver.resolvedPadding,
        const EdgeInsets.symmetric(horizontal: 40),
      );

      await tester.pumpWidget(
        _AsyncStateTestApp(
          child: CustomScrollView(
            slivers: [
              GtAsyncStateSliver(
                task: FutureListData<_Item>(updatedAt: DateTime.now()),
                padding: EdgeInsets.zero,
                sliver: const SliverToBoxAdapter(
                  child: GtText('data', key: _dataKey),
                ),
                empty: const SliverToBoxAdapter(child: GtText(_empty)),
              ),
            ],
          ),
        ),
      );

      sliver = tester.renderObject<RenderSliverPadding>(
        find.byType(GtAsyncStateSliver),
      );
      expect(sliver.resolvedPadding, EdgeInsets.zero);
    });
  });

  testWidgets('GtAsyncStateBody pads the data arm with the same inset', (
    tester,
  ) async {
    await tester.pumpWidget(
      _AsyncStateTestApp(
        child: GtAsyncStateBody(
          task: FutureListData<_Item>(
            data: const [item],
            updatedAt: DateTime.now(),
          ),
          emptyDescription: _empty,
          errorTitle: _errorTitle,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          builder: (context) => const GtText('data', key: _dataKey),
        ),
      ),
    );

    final padding = tester.widget<Padding>(
      find
          .ancestor(of: find.byKey(_dataKey), matching: find.byType(Padding))
          .first,
    );
    expect(padding.padding, const EdgeInsets.symmetric(horizontal: 32));
  });
}
