import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/semantics_matchers.dart';
import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  Widget buildTestWidget(Widget child, {ThemeData? theme}) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  Decoration bandOf(WidgetTester tester) {
    final stack = find
        .ancestor(of: find.byType(ShaderMask), matching: find.byType(Stack))
        .first;
    final band = find
        .descendant(of: stack, matching: find.byType(DecoratedBox))
        .first;
    return tester.widget<DecoratedBox>(band).decoration;
  }

  final years = [
    for (int year = 2020; year <= 2030; year++)
      GtWheelScrollData(data: year, label: '$year', index: year - 2020),
  ];

  Finder wheelOf(Finder parent) {
    return find.descendant(
      of: parent,
      matching: find.byType(ListWheelScrollView),
    );
  }

  Future<void> scrollByRows(WidgetTester tester, Finder wheel, int rows) async {
    final extent = tester.widget<ListWheelScrollView>(wheel).itemExtent;
    final gesture = await tester.startGesture(tester.getCenter(wheel));
    // Clearing the touch slop scrolls a lone wheel, but a wheel inside another
    // scrollable (such as a draggable sheet) drops it once the gesture arena
    // resolves. Travelling half the slop past the target row lands on it
    // either way.
    await gesture.moveBy(const Offset(0, -kDragSlopDefault));
    await gesture.moveBy(Offset(0, -(extent * rows - kDragSlopDefault / 2)));
    // Holding still before release drops the fling velocity to zero, so the
    // wheel settles on the row it was dragged to at any item extent.
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  group('GtWheelScroll', () {
    testWidgets('scrolling one row selects and reports the next item', (
      tester,
    ) async {
      final changes = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          GtWheelScrollGroup(
            children: [
              GtWheelScroll<int>(
                items: years,
                value: 2020,
                semanticsLabel: 'Year',
                onChanged: (item) => changes.add(item.data),
              ),
            ],
          ),
        ),
      );

      expect(find.text('2020'), findsOneWidget);

      await scrollByRows(tester, find.byType(ListWheelScrollView), 1);

      expect(changes, [2021]);
    });

    testWidgets('announces the selection and steps with adjust actions', (
      tester,
    ) async {
      final changes = <int>[];

      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtWheelScroll<int>(
              items: years,
              value: 2021,
              label: 'Year',
              onChanged: (item) => changes.add(item.data),
            ),
          ),
        );

        final wheel = find.bySemanticsLabel('Year');
        expectSemantics(
          tester,
          wheel,
          label: 'Year',
          value: '2021',
          increasedValue: '2022',
          decreasedValue: '2020',
          hasIncreaseAction: true,
          hasDecreaseAction: true,
        );

        final node = semanticsNodeOf(tester, wheel);
        node.owner!.performAction(node.id, SemanticsAction.increase);
        await tester.pumpAndSettle();

        expect(changes, [2022]);
        expectSemantics(tester, find.bySemanticsLabel('Year'), value: '2022');
      });
    });

    testWidgets('scrolls to a new value set by its parent', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtWheelScroll<int>(items: years, value: 2020, label: 'Year'),
          ),
        );
        await tester.pumpWidget(
          buildTestWidget(
            GtWheelScroll<int>(items: years, value: 2025, label: 'Year'),
          ),
        );
        await tester.pumpAndSettle();

        final controller =
            tester
                    .widget<ListWheelScrollView>(
                      find.byType(ListWheelScrollView),
                    )
                    .controller!
                as FixedExtentScrollController;
        expect(controller.selectedItem, 5);
        expectSemantics(tester, find.bySemanticsLabel('Year'), value: '2025');
      });
    });

    // One test per theme: swapping the theme on a live app animates between
    // palettes, so each theme gets a fresh app.
    final themes = {
      'light': (kPersonalTheme.materialLight, kPersonalTheme.lightPalette),
      'dark': (kPersonalTheme.materialDark, kPersonalTheme.darkPalette),
    };
    for (final MapEntry(key: name, value: (theme, palette)) in themes.entries) {
      testWidgets('the selection band follows the $name theme', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            GtWheelScroll<int>(items: years, value: 2021, label: 'Year'),
            theme: theme,
          ),
        );

        final band = bandOf(tester) as BoxDecoration;
        expect(band.color, palette.bg.white);
      });
    }

    testWidgets('the band and fade accept styling from the parent', (
      tester,
    ) async {
      const decoration = BoxDecoration(color: Colors.amber);
      const gradient = LinearGradient(
        colors: [Colors.transparent, Colors.black],
      );

      await tester.pumpWidget(
        buildTestWidget(
          GtWheelScroll<int>(
            items: years,
            value: 2021,
            label: 'Year',
            selectedDecoration: decoration,
            fadeGradient: gradient,
          ),
        ),
      );

      expect(bandOf(tester), decoration);
      expect(
        tester.widget<ShaderMask>(find.byType(ShaderMask)).shaderCallback,
        gradient.createShader,
      );
    });
  });

  group('GtWheelScrollGroup', () {
    Widget buildGroup({int count = 1, double? maxWheelWidth}) {
      return buildTestWidget(
        GtWheelScrollGroup(
          maxWheelWidth: maxWheelWidth,
          children: [
            for (int i = 0; i < count; i++)
              GtWheelScroll<int>(items: years, value: 2020, label: 'Year'),
          ],
        ),
      );
    }

    double wheelWidth(WidgetTester tester) {
      return tester.getSize(find.byType(GtWheelScroll<int>).first).width;
    }

    testWidgets('caps each wheel at the design width by default', (
      tester,
    ) async {
      await tester.pumpWidget(buildGroup());

      final context = tester.element(find.byType(GtWheelScrollGroup));
      expect(wheelWidth(tester), context.dp(92.px));
    });

    testWidgets('widens each wheel up to maxWheelWidth', (tester) async {
      await tester.pumpWidget(buildGroup());
      final wider = wheelWidth(tester) + 40;

      await tester.pumpWidget(buildGroup(maxWheelWidth: wider));

      expect(wheelWidth(tester), wider);
    });

    testWidgets('never widens a wheel past its share of the card', (
      tester,
    ) async {
      await tester.pumpWidget(buildGroup(count: 2, maxWheelWidth: 10000));

      final row = find
          .descendant(
            of: find.byType(GtWheelScrollGroup),
            matching: find.byType(Row),
          )
          .first;
      expect(wheelWidth(tester), tester.getSize(row).width / 2);
    });
  });

  group('GtDateWheelScroll', () {
    Widget buildDateWheel(
      GtCalendarController controller, {
      Set<GtDateWheelField> fields = const {.day, .month, .year},
    }) {
      return buildTestWidget(
        GtDateWheelScroll(
          controller: controller,
          fields: fields,
          dayLabel: 'Day',
          monthLabel: 'Month',
          yearLabel: 'Year',
        ),
      );
    }

    testWidgets('the day wheel follows the month length in leap years', (
      tester,
    ) async {
      final controller = GtCalendarController(
        GtCalendarValue(day: DateTime(2028, 1, 31)),
        dateRange: DateTimeRange(
          start: DateTime(2020),
          end: DateTime(2030, 12, 31),
        ),
      );
      addTearDown(controller.dispose);

      await withSemantics(tester, () async {
        await tester.pumpWidget(buildDateWheel(controller));

        await scrollByRows(
          tester,
          wheelOf(find.byKey(const ValueKey('gt_date_wheel_scroll_month'))),
          1,
        );

        expect(controller.day, DateTime(2028, 2, 29));
        expectSemantics(
          tester,
          find.bySemanticsLabel('Day'),
          value: '29',
          hasIncreaseAction: false,
        );

        await scrollByRows(
          tester,
          wheelOf(find.byKey(const ValueKey('gt_date_wheel_scroll_year'))),
          1,
        );

        expect(controller.day, DateTime(2029, 2, 28));
        expectSemantics(
          tester,
          find.bySemanticsLabel('Day'),
          value: '28',
          hasIncreaseAction: false,
        );
      });
    });

    testWidgets('only offers dates inside the controller range', (
      tester,
    ) async {
      final controller = GtCalendarController(
        GtCalendarValue(day: DateTime(2026, 6, 19)),
        dateRange: DateTimeRange(
          start: DateTime(2026, 6, 19),
          end: DateTime(2027, 3, 10),
        ),
      );
      addTearDown(controller.dispose);

      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildDateWheel(controller, fields: const {.month, .year}),
        );

        expect(
          find.byKey(const ValueKey('gt_date_wheel_scroll_day')),
          findsNothing,
        );
        expectSemantics(
          tester,
          find.bySemanticsLabel('Month'),
          value: 'June',
          hasDecreaseAction: false,
        );
        expectSemantics(
          tester,
          find.bySemanticsLabel('Year'),
          value: '2026',
          increasedValue: '2027',
          hasDecreaseAction: false,
        );

        await scrollByRows(
          tester,
          wheelOf(find.byKey(const ValueKey('gt_date_wheel_scroll_year'))),
          1,
        );

        expect(controller.day, DateTime(2027, 3, 10));
        expectSemantics(
          tester,
          find.bySemanticsLabel('Month'),
          value: 'March',
          hasIncreaseAction: false,
        );
      });
    });

    testWidgets('an empty controller stays unselected until the user scrolls', (
      tester,
    ) async {
      final controller = GtCalendarController(GtCalendarValue());
      addTearDown(controller.dispose);

      await tester.pumpWidget(buildDateWheel(controller));

      expect(find.byType(GtWheelScroll<int>), findsNWidgets(3));
      expect(controller.day, isNull);
    });

    testWidgets('forwards its styling to every wheel and the card', (
      tester,
    ) async {
      const selectedStyle = TextStyle(fontSize: 21);
      const itemStyle = TextStyle(fontSize: 13);
      const labelStyle = TextStyle(fontSize: 11);
      const decoration = BoxDecoration(color: Colors.amber);
      const gradient = LinearGradient(
        colors: [Colors.transparent, Colors.black],
      );
      const padding = EdgeInsets.all(4);
      final controller = GtCalendarController(
        GtCalendarValue(day: DateTime(2026, 6, 19)),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestWidget(
          GtDateWheelScroll(
            controller: controller,
            dayLabel: 'Day',
            monthLabel: 'Month',
            yearLabel: 'Year',
            selectedStyle: selectedStyle,
            itemStyle: itemStyle,
            labelStyle: labelStyle,
            selectedDecoration: decoration,
            fadeGradient: gradient,
            backgroundColor: Colors.teal,
            padding: padding,
            maxWheelWidth: 120,
          ),
        ),
      );

      final wheels = tester.widgetList<GtWheelScroll<int>>(
        find.byType(GtWheelScroll<int>),
      );
      expect(wheels, hasLength(3));
      for (final wheel in wheels) {
        expect(wheel.selectedStyle, selectedStyle);
        expect(wheel.itemStyle, itemStyle);
        expect(wheel.labelStyle, labelStyle);
        expect(wheel.selectedDecoration, decoration);
        expect(wheel.fadeGradient, gradient);
      }

      final group = tester.widget<GtWheelScrollGroup>(
        find.byType(GtWheelScrollGroup),
      );
      expect(group.color, Colors.teal);
      expect(group.padding, padding);
      expect(group.maxWheelWidth, 120);
    });
  });

  group('GtCalendar', () {
    testWidgets(
      'the header opens a compact month and year wheel bound to the calendar',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final controller = GtCalendarController(
          GtCalendarValue(day: DateTime(2026, 6, 19)),
        );
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          buildTestWidget(GtCalendar(controller: controller)),
        );

        await tester.tap(find.text('June 2026'));
        await tester.pumpAndSettle();

        final modal = find.byType(GtWheelScrollModal);
        expect(modal, findsOneWidget);
        expect(find.byType(DatePickerDialog), findsNothing);
        expect(tester.getSize(modal).height, lessThan(812 / 2));
        expect(tester.getBottomLeft(modal).dy, closeTo(812, 1));
        expect(
          find.byKey(const ValueKey('gt_date_wheel_scroll_day')),
          findsNothing,
        );
        expect(find.text('Jun'), findsOneWidget);

        await scrollByRows(
          tester,
          wheelOf(find.byKey(const ValueKey('gt_date_wheel_scroll_year'))),
          1,
        );

        expect(controller.day, DateTime(2027, 6, 19));
      },
      variant: TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
    );
  });
}
