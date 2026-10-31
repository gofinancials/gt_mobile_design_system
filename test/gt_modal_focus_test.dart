import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// A form with one text field and both modal mixins, exposing its context to
/// the test body so a modal can be opened without a DS button's own focus
/// reset.
class _Host extends StatefulWidget {
  final FocusNode field;
  final void Function(_HostState host) onReady;

  const _Host({required this.field, required this.onReady});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host>
    with GtBottomModalMixin, GtBottomSheetMixin {
  @override
  Widget build(BuildContext context) {
    widget.onReady(this);
    return TextField(focusNode: widget.field);
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  const bothPlatforms = TargetPlatformVariant({
    TargetPlatform.android,
    TargetPlatform.iOS,
  });

  late FocusNode field;

  setUp(() => field = FocusNode());
  tearDown(() => field.dispose());

  /// Mounts the form on a phone-sized view with its field focused and the
  /// keyboard up.
  Future<_HostState> pumpFocusedHost(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late _HostState host;
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: _Host(field: field, onReady: (value) => host = value),
          ),
        ),
      ),
    );
    await tester.showKeyboard(find.byType(TextField));
    expect(field.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    return host;
  }

  /// Pumps a bounded number of frames; a loading task modal never settles.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (int index = 0; index < 6; index++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  void expectKeyboardDown(WidgetTester tester) {
    expect(field.hasFocus, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
  }

  group('Modals opened over a focused field', () {
    testWidgets('a sheet drops the focus and does not hand it back', (
      tester,
    ) async {
      final host = await pumpFocusedHost(tester);

      unawaited(host.showSheet<void>(host.context, child: const Text('sheet')));
      await tester.pumpAndSettle();
      expect(find.text('sheet'), findsOneWidget);
      expectKeyboardDown(tester);

      Navigator.of(host.context, rootNavigator: true).pop();
      await tester.pumpAndSettle();
      expect(find.text('sheet'), findsNothing);
      expectKeyboardDown(tester);
    }, variant: bothPlatforms);

    testWidgets(
      'a draggable sheet drops the focus and does not hand it back',
      (tester) async {
        final host = await pumpFocusedHost(tester);

        unawaited(
          host.showDraggableSheet<void>(
            host.context,
            builder: (controller) {
              return ListView(
                controller: controller,
                children: const [Text('sheet')],
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('sheet'), findsOneWidget);
        expectKeyboardDown(tester);

        Navigator.of(host.context, rootNavigator: true).pop();
        await tester.pumpAndSettle();
        expect(find.text('sheet'), findsNothing);
        expectKeyboardDown(tester);
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'a second sheet opened from the screen keeps the focus on top',
      (tester) async {
        final host = await pumpFocusedHost(tester);

        // Two sheets in a row from the same screen, as a transfer summary
        // does: the second is opened from a context beneath the first.
        unawaited(host.showSheet<void>(host.context, child: const Text('one')));
        await tester.pumpAndSettle();
        unawaited(host.showSheet<void>(host.context, child: const Text('two')));
        await tester.pumpAndSettle();
        expectKeyboardDown(tester);

        Route<dynamic>? focusedRoute() {
          final focus = FocusManager.instance.primaryFocus?.context;
          return focus == null ? null : ModalRoute.of(focus);
        }

        final screen = ModalRoute.of(host.context);
        final two = ModalRoute.of(tester.element(find.text('two')));
        expect(focusedRoute(), isNot(screen));
        expect(focusedRoute(), two);

        Navigator.of(host.context, rootNavigator: true).pop();
        await tester.pumpAndSettle();
        final one = ModalRoute.of(tester.element(find.text('one')));
        expect(focusedRoute(), one);
        expectKeyboardDown(tester);
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'a task modal drops the focus and does not hand it back',
      (tester) async {
        final controller = GtBottomModalController<String>(
          data: const GtBottomModalData(title: 'Checking'),
          onCompleteDelay: Duration.zero,
          keepOpenOnFailure: true,
        );
        addTearDown(controller.dispose);

        final host = await pumpFocusedHost(tester);

        unawaited(
          host.showTaskBottomModal(host.context, controller: controller),
        );
        await pumpFrames(tester);
        expect(find.text('CHECKING'), findsOneWidget);
        expectKeyboardDown(tester);

        // A failure held open stays readable, with no keyboard over it.
        controller.complete(
          TaskFailure<String>(error: const TaskError(message: 'Declined')),
        );
        await pumpFrames(tester);
        expect(find.text('CHECKING'), findsOneWidget);
        expectKeyboardDown(tester);

        unawaited(controller.dismiss());
        await pumpFrames(tester);
        expect(find.text('CHECKING'), findsNothing);
        expectKeyboardDown(tester);
      },
      variant: bothPlatforms,
    );
  });
}
