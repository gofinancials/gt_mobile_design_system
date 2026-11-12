import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  /// Mounts [field] in a themed app with room for the calendar sheet.
  Future<void> pumpField(WidgetTester tester, Widget field) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(home: Scaffold(body: field)),
      ),
    );
  }

  /// Opens the calendar sheet, taps each of [days] and waits for it to close.
  Future<void> pickDays(WidgetTester tester, List<String> days) async {
    await tester.tap(find.byType(GtDateField));
    await tester.pumpAndSettle();
    for (final day in days) {
      await tester.tap(find.text(day));
      await tester.pump();
    }
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  GtCalendarController marchController() {
    return GtCalendarController(GtCalendarValue(day: DateTime(2026, 3, 1)));
  }

  group('GtDateField.onChanged', () {
    testWidgets('reports the picked day', (tester) async {
      final values = <GtCalendarValue?>[];
      await pumpField(
        tester,
        GtDateField(controller: marchController(), onChanged: values.add),
      );

      await pickDays(tester, ["10"]);

      expect(values, hasLength(1));
      expect(values.single?.day, DateTime.utc(2026, 3, 10));
    });

    testWidgets('reports the picked range', (tester) async {
      final values = <GtCalendarValue?>[];
      await pumpField(
        tester,
        GtDateField.range(controller: marchController(), onChanged: values.add),
      );

      await pickDays(tester, ["10", "15"]);

      expect(values.map((it) => it?.range), [
        DateTimeRange(
          start: DateTime.utc(2026, 3, 10),
          end: DateTime.utc(2026, 3, 10),
        ),
        DateTimeRange(
          start: DateTime.utc(2026, 3, 10),
          end: DateTime.utc(2026, 3, 15),
        ),
      ]);
    });

    testWidgets('range field ignores a change to the day alone', (
      tester,
    ) async {
      final controller = marchController();
      final values = <GtCalendarValue?>[];
      await pumpField(
        tester,
        GtDateField.range(controller: controller, onChanged: values.add),
      );

      controller.day = DateTime(2026, 5, 1);
      expect(values, isEmpty);

      final range = DateTimeRange(
        start: DateTime(2026, 5, 1),
        end: DateTime(2026, 5, 31),
      );
      controller.range = range;
      expect(values.map((it) => it?.range), [range]);
    });

    testWidgets('stops reporting once the field is disposed', (tester) async {
      final controller = marchController();
      final values = <GtCalendarValue?>[];
      await pumpField(
        tester,
        GtDateField.range(controller: controller, onChanged: values.add),
      );
      await tester.pumpWidget(const SizedBox());

      controller.range = DateTimeRange(
        start: DateTime(2026, 5, 1),
        end: DateTime(2026, 5, 31),
      );

      expect(values, isEmpty);
      expect(tester.takeException(), isNull);
    });
  });
}
