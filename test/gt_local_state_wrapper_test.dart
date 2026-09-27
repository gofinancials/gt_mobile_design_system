import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:provider/provider.dart';

class _Probe extends ChangeNotifier {
  _Probe([this.onDispose]);

  final VoidCallback? onDispose;
  int disposeCount = 0;

  @override
  void dispose() {
    disposeCount++;
    onDispose?.call();
    super.dispose();
  }
}

class _Other extends _Probe {
  _Other([super.onDispose]);
}

class _Third extends _Probe {
  _Third([super.onDispose]);
}

void main() {
  group('GtLocalStateWrapper', () {
    testWidgets('disposes a notifier it created', (tester) async {
      late final _Probe created;
      var createCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper<_Probe>(
            create: () {
              createCount++;
              return created = _Probe();
            },
            builder: (state) => const SizedBox.shrink(),
          ),
        ),
      );

      expect(createCount, 1);
      expect(created.disposeCount, 0);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(created.disposeCount, 1);
    });

    testWidgets('runs create once across rebuilds', (tester) async {
      var createCount = 0;
      late StateSetter setOuterState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              setOuterState = setState;
              return GtLocalStateWrapper<_Probe>(
                create: () {
                  createCount++;
                  return _Probe();
                },
                builder: (state) => const SizedBox.shrink(),
              );
            },
          ),
        ),
      );

      setOuterState(() {});
      await tester.pump();

      expect(createCount, 1);
    });

    testWidgets('leaves a borrowed notifier alone', (tester) async {
      final borrowed = _Probe();

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper<_Probe>(
            notifier: borrowed,
            builder: (state) => const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(borrowed.disposeCount, 0);
      borrowed.dispose();
    });

    testWidgets('runs onReady before the first build', (tester) async {
      final calls = <String>[];
      final notifier = _Probe();

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper<_Probe>(
            notifier: notifier,
            onReady: (state) {
              expect(state, same(notifier));
              calls.add('onReady');
            },
            builder: (state) {
              calls.add('builder');
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(calls.first, 'onReady');
      expect(calls.where((call) => call == 'onReady'), hasLength(1));
      notifier.dispose();
    });

    testWidgets('rebuilds the subtree on notification', (tester) async {
      final notifier = _Probe();
      var builds = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper<_Probe>(
            notifier: notifier,
            builder: (state) {
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      notifier.notifyListeners();
      await tester.pump();

      expect(builds, 2);
      notifier.dispose();
    });

    test('rejects a notifier and a create together', () {
      expect(
        () => GtLocalStateWrapper<_Probe>(
          notifier: _Probe(),
          create: _Probe.new,
          builder: (state) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('GtLocalStateWrapper2', () {
    testWidgets('disposes the owned notifier and leaves the borrowed one', (
      tester,
    ) async {
      late final _Probe owned;
      final borrowed = _Other();

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .owned(() => owned = _Probe()),
            second: .borrowed(borrowed),
            builder: (first, second) => const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(owned.disposeCount, 1);
      expect(borrowed.disposeCount, 0);
      borrowed.dispose();
    });

    testWidgets('resolves the locator by default and never disposes it', (
      tester,
    ) async {
      final located = _Other();
      locator.registerSingleton<_Other>(located);
      addTearDown(() => locator.unregister<_Other>());
      final borrowed = _Probe();
      _Other? built;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .borrowed(borrowed),
            builder: (first, second) {
              built = second;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(built, same(located));
      expect(located.disposeCount, 0);
      borrowed.dispose();
      located.dispose();
    });

    testWidgets('rebuilds the subtree when either notifies', (tester) async {
      final first = _Probe();
      final second = _Other();
      var builds = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .borrowed(first),
            second: .borrowed(second),
            builder: (first, second) {
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      first.notifyListeners();
      await tester.pump();
      second.notifyListeners();
      await tester.pump();

      expect(builds, 3);
      first.dispose();
      second.dispose();
    });

    testWidgets('provides both notifiers to descendants', (tester) async {
      final first = _Probe();
      final second = _Other();
      _Probe? readFirst;
      _Other? readSecond;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .borrowed(first),
            second: .borrowed(second),
            builder: (first, second) => Builder(
              builder: (context) {
                readFirst = context.read<_Probe>();
                readSecond = context.read<_Other>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(readFirst, same(first));
      expect(readSecond, same(second));
      first.dispose();
      second.dispose();
    });

    testWidgets('runs onReady with both before the first build', (
      tester,
    ) async {
      final calls = <String>[];
      final first = _Probe();
      final second = _Other();

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .borrowed(first),
            second: .borrowed(second),
            onReady: (readyFirst, readySecond) {
              expect(readyFirst, same(first));
              expect(readySecond, same(second));
              calls.add('onReady');
            },
            builder: (first, second) {
              calls.add('builder');
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(calls, ['onReady', 'builder']);
      first.dispose();
      second.dispose();
    });

    testWidgets('disposes owned notifiers newest first', (tester) async {
      final disposed = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .owned(() => _Probe(() => disposed.add('first'))),
            second: .owned(() => _Other(() => disposed.add('second'))),
            builder: (first, second) => const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(disposed, ['second', 'first']);
    });

    test('rejects two notifiers of one type', () {
      expect(
        () => GtLocalStateWrapper2<_Probe, _Probe>(
          builder: (first, second) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('GtLocalStateWrapper3', () {
    testWidgets('provides all three and rebuilds when any notifies', (
      tester,
    ) async {
      final first = _Probe();
      final second = _Other();
      final third = _Third();
      final ready = <ChangeNotifier>[];
      var builds = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper3<_Probe, _Other, _Third>(
            first: .borrowed(first),
            second: .borrowed(second),
            third: .borrowed(third),
            onReady: (first, second, third) {
              ready.addAll([first, second, third]);
            },
            builder: (first, second, third) {
              builds++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      third.notifyListeners();
      await tester.pump();

      expect(ready, [first, second, third]);
      expect(builds, 2);
      first.dispose();
      second.dispose();
      third.dispose();
    });

    testWidgets('disposes only the owned notifiers, newest first', (
      tester,
    ) async {
      final disposed = <String>[];
      final borrowed = _Other(() => disposed.add('second'));

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper3<_Probe, _Other, _Third>(
            first: .owned(() => _Probe(() => disposed.add('first'))),
            second: .borrowed(borrowed),
            third: .owned(() => _Third(() => disposed.add('third'))),
            builder: (first, second, third) => const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(disposed, ['third', 'first']);
      borrowed.dispose();
    });

    test('rejects two notifiers of one type', () {
      expect(
        () => GtLocalStateWrapper3<_Probe, _Other, _Probe>(
          builder: (first, second, third) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });
}
