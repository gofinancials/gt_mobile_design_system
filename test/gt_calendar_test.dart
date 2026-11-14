import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

DateTime _march(int day) => DateTime.utc(2026, 3, day);

DateTimeRange _range(int start, int end) {
  return DateTimeRange(start: _march(start), end: _march(end));
}

void main() {
  setUpAll(registerTestAppConfig);

  group('GtCalendarController', () {
    GtCalendarController controller([GtCalendarValue? value]) {
      final result = GtCalendarController(
        value ?? GtCalendarValue(day: _march(1)),
      );
      addTearDown(result.dispose);
      return result;
    }

    test('the first range tap marks a start and finishes nothing', () {
      final calendar = controller(GtCalendarValue(range: _range(1, 2)));

      expect(calendar.pickRangeDay(_march(10)), isNull);
      expect(calendar.pendingRangeStart, _march(10));
      expect(calendar.rangeStart, _march(10));
      expect(calendar.rangeEnd, isNull);
      expect(calendar.value.isPickingRangeEnd, isTrue);
      // The last finished range stays until the new one is finished.
      expect(calendar.range, _range(1, 2));
    });

    test('the second tap finishes the range, in order either way', () {
      final later = controller();
      later.pickRangeDay(_march(10));
      expect(later.pickRangeDay(_march(15)), _range(10, 15));
      expect(later.range, _range(10, 15));
      expect(later.pendingRangeStart, isNull);

      final earlier = controller();
      earlier.pickRangeDay(_march(10));
      expect(earlier.pickRangeDay(_march(4)), _range(4, 10));
      expect(earlier.rangeStart, _march(4));
      expect(earlier.rangeEnd, _march(10));
    });

    test('a second tap on the start day finishes a one-day range', () {
      final calendar = controller();
      calendar.pickRangeDay(_march(10));

      expect(calendar.pickRangeDay(_march(10)), _range(10, 10));
      expect(calendar.pendingRangeStart, isNull);
    });

    test('a tap after a finished range starts a new one', () {
      final calendar = controller();
      calendar.pickRangeDay(_march(10));
      calendar.pickRangeDay(_march(15));

      expect(calendar.pickRangeDay(_march(20)), isNull);
      expect(calendar.pendingRangeStart, _march(20));
      expect(calendar.range, _range(10, 15));
    });

    test('cancelRangePick drops the pending start only', () {
      final calendar = controller(GtCalendarValue(range: _range(1, 2)));
      calendar.pickRangeDay(_march(10));

      calendar.cancelRangePick();

      expect(calendar.pendingRangeStart, isNull);
      expect(calendar.range, _range(1, 2));
    });

    test('range = null clears the range and any pick in progress', () {
      final calendar = controller(GtCalendarValue(range: _range(1, 2)));
      calendar.pickRangeDay(_march(10));

      calendar.range = null;

      expect(calendar.range, isNull);
      expect(calendar.pendingRangeStart, isNull);
    });

    test('day = null clears the day and keeps the range', () {
      final calendar = controller(
        GtCalendarValue(day: _march(3), range: _range(1, 2)),
      );

      calendar.day = null;

      expect(calendar.day, isNull);
      expect(calendar.range, _range(1, 2));
    });

    test('copyWith keeps a field given null', () {
      final value = GtCalendarValue(
        day: _march(3),
        range: _range(1, 2),
        pendingRangeStart: _march(9),
      );

      expect(value.copyWith(), value);
      expect(value.copyWith(day: _march(4)).range, _range(1, 2));
    });

    test('accepts one-day limits and rejects reversed ones', () {
      expect(
        () => GtCalendarController(
          GtCalendarValue(),
          dateRange: DateTimeRange(start: _march(5), end: _march(5)),
        ).dispose(),
        returnsNormally,
      );
      expect(
        () => GtCalendarController(
          GtCalendarValue(),
          dateRange: DateTimeRange(start: DateTime(2026, 6), end: _march(1)),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    group('dateRange', () {
      test('replaces the limits and notifies', () {
        final calendar = controller();
        var notified = 0;
        calendar.addListener(() => notified++);

        calendar.dateRange = DateTimeRange(
          start: DateTime(2026, 2, 1),
          end: DateTime(2026, 4, 30),
        );

        expect(calendar.firstDay, DateTime(2026, 2, 1));
        expect(calendar.lastDay, DateTime(2026, 4, 30));
        expect(calendar.day, _march(1));
        expect(notified, 1);
      });

      test('drops what falls outside the new limits', () {
        final calendar = controller(
          GtCalendarValue(day: _march(25), range: _range(18, 22)),
        );
        calendar.pickRangeDay(_march(26));

        calendar.dateRange = DateTimeRange(
          start: DateTime(2026, 3, 5),
          end: DateTime(2026, 3, 20),
        );

        expect(calendar.day, isNull);
        expect(calendar.range, isNull, reason: 'it ends after the limits');
        expect(calendar.pendingRangeStart, isNull);
      });

      test('keeps what lies inside, compared by calendar date', () {
        final calendar = controller(
          GtCalendarValue(day: _march(20), range: _range(5, 20)),
        );

        // Local limits against the calendar's UTC days: the 20th is the
        // last allowed day whatever the time of day either is given at.
        calendar.dateRange = DateTimeRange(
          start: DateTime(2026, 3, 5, 9),
          end: DateTime(2026, 3, 20, 8),
        );

        expect(calendar.day, _march(20));
        expect(calendar.range, _range(5, 20));
      });

      test('null restores the default span', () {
        final calendar = controller();
        calendar.dateRange = DateTimeRange(
          start: DateTime(2026, 3, 5),
          end: DateTime(2026, 3, 20),
        );

        calendar.dateRange = null;

        expect(calendar.dateRange, isNull);
        expect(calendar.firstDay.year, lessThan(2000));
        expect(calendar.lastDay.year, greaterThan(2100));
      });
    });
  });

  group('GtCalendar', () {
    Future<void> pump(WidgetTester tester, Widget child) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: child)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    GtCalendarCell cell(WidgetTester tester, String day) {
      return tester.widget<GtCalendarCell>(
        find.byWidgetPredicate(
          (widget) => widget is GtCalendarCell && widget.day == day,
        ),
      );
    }

    GtCalendarController march({DateTimeRange? dateRange}) {
      final controller = GtCalendarController(
        GtCalendarValue(day: _march(1)),
        dateRange: dateRange,
      );
      addTearDown(controller.dispose);
      return controller;
    }

    testWidgets('a range finishes on the second tap, and only then is '
        'reported', (tester) async {
      final controller = march();
      final ranges = <DateTimeRange>[];
      await pump(
        tester,
        GtCalendar(
          controller: controller,
          selectionMode: .range,
          onSelectRange: ranges.add,
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(ranges, isEmpty);
      expect(controller.pendingRangeStart, _march(10));
      expect(controller.range, isNull);

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(ranges, [_range(10, 15)]);
      expect(controller.range, _range(10, 15));
    });

    testWidgets('a second tap on the start day finishes a one-day range', (
      tester,
    ) async {
      final controller = march();
      final ranges = <DateTimeRange>[];
      await pump(
        tester,
        GtCalendar(
          controller: controller,
          selectionMode: .range,
          onSelectRange: ranges.add,
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(ranges, [_range(10, 10)]);
    });

    testWidgets('a lone start and a one-day range are fully rounded; a longer '
        'range rounds its outer corners', (tester) async {
      final controller = march();
      await pump(
        tester,
        GtCalendar(controller: controller, selectionMode: .range),
      );
      final context = tester.element(find.byType(GtCalendar));
      final primary = context.palette.primary.base;
      final full = context.borderRadiusMd;

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(cell(tester, '10').borderRadius, full);
      expect(cell(tester, '10').bgColor, primary);

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(
        cell(tester, '10').borderRadius,
        BorderRadius.horizontal(left: context.radiusMd),
      );
      expect(
        cell(tester, '15').borderRadius,
        BorderRadius.horizontal(right: context.radiusMd),
      );
      expect(cell(tester, '15').bgColor, primary);
      expect(cell(tester, '12').bgColor, Colors.transparent);

      controller.range = _range(20, 20);
      await tester.pump();
      expect(cell(tester, '20').borderRadius, full);
    });

    testWidgets('days outside the limits are drawn disabled and ignore taps', (
      tester,
    ) async {
      final controller = march(
        dateRange: DateTimeRange(
          start: DateTime(2026, 3, 8),
          end: DateTime(2026, 3, 20),
        ),
      );
      final days = <DateTime>[];
      await pump(
        tester,
        GtCalendar(controller: controller, onSelectDay: days.add),
      );
      final palette = tester.element(find.byType(GtCalendar)).palette;

      // Days that appear once in March's grid, either side of the limits.
      expect(cell(tester, '7').textColor, palette.text.disabled);
      expect(cell(tester, '21').textColor, palette.text.disabled);
      expect(cell(tester, '12').textColor, isNot(palette.text.disabled));

      await tester.tap(find.text('21'));
      await tester.pump();
      expect(days, isEmpty);
    });

    testWidgets('new limits move the calendar to a month inside them', (
      tester,
    ) async {
      final controller = march();
      await pump(tester, GtCalendar(controller: controller));

      controller.dateRange = DateTimeRange(
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 30),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('June 2026'), findsOneWidget);
    });

    testWidgets('limits that end before today still build', (tester) async {
      final controller = GtCalendarController(
        GtCalendarValue(),
        dateRange: DateTimeRange(
          start: DateTime(2019, 1, 1),
          end: DateTime(2020, 1, 31),
        ),
      );
      addTearDown(controller.dispose);

      await pump(tester, GtCalendar(controller: controller));

      expect(tester.takeException(), isNull);
      expect(find.text('January 2020'), findsOneWidget);
    });
  });

  group('GtCalendarModal range ends', () {
    Future<GtCalendarController> pumpModal(
      WidgetTester tester, {
      String? startLabel = 'Start',
      String? endLabel = 'End',
    }) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final controller = GtCalendarController(GtCalendarValue(day: _march(1)));
      addTearDown(controller.dispose);
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: Scaffold(
              body: GtCalendarModal(
                scrollController,
                controller: controller,
                title: 'Custom dates',
                selectionMode: .range,
                rangeStartLabel: startLabel,
                rangeEndLabel: endLabel,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return controller;
    }

    testWidgets('outline the start, then the end, filling in as each is '
        'picked', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpModal(tester);

      expect(
        tester.getSemantics(find.bySemanticsLabel('Start, DD-MM-YYYY')),
        isSemantics(isSelected: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('End, DD-MM-YYYY')),
        isSemantics(isSelected: false),
      );

      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.bySemanticsLabel('Start, 10-03-2026')),
        isSemantics(isSelected: false),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('End, DD-MM-YYYY')),
        isSemantics(isSelected: true),
      );

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(find.text('10-03-2026'), findsOneWidget);
      expect(find.text('15-03-2026'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('are not shown without both labels', (tester) async {
      await pumpModal(tester, endLabel: null);

      expect(find.text('Start'), findsNothing);
      expect(find.text('DD-MM-YYYY'), findsNothing);
    });
  });
}
