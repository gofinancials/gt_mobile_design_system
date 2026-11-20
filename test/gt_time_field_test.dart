import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const t1417 = TimeOfDay(hour: 14, minute: 17);

  /// Mounts [child] in a themed app with room for the wheel sheet.
  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder wheelFinder(GtTimeWheelField field) {
    return find.byKey(ValueKey('gt_time_wheel_scroll_${field.name}'));
  }

  GtWheelScroll<int> wheel(WidgetTester tester, GtTimeWheelField field) {
    return tester.widget<GtWheelScroll<int>>(wheelFinder(field));
  }

  List<String> labels(WidgetTester tester, GtTimeWheelField field) {
    return wheel(tester, field).items.map((item) => item.label).toList();
  }

  /// The label of [field]'s selected item.
  String shown(WidgetTester tester, GtTimeWheelField field) {
    final scroll = wheel(tester, field);
    return scroll.items.firstWhere((item) => item.data == scroll.value).label;
  }

  Future<void> scrollByRows(
    WidgetTester tester,
    GtTimeWheelField field,
    int rows,
  ) async {
    final list = find.descendant(
      of: wheelFinder(field),
      matching: find.byType(ListWheelScrollView),
    );
    final extent = tester.widget<ListWheelScrollView>(list).itemExtent;
    final sign = rows.sign;
    final gesture = await tester.startGesture(tester.getCenter(list));
    await gesture.moveBy(Offset(0, -sign * kDragSlopDefault));
    await gesture.moveBy(
      Offset(0, -(extent * rows - sign * kDragSlopDefault / 2)),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  String fieldText(WidgetTester tester) {
    final text = find.descendant(
      of: find.byType(GtTimeField),
      matching: find.byType(EditableText),
    );
    return tester.widget<EditableText>(text).controller.text;
  }

  group('GtTimeValue', () {
    test('converts to and from seconds, TimeOfDay and DateTime', () {
      const time = GtTimeValue(hour: 14, minute: 17, second: 30);
      expect(time.secondsOfDay, 14 * 3600 + 17 * 60 + 30);
      expect(GtTimeValue.fromSecondsOfDay(time.secondsOfDay), time);
      expect(time.timeOfDay, t1417);
      expect(GtTimeValue.fromTimeOfDay(t1417).second, 0);
      expect(
        GtTimeValue.fromDateTime(DateTime(2026, 11, 20, 14, 17, 30)),
        time,
      );
      expect(
        time.onDate(DateTime(2026, 11, 20)),
        DateTime(2026, 11, 20, 14, 17, 30),
      );
      expect(time.isAfter(GtTimeValue.fromTimeOfDay(t1417)), isTrue);
    });

    test('formats with a date pattern', () {
      const time = GtTimeValue(hour: 14, minute: 7, second: 5);
      expect(time.format('HH:mm'), '14:07');
      expect(time.format('HH:mm:ss'), '14:07:05');
      expect(time.format('hh:mm a'), '02:07 PM');
    });
  });

  group('GtTimePattern', () {
    test('asks for the wheels its symbols need, in their order', () {
      expect(GtTimePattern.parse('HH:mm').fields, [
        GtTimeWheelField.hour,
        GtTimeWheelField.minute,
      ]);
      final seconds = GtTimePattern.parse('HH:mm:ss');
      expect(seconds.hasSeconds, isTrue);
      expect(seconds.fields.last, GtTimeWheelField.second);

      final twelve = GtTimePattern.parse('hh:mm a');
      expect(twelve.is12Hour, isTrue);
      expect(twelve.hourToken, 'hh');
      expect(twelve.fields.last, GtTimeWheelField.period);

      expect(
        GtTimePattern.parse('a h:mm').fields.first,
        GtTimeWheelField.period,
      );
    });

    test('ignores quoted text', () {
      final pattern = GtTimePattern.parse("HH'h'mm 'as'");
      expect(pattern.is12Hour, isFalse);
      expect(pattern.hasSeconds, isFalse);
      expect(pattern.hourToken, 'HH');
    });

    test('a 12-hour pattern without a marker asserts', () {
      expect(() => GtTimePattern.parse('hh:mm'), throwsAssertionError);
    });
  });

  group('GtTimeController', () {
    test('reads and writes a TimeOfDay', () {
      final controller = GtTimeController(time: t1417);
      addTearDown(controller.dispose);
      expect(controller.time, t1417);
      expect(controller.value, const GtTimeValue(hour: 14, minute: 17));

      controller.time = null;
      expect(controller.value, isNull);
    });

    test('moving a limit past the picked time drops it', () {
      final controller = GtTimeController(time: t1417);
      addTearDown(controller.dispose);
      int notified = 0;
      controller.addListener(() => notified++);

      controller.earliest = const TimeOfDay(hour: 12, minute: 0);
      expect(controller.time, t1417);
      expect(notified, 1);

      controller.earliest = const TimeOfDay(hour: 15, minute: 0);
      expect(controller.value, isNull);
      expect(notified, 2);
    });

    test('the latest time stops at its first second', () {
      final controller = GtTimeController(
        latest: const TimeOfDay(hour: 17, minute: 0),
      );
      addTearDown(controller.dispose);
      expect(controller.isAllowed(const GtTimeValue(hour: 17)), isTrue);
      expect(
        controller.isAllowed(const GtTimeValue(hour: 17, second: 30)),
        isFalse,
      );
    });
  });

  group('GtTimeWheelScroll', () {
    testWidgets('the pattern decides the wheels', (tester) async {
      final controller = GtTimeController(time: t1417);
      addTearDown(controller.dispose);

      await pump(tester, GtTimeWheelScroll(controller: controller));
      expect(find.byType(GtWheelScroll<int>), findsNWidgets(2));
      expect(labels(tester, .hour), hasLength(24));
      expect(labels(tester, .minute), hasLength(60));
      expect(shown(tester, .hour), '14');
      expect(shown(tester, .minute), '17');

      await pump(
        tester,
        GtTimeWheelScroll(controller: controller, pattern: 'HH:mm:ss'),
      );
      expect(find.byType(GtWheelScroll<int>), findsNWidgets(3));
      expect(labels(tester, .second), hasLength(60));

      await pump(
        tester,
        GtTimeWheelScroll(controller: controller, pattern: 'hh:mm a'),
      );
      expect(find.byType(GtWheelScroll<int>), findsNWidgets(3));
      expect(labels(tester, .period), ['AM', 'PM']);
      expect(shown(tester, .period), 'PM');
      // The afternoon's hours, in 12-hour form.
      expect(labels(tester, .hour).first, '12');
      expect(labels(tester, .hour).last, '11');
      expect(shown(tester, .hour), '02');
      expect(wheel(tester, .period).semanticsLabel, 'AM/PM');
    });

    testWidgets('the minute step thins the minute wheel', (tester) async {
      final controller = GtTimeController(time: t1417);
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtTimeWheelScroll(controller: controller, minuteStep: 15),
      );
      expect(labels(tester, .minute), ['00', '15', '30', '45']);
      // An off-step time shows on the step before it.
      expect(shown(tester, .minute), '15');
    });

    testWidgets('only times within the limits are offered', (tester) async {
      final controller = GtTimeController(
        earliest: const TimeOfDay(hour: 14, minute: 50),
        latest: const TimeOfDay(hour: 16, minute: 20),
        time: const TimeOfDay(hour: 15, minute: 30),
      );
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtTimeWheelScroll(controller: controller, minuteStep: 15),
      );
      // 14:50 has no quarter hour left in its hour, so 14 is not offered.
      expect(labels(tester, .hour), ['15', '16']);
      expect(labels(tester, .minute), ['00', '15', '30', '45']);

      controller.time = const TimeOfDay(hour: 16, minute: 0);
      await tester.pumpAndSettle();
      expect(labels(tester, .minute), ['00', '15']);
    });

    testWidgets('scrolling picks and reports a time, pulled back within the '
        'limits', (tester) async {
      final controller = GtTimeController(
        latest: const TimeOfDay(hour: 15, minute: 10),
        time: const TimeOfDay(hour: 14, minute: 45),
      );
      addTearDown(controller.dispose);
      final changes = <GtTimeValue>[];

      await pump(
        tester,
        GtTimeWheelScroll(
          controller: controller,
          minuteStep: 5,
          onChanged: changes.add,
        ),
      );

      await scrollByRows(tester, .minute, 1);
      expect(controller.time, const TimeOfDay(hour: 14, minute: 50));

      await scrollByRows(tester, .hour, 1);
      // 15:50 is past the latest time, so the pick stops at 15:10.
      expect(controller.time, const TimeOfDay(hour: 15, minute: 10));
      expect(changes.last, const GtTimeValue(hour: 15, minute: 10));
      expect(labels(tester, .minute), ['00', '05', '10']);
    });

    testWidgets('scrolling back into the earliest hour stops at the earliest '
        'time', (tester) async {
      final controller = GtTimeController(
        earliest: const TimeOfDay(hour: 14, minute: 50),
        time: const TimeOfDay(hour: 15, minute: 30),
      );
      addTearDown(controller.dispose);

      await pump(tester, GtTimeWheelScroll(controller: controller));
      expect(labels(tester, .hour).first, '14');

      await scrollByRows(tester, .hour, -1);
      expect(controller.time, const TimeOfDay(hour: 14, minute: 50));
      expect(labels(tester, .minute), [
        for (int minute = 50; minute < 60; minute++) '$minute',
      ]);
    });

    testWidgets('switching AM to PM keeps the hour on the clock face', (
      tester,
    ) async {
      final controller = GtTimeController(
        time: const TimeOfDay(hour: 9, minute: 30),
      );
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtTimeWheelScroll(controller: controller, pattern: 'hh:mm a'),
      );
      await scrollByRows(tester, .period, 1);
      expect(controller.time, const TimeOfDay(hour: 21, minute: 30));
    });

    testWidgets('an empty controller is picked only when asked', (
      tester,
    ) async {
      final controller = GtTimeController(
        earliest: const TimeOfDay(hour: 10, minute: 0),
        latest: const TimeOfDay(hour: 10, minute: 0),
      );
      addTearDown(controller.dispose);

      await pump(tester, GtTimeWheelScroll(controller: controller));
      expect(controller.value, isNull);
      expect(shown(tester, .hour), '10');

      await pump(
        tester,
        GtTimeWheelScroll(
          key: const ValueKey('selecting'),
          controller: controller,
          selectInitialTime: true,
        ),
      );
      expect(controller.time, const TimeOfDay(hour: 10, minute: 0));
    });

    testWidgets('the wheels are disabled when no step fits the limits', (
      tester,
    ) async {
      final controller = GtTimeController(
        earliest: const TimeOfDay(hour: 23, minute: 50),
      );
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtTimeWheelScroll(
          controller: controller,
          minuteStep: 15,
          selectInitialTime: true,
        ),
      );
      expect(wheel(tester, .hour).isEnabled, isFalse);
      expect(controller.value, isNull);
    });
  });

  group('GtTimeField', () {
    testWidgets('opening the sheet moves an off-step time onto the step the '
        'wheels show', (tester) async {
      final controller = GtTimeController(time: t1417);
      addTearDown(controller.dispose);

      await pump(tester, GtTimeField(controller: controller, minuteStep: 15));
      expect(fieldText(tester), '14:17');

      await tester.tap(find.byType(GtTimeField));
      await tester.pumpAndSettle();
      expect(controller.time, const TimeOfDay(hour: 14, minute: 15));
      expect(fieldText(tester), '14:15');
    });

    testWidgets('opening the sheet picks the shown time and the field shows '
        'it in its format', (tester) async {
      final controller = GtTimeController(
        earliest: const TimeOfDay(hour: 14, minute: 17),
        latest: const TimeOfDay(hour: 14, minute: 17),
      );
      addTearDown(controller.dispose);
      final changes = <GtTimeValue?>[];

      await pump(
        tester,
        GtTimeField(
          controller: controller,
          label: 'Schedule time',
          timeFormat: 'hh:mm a',
          onChanged: changes.add,
        ),
      );
      expect(fieldText(tester), isEmpty);

      await tester.tap(find.byType(GtTimeField));
      await tester.pumpAndSettle();
      expect(find.byType(GtTimeWheelScroll), findsOneWidget);
      expect(find.text('Schedule time'), findsWidgets);

      await tester.tap(find.byType(GtCancelButton));
      await tester.pumpAndSettle();
      expect(fieldText(tester), '02:17 PM');
      expect(changes, [const GtTimeValue(hour: 14, minute: 17)]);
    });

    testWidgets('validates the picked time', (tester) async {
      final formKey = GlobalKey<FormState>();
      await pump(
        tester,
        Form(
          key: formKey,
          child: GtTimeField(
            label: 'Schedule time',
            validator: (time) => time == null ? 'Pick a time' : null,
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Pick a time'), findsOneWidget);
    });

    testWidgets('a disabled field opens no sheet', (tester) async {
      await pump(tester, const GtTimeField(isEnabled: false));
      await tester.tap(find.byType(GtTimeField));
      await tester.pumpAndSettle();
      expect(find.byType(GtTimeWheelScroll), findsNothing);
    });

    testWidgets('a time set on the controller shows in the field', (
      tester,
    ) async {
      final controller = GtTimeController();
      addTearDown(controller.dispose);
      await pump(tester, GtTimeField(controller: controller));

      controller.time = t1417;
      await tester.pump();
      expect(fieldText(tester), '14:17');
    });
  });
}
