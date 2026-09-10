import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  group('GtStatusTracker tests', () {
    Widget buildTestWidget(Widget child) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(home: Scaffold(body: child)),
      );
    }

    testWidgets('renders all steps with labels and subtitles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtStatusTracker(
            steps: const [
              GtStatusStepData(
                label: 'Processed',
                state: GtStatusStepState.success,
                subtitle: '10th Sept, 2025',
              ),
              GtStatusStepData(
                label: 'Sending',
                state: GtStatusStepState.active,
                subtitle: 'In progress',
              ),
              GtStatusStepData(
                label: 'Delivered',
                state: GtStatusStepState.pending,
              ),
            ],
          ),
        ),
      );

      expect(find.text('PROCESSED'), findsOneWidget);
      expect(find.text('SENDING'), findsOneWidget);
      expect(find.text('DELIVERED'), findsOneWidget);
      expect(find.text('10th Sept, 2025'), findsOneWidget);
      expect(find.text('In progress'), findsOneWidget);
    });

    testWidgets('renders GtSpinner for active step state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtStatusTracker(
            steps: const [
              GtStatusStepData(
                label: 'Processing',
                state: GtStatusStepState.active,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(GtSpinner), findsOneWidget);
      expect(find.text('PROCESSING'), findsOneWidget);
    });

    testWidgets('resolves terminal success checkmark automatically', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtStatusTracker(
            steps: const [
              GtStatusStepData(
                label: 'Processed',
                state: GtStatusStepState.success,
              ),
              GtStatusStepData(label: 'Sent', state: GtStatusStepState.success),
              GtStatusStepData(
                label: 'Delivered',
                state: GtStatusStepState.pending,
              ),
            ],
          ),
        ),
      );

      final stepFinders = find.byType(GtStatusTrackerStep);
      expect(stepFinders, findsNWidgets(3));

      final thirdStep = tester.widget<GtStatusTrackerStep>(stepFinders.at(2));
      expect(thirdStep.showAsTerminalSuccess, isTrue);

      final secondStep = tester.widget<GtStatusTrackerStep>(stepFinders.at(1));
      expect(secondStep.showAsTerminalSuccess, isFalse);
    });
  });

  group('GtStatusTracker compact variant', () {
    const timestamp = 'Sep 10, 2025 11:03 AM';

    Widget buildTestWidget(List<GtStatusStepData> steps) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: GtStatusTracker(
              steps: steps,
              variant: GtStatusTrackerVariant.compact,
            ),
          ),
        ),
      );
    }

    GtStatusStepData step(GtStatusStepState state, {String? subtitle}) {
      return GtStatusStepData(
        label: state.name,
        state: state,
        subtitle: subtitle,
      );
    }

    List<Color?> connectorColors(WidgetTester tester) {
      return tester
          .widgetList<GtStatusTrackerCompactStep>(
            find.byType(GtStatusTrackerCompactStep),
          )
          .map((it) => it.connectorColor)
          .toList();
    }

    GtPalette paletteOf(WidgetTester tester) {
      return tester.element(find.byType(GtStatusTracker)).palette;
    }

    testWidgets('renders labels as supplied with trailing timestamps', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const [
          GtStatusStepData(
            label: 'Processed',
            state: GtStatusStepState.success,
            subtitle: timestamp,
          ),
          GtStatusStepData(
            label: 'Sending',
            state: GtStatusStepState.active,
            subtitle: timestamp,
          ),
          GtStatusStepData(
            label: 'Delivered',
            state: GtStatusStepState.pending,
          ),
        ]),
      );

      expect(find.byType(GtStatusTrackerCompactStep), findsNWidgets(3));
      expect(find.byType(GtStatusTrackerStep), findsNothing);
      expect(find.text('Processed'), findsOneWidget);
      expect(find.text('PROCESSED'), findsNothing);
      expect(find.text('Delivered'), findsOneWidget);
      // The pending step carries no subtitle, so only two timestamps render.
      expect(find.text(timestamp), findsNWidgets(2));
      expect(find.byType(GtSpinner), findsOneWidget);
    });

    testWidgets('keeps a filled dot rather than a terminal checkmark', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget([
          step(GtStatusStepState.success),
          step(GtStatusStepState.success),
          step(GtStatusStepState.success),
        ]),
      );

      expect(find.byIcon(GtIcons.checkSolid), findsNothing);
    });

    testWidgets('draws no connector beneath the final step', (tester) async {
      await tester.pumpWidget(
        buildTestWidget([
          step(GtStatusStepState.success),
          step(GtStatusStepState.success),
        ]),
      );

      expect(connectorColors(tester).last, isNull);
    });

    testWidgets('greys the track while a middle step is in flight', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget([
          step(GtStatusStepState.success),
          step(GtStatusStepState.active),
          step(GtStatusStepState.pending),
        ]),
      );

      final grey = paletteOf(tester).stroke.sub;
      expect(connectorColors(tester), [grey, grey, null]);
    });

    testWidgets('greys the track after a failure short of the last step', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget([
          step(GtStatusStepState.success),
          step(GtStatusStepState.failed),
          step(GtStatusStepState.reversed),
        ]),
      );

      final grey = paletteOf(tester).stroke.sub;
      expect(connectorColors(tester), [grey, grey, null]);
    });

    testWidgets('greens the track once the last step is reached', (
      tester,
    ) async {
      final outcomes = [
        GtStatusStepState.active,
        GtStatusStepState.success,
        GtStatusStepState.failed,
        GtStatusStepState.reversed,
      ];

      for (final outcome in outcomes) {
        await tester.pumpWidget(
          buildTestWidget([
            step(GtStatusStepState.success),
            step(GtStatusStepState.success),
            step(outcome),
          ]),
        );

        final green = paletteOf(tester).success.base;
        expect(connectorColors(tester), [
          green,
          green,
          null,
        ], reason: 'expected a green track ending in ${outcome.name}');
      }
    });
  });
}
