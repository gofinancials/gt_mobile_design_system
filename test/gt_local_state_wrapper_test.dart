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
}
