import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  final navigatorKey = GlobalKey<NavigatorState>();

  Widget buildTestWidget() {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(body: GtText("root")),
      ),
    );
  }

  /// Mounts [scaffold] as a pushed route, so the back chevron has something to
  /// pop back to and the implied-leading path is live.
  Future<void> pumpStep(WidgetTester tester, GtStepScaffold scaffold) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => scaffold),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('GtStepScaffold', () {
    testWidgets('renders the title, subtitle and body', (tester) async {
      await pumpStep(
        tester,
        const GtStepScaffold(
          title: 'What is your BVN?',
          subtitle: 'We use it to confirm your identity.',
          body: GtText('body'),
        ),
      );

      expect(find.text('WHAT IS YOUR BVN?'), findsOneWidget);
      expect(find.text('We use it to confirm your identity.'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('renders no ring and no pill by default', (tester) async {
      await pumpStep(
        tester,
        const GtStepScaffold(title: 'Step', body: GtText('body')),
      );

      expect(find.byKey(const Key('step-progress')), findsNothing);
      expect(find.byKey(const Key('step-help')), findsNothing);
    });

    testWidgets('renders the ring alone when only progress is given', (
      tester,
    ) async {
      await pumpStep(
        tester,
        const GtStepScaffold(title: 'Step', progress: .4, body: GtText('body')),
      );

      expect(find.byKey(const Key('step-progress')), findsOneWidget);
      expect(find.byKey(const Key('step-help')), findsNothing);
    });

    testWidgets('draws the ring anti-clockwise with a square cap', (
      tester,
    ) async {
      await pumpStep(
        tester,
        const GtStepScaffold(title: 'Step', progress: .4, body: GtText('body')),
      );

      final spinner = tester.widget<GtSpinner>(
        find.byKey(const Key('step-progress')),
      );

      expect(spinner.value, .4);
      expect(spinner.strokeCap, StrokeCap.square);
      expect(spinner.clockwise, isFalse);
    });

    testWidgets('renders the pill alone when only onHelp is given', (
      tester,
    ) async {
      await pumpStep(
        tester,
        GtStepScaffold(
          title: 'Step',
          onHelp: () {},
          body: const GtText('body'),
        ),
      );

      expect(find.byKey(const Key('step-help')), findsOneWidget);
      expect(find.byKey(const Key('step-progress')), findsNothing);
    });

    testWidgets('places the ring before the pill when both are given', (
      tester,
    ) async {
      await pumpStep(
        tester,
        GtStepScaffold(
          title: 'Step',
          progress: .6,
          onHelp: () {},
          body: const GtText('body'),
        ),
      );

      final ring = tester.getTopLeft(find.byKey(const Key('step-progress')));
      final pill = tester.getTopLeft(find.byKey(const Key('step-help')));

      expect(ring.dx, lessThan(pill.dx));
    });

    testWidgets('invokes onHelp when the pill is pressed', (tester) async {
      var pressed = false;

      await pumpStep(
        tester,
        GtStepScaffold(
          title: 'Step',
          onHelp: () => pressed = true,
          body: const GtText('body'),
        ),
      );

      await tester.tap(find.byKey(const Key('step-help')));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('pins the bottom action in a bottom nav bar', (tester) async {
      await pumpStep(
        tester,
        GtStepScaffold(
          title: 'Step',
          bottomAction: GtRaisedButton(
            key: const Key('step-action'),
            text: 'Continue',
            onPressed: () {},
          ),
          body: const GtText('body'),
        ),
      );

      expect(find.byKey(const Key('step-bottom-bar')), findsOneWidget);
      expect(find.byKey(const Key('step-action')), findsOneWidget);
    });

    testWidgets('renders no bottom bar without a bottom action', (
      tester,
    ) async {
      await pumpStep(
        tester,
        const GtStepScaffold(title: 'Step', body: GtText('body')),
      );

      expect(find.byKey(const Key('step-bottom-bar')), findsNothing);
    });

    testWidgets('renders the back chevron on a poppable route', (tester) async {
      await pumpStep(
        tester,
        const GtStepScaffold(title: 'Step', body: GtText('body')),
      );

      expect(find.byKey(const Key('step-back-button')), findsOneWidget);
    });

    testWidgets('removes the back chevron rather than implying one', (
      tester,
    ) async {
      await pumpStep(
        tester,
        const GtStepScaffold(
          title: 'Step',
          showBackButton: false,
          body: GtText('body'),
        ),
      );

      expect(find.byType(GtBackButton), findsNothing);
    });

    testWidgets('rejects a progress value outside 0..1', (tester) async {
      expect(
        () => GtStepScaffold(
          title: 'Step',
          progress: 40,
          body: const GtText('body'),
        ),
        throwsAssertionError,
      );
    });
  });
}
