import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _Probe extends ChangeNotifier {
  int disposeCount = 0;

  @override
  void dispose() {
    disposeCount++;
    super.dispose();
  }
}

class _Other extends ChangeNotifier {}

/// A page of the flow, recording the notifier it was handed.
Widget _flowPage(GtSharedState<_Probe> holder, List<_Probe> seen, String name) {
  return GtLocalStateWrapper<_Probe>(
    shared: holder,
    builder: (state) {
      seen.add(state);
      return Text(name);
    },
  );
}

void main() {
  group('GtSharedState', () {
    testWidgets('makes one notifier for every holder', (tester) async {
      var created = 0;
      final holder = GtSharedState<_Probe>(() {
        created++;
        return _Probe();
      });

      final first = holder.acquire();
      final second = holder.acquire();

      expect(second, same(first));
      expect(created, 1);
      expect(holder.holders, 2);
      holder.release();
      holder.release();
      await tester.pump();
    });

    testWidgets('disposes at the end of the frame the last holder lets go', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final state = holder.acquire();

      holder.release();

      expect(state.disposeCount, 0);
      await tester.pump();
      expect(state.disposeCount, 1);
      expect(holder.current, isNull);
    });

    testWidgets('keeps the notifier when a holder takes it back in time', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final state = holder.acquire();

      holder.release();
      final again = holder.acquire();
      await tester.pump();

      expect(again, same(state));
      expect(state.disposeCount, 0);
      holder.release();
      await tester.pump();
    });

    testWidgets('makes a fresh notifier after disposing the last', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final first = holder.acquire();
      holder.release();
      await tester.pump();

      final second = holder.acquire();

      expect(second, isNot(same(first)));
      holder.release();
      await tester.pump();
    });

    test('current never makes a notifier', () {
      var created = 0;
      final holder = GtSharedState<_Probe>(() {
        created++;
        return _Probe();
      });

      expect(holder.current, isNull);
      expect(created, 0);
    });

    test('rejects a release without an acquire', () {
      final holder = GtSharedState<_Probe>(_Probe.new);

      expect(holder.release, throwsAssertionError);
    });
  });

  group('GtStateSource.shared', () {
    testWidgets('shares one notifier across the routes of a flow', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final seen = <_Probe>[];
      final navigator = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: const Text('home'),
          routes: {
            '/first': (_) => _flowPage(holder, seen, 'first'),
            '/second': (_) => _flowPage(holder, seen, 'second'),
          },
        ),
      );
      navigator.currentState!.pushNamed('/first');
      await tester.pumpAndSettle();
      navigator.currentState!.pushNamed('/second');
      await tester.pumpAndSettle();

      final state = holder.current!;
      expect(seen, everyElement(same(state)));
      expect(holder.holders, 2);

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(state.disposeCount, 0);

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(state.disposeCount, 1);
      expect(holder.current, isNull);
    });

    testWidgets('keeps the notifier across a replacement', (tester) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final seen = <_Probe>[];
      final navigator = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: const Text('home'),
          routes: {
            '/first': (_) => _flowPage(holder, seen, 'first'),
            '/second': (_) => _flowPage(holder, seen, 'second'),
          },
        ),
      );
      navigator.currentState!.pushNamed('/first');
      await tester.pumpAndSettle();
      final state = holder.current!;

      navigator.currentState!.pushReplacementNamed('/second');
      await tester.pumpAndSettle();

      expect(holder.current, same(state));
      expect(holder.holders, 1);
      expect(state.disposeCount, 0);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
    });

    testWidgets('keeps the notifier across a push that clears the stack', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      final seen = <_Probe>[];
      final navigator = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: const Text('home'),
          routes: {
            '/first': (_) => _flowPage(holder, seen, 'first'),
            '/second': (_) => _flowPage(holder, seen, 'second'),
          },
        ),
      );
      navigator.currentState!.pushNamed('/first');
      await tester.pumpAndSettle();
      final state = holder.current!;

      navigator.currentState!.pushNamedAndRemoveUntil('/second', (_) => false);
      await tester.pumpAndSettle();

      expect(holder.current, same(state));
      expect(holder.holders, 1);
      expect(state.disposeCount, 0);
    });

    testWidgets('mixes with owned sources in GtLocalStateWrapper2', (
      tester,
    ) async {
      final holder = GtSharedState<_Probe>(_Probe.new);
      late final _Other owned;

      await tester.pumpWidget(
        MaterialApp(
          home: GtLocalStateWrapper2<_Probe, _Other>(
            first: .shared(holder),
            second: .owned(() => owned = _Other()),
            builder: (first, second) => const SizedBox.shrink(),
          ),
        ),
      );
      final state = holder.current!;
      expect(holder.holders, 1);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      expect(holder.holders, 0);
      expect(state.disposeCount, 1);
      expect(() => owned.addListener(() {}), throwsFlutterError);
    });

    test('rejects shared alongside another source', () {
      expect(
        () => GtLocalStateWrapper<_Probe>(
          shared: GtSharedState(_Probe.new),
          create: _Probe.new,
          builder: (state) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });
  });
}
