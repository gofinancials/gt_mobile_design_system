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
}
