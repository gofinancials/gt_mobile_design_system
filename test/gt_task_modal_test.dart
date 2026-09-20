import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// A host with the modal mixin, exposing its context to the test body.
class _Host extends StatefulWidget {
  final void Function(_HostState host) onReady;

  const _Host({required this.onReady});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with GtBottomModalMixin {
  @override
  Widget build(BuildContext context) {
    widget.onReady(this);
    return const SizedBox.shrink();
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  const bothPlatforms = TargetPlatformVariant({
    TargetPlatform.android,
    TargetPlatform.iOS,
  });

  /// Mounts a host on a phone-sized view and hands back its state.
  Future<_HostState> pumpHost(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late _HostState host;
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(body: _Host(onReady: (value) => host = value)),
        ),
      ),
    );
    return host;
  }

  /// Pumps a bounded number of frames.
  ///
  /// A task modal animates while it is loading, so [WidgetTester.pumpAndSettle]
  /// never returns for one; every wait here is a fixed number of frames.
  Future<void> pumpFrames(
    WidgetTester tester, [
    Duration step = const Duration(milliseconds: 200),
    int frames = 6,
  ]) async {
    for (int index = 0; index < frames; index++) {
      await tester.pump(step);
    }
  }

  /// Pumps frames until [future] resolves, then returns its value.
  Future<T> pumpUntil<T>(WidgetTester tester, Future<T> future) async {
    Object? result;
    Object? error;
    var isDone = false;
    unawaited(
      future.then(
        (value) {
          result = value;
          isDone = true;
        },
        onError: (Object value) {
          error = value;
          isDone = true;
        },
      ),
    );

    for (int index = 0; index < 60 && !isDone; index++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    if (error != null) throw error!;
    return result as T;
  }

  GtBottomModalController<String> controllerFor({
    required List<TaskResponse<String>> completions,
    Duration delay = Duration.zero,
    bool keepOpenOnFailure = false,
  }) {
    return GtBottomModalController<String>(
      data: const GtBottomModalData(title: 'Processing'),
      onCompleteDelay: delay,
      keepOpenOnFailure: keepOpenOnFailure,
      onComplete: completions.add,
    );
  }

  final modal = find.text('PROCESSING');

  group('GtBottomModalController dismissal', () {
    testWidgets('takes its own modal down when the task succeeds', (
      tester,
    ) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(completions: completions);
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);
      expect(modal, findsOneWidget);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      await pumpFrames(tester);

      expect(modal, findsNothing);
      expect(completions, [TaskSuccess<String>(data: 'ok')]);
    }, variant: bothPlatforms);

    testWidgets('removes its own route, not the one pushed over it', (
      tester,
    ) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(completions: completions);
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      // A confirmation opened while the task was still running.
      unawaited(
        Navigator.of(host.context, rootNavigator: true).push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('confirmation')),
          ),
        ),
      );
      await pumpFrames(tester);
      expect(find.text('confirmation'), findsOneWidget);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      await pumpFrames(tester);

      // The modal went; the route the customer navigated to stayed.
      expect(find.text('confirmation'), findsOneWidget);
      expect(completions, hasLength(1));
    }, variant: bothPlatforms);

    testWidgets(
      'keeps a failed modal open when asked, until dismiss',
      (tester) async {
        final completions = <TaskResponse<String>>[];
        final controller = controllerFor(
          completions: completions,
          keepOpenOnFailure: true,
        );
        addTearDown(controller.dispose);

        final host = await pumpHost(tester);
        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        await pumpFrames(tester);

        controller.complete(
          TaskFailure<String>(error: const TaskError(message: 'Declined')),
        );
        await pumpFrames(tester);

        // The failure reached the caller, and the modal it was shown in stayed.
        expect(completions, hasLength(1));
        expect(modal, findsOneWidget);

        await pumpUntil(tester, controller.dismiss());
        await pumpFrames(tester);
        expect(modal, findsNothing);
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'holds a failed modal for the completion delay before closing',
      (tester) async {
        final completions = <TaskResponse<String>>[];
        final controller = controllerFor(
          completions: completions,
          delay: const Duration(seconds: 4),
        );
        addTearDown(controller.dispose);

        final host = await pumpHost(tester);
        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        await pumpFrames(tester);

        controller.complete(
          TaskFailure<String>(error: const TaskError(message: 'Declined')),
        );
        // Enough frames for a pop to have run to completion had the dismissal
        // not been held behind the delay, and still short of it: ~1.7s of a 4s
        // delay. A single pump would let a started pop hide behind its own
        // exit transition and pass either way.
        await tester.pump(const Duration(milliseconds: 500));
        await pumpFrames(tester);

        // A failure gets the same delay a success does: the error state is on
        // screen long enough to be read before the modal goes.
        expect(modal, findsOneWidget);
        expect(completions, isEmpty);

        await tester.pump(const Duration(seconds: 5));
        await pumpFrames(tester);

        expect(modal, findsNothing);
        expect(completions, hasLength(1));
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'survives a completion that lands before the first build',
      (tester) async {
        final completions = <TaskResponse<String>>[];
        final controller = controllerFor(completions: completions);
        addTearDown(controller.dispose);

        final host = await pumpHost(tester);
        // No pump between showing and completing: the route is pushed but its
        // builder has not run, so the controller has no route handle yet.
        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        controller.complete(TaskSuccess<String>(data: 'ok'));
        await pumpFrames(tester);

        expect(modal, findsNothing);
        expect(completions, hasLength(1));
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'does not stack a second modal for the same controller',
      (tester) async {
        final completions = <TaskResponse<String>>[];
        final controller = controllerFor(completions: completions);
        addTearDown(controller.dispose);

        final host = await pumpHost(tester);
        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        await pumpFrames(tester);
        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        await pumpFrames(tester);

        expect(modal, findsOneWidget);

        controller.complete(TaskSuccess<String>(data: 'ok'));
        await pumpFrames(tester);
        expect(modal, findsNothing);
      },
      variant: bothPlatforms,
    );

    testWidgets('fires the completion callback once when the customer drags '
        'the finished modal away first', (tester) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(
        completions: completions,
        delay: const Duration(seconds: 2),
      );
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      await tester.pump();
      // Inside the completion delay, with the modal no longer ignoring
      // pointers, a downward drag pops it.
      await tester.drag(find.text('PROCESSING'), const Offset(0, 300));
      await pumpFrames(tester);
      expect(modal, findsNothing);
      // The modal going early does not bring the completion forward.
      expect(completions, isEmpty);

      await tester.pump(const Duration(seconds: 3));
      await pumpFrames(tester);

      expect(completions, hasLength(1));
    }, variant: bothPlatforms);
  });

  group('GtBottomModalController lifecycle', () {
    testWidgets('a reset inside the delay cancels the pending callback', (
      tester,
    ) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(
        completions: completions,
        delay: const Duration(seconds: 2),
      );
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      await tester.pump(const Duration(milliseconds: 500));
      controller.reset();
      await tester.pump(const Duration(seconds: 3));
      await pumpFrames(tester);

      expect(completions, isEmpty);
    });

    testWidgets('a swapped completer does not strand the callback', (
      tester,
    ) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(
        completions: completions,
        delay: const Duration(seconds: 2),
      );
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      // A caller re-arming the controller mid-delay used to leave the debounced
      // callback awaiting a completer that nothing would ever complete.
      controller.copyWithin(completer: Completer<TaskResponse<String>>());
      await tester.pump(const Duration(seconds: 3));
      await pumpFrames(tester);

      expect(completions, [TaskSuccess<String>(data: 'ok')]);
    });

    testWidgets('a reset takes down a modal still on screen', (tester) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(
        completions: completions,
        delay: const Duration(seconds: 2),
      );
      addTearDown(controller.dispose);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      controller.complete(TaskSuccess<String>(data: 'ok'));
      await tester.pump(const Duration(milliseconds: 500));

      // Re-arming for a second task while the first modal is still up: the old
      // modal must go rather than end up stacked under the new one.
      controller.reset();
      await pumpFrames(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      expect(modal, findsOneWidget);
    }, variant: bothPlatforms);

    testWidgets('disposing takes down a modal still on screen', (tester) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(completions: completions);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);
      expect(modal, findsOneWidget);

      // The screen that started the task goes away while the task is still
      // running: its modal must not outlive it.
      controller.dispose();
      await pumpFrames(tester);

      expect(modal, findsNothing);
    }, variant: bothPlatforms);

    testWidgets('completing after dispose is a no-op', (tester) async {
      final completions = <TaskResponse<String>>[];
      final controller = controllerFor(completions: completions);

      final host = await pumpHost(tester);
      unawaited(host.showTaskBottomModal(host.context, controller: controller));
      await pumpFrames(tester);

      controller.dispose();
      controller.complete(TaskSuccess<String>(data: 'ok'));
      await pumpFrames(tester);

      expect(completions, isEmpty);
      expect(tester.takeException(), isNull);
    });
  });

  group('GtTaskRunner', () {
    testWidgets('reports success only after the modal is gone', (tester) async {
      final host = await pumpHost(tester);
      String? received;
      var hostWasCurrentAtCallback = false;

      final run = GtTaskRunner.run<String>(
        host.context,
        loadingTitle: 'Processing',
        completeDelay: Duration.zero,
        task: (controller) async => TaskSuccess<String>(data: 'receipt'),
        onSuccess: (data) {
          received = data;
          // The modal has left the navigator by the time the callback runs, so
          // the screen that started the task is the current route again — a
          // callback that navigates does so from there, not from over a modal.
          hostWasCurrentAtCallback =
              ModalRoute.of(host.context)?.isCurrent ?? false;
        },
      );

      final result = await pumpUntil(tester, run);
      await pumpFrames(tester);

      expect(received, 'receipt');
      expect(hostWasCurrentAtCallback, isTrue);
      expect(result, isA<TaskSuccess<String>>());
      expect(modal, findsNothing);
    }, variant: bothPlatforms);

    testWidgets(
      'reports a failure held on screen by keepOpenOnFailure',
      (tester) async {
        final host = await pumpHost(tester);
        TaskError? error;
        late final GtBottomModalController<String> held;

        final run = GtTaskRunner.run<String>(
          host.context,
          loadingTitle: 'Processing',
          completeDelay: Duration.zero,
          keepOpenOnFailure: true,
          task: (controller) async {
            // The controller handed to the task is the only handle on a modal
            // the runner keeps open.
            held = controller;
            return TaskFailure<String>(
              error: const TaskError(message: 'Incorrect PIN'),
            );
          },
          onSuccess: (_) => fail('should not succeed'),
          onError: (value) => error = value,
        );

        await pumpFrames(tester);
        // The modal is still up, holding the refusal, so the form underneath is
        // covered — but it is the form that has to mark the rejected input.
        expect(modal, findsOneWidget);
        expect(error?.message, 'Incorrect PIN');

        await pumpUntil(tester, held.dismiss());
        await pumpUntil(tester, run);
        // route.popped resolves before the exit transition clears the widget.
        await pumpFrames(tester);
        expect(modal, findsNothing);
      },
      variant: bothPlatforms,
    );

    testWidgets('reports a thrown task as a failure', (tester) async {
      final host = await pumpHost(tester);
      TaskError? error;

      final run = GtTaskRunner.run<String>(
        host.context,
        loadingTitle: 'Processing',
        completeDelay: Duration.zero,
        task: (controller) async => throw StateError('network down'),
        onSuccess: (_) => fail('should not succeed'),
        onError: (value) => error = value,
      );

      final result = await pumpUntil(tester, run);
      await pumpFrames(tester);

      expect(result, isA<TaskFailure<String>>());
      expect(error?.message, contains('network down'));
      expect(modal, findsNothing);
    }, variant: bothPlatforms);
  });
}
