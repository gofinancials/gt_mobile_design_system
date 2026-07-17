import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _calendarCtrl = GtCalendarController(GtCalendarValue());

@widgetbook.UseCase(name: 'GtCalendar', type: GtCalendar)
Widget playgroundGtCalendarUseCase(BuildContext context) {
  final selectionMode = context.knobs.object.dropdown(
    label: "Selection Mode",
    options: GtCalendarSelectionMode.values,
    initialOption: GtCalendarSelectionMode.day,
    labelBuilder: (value) => value.name.capitalise(),
  );

  return GtWidgetDocPage(
    title: 'GtCalendar',
    description: 'Documentation for GtCalendar',
    code:
        '''
GtCalendar(
  controller: GtCalendarController(GtCalendarValue()),
  selectionMode: .${selectionMode.name},
),
''',
    child: Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        GenericListener(
          valueListenable: _calendarCtrl,
          builder: (data) {
            final day =
                data.day?.format("EEE, dd MMM yyyy") ?? "No day selected";
            final range = selectionMode != .day ? data.range : null;
            final start =
                range?.start.format("dd MMM yyyy") ?? "No start selected";
            final end = range?.end.format("dd MMM yyyy") ?? "No endselected";

            return GtText(
              "Selected day is: $day, selected range is $start - $end",
              textAlign: .center,
            );
          },
        ),
        const GtGap.yLg(),
        GtCalendar(
          controller: _calendarCtrl,
          key: PageStorageKey("gt-calendar"),
          selectionMode: selectionMode,
        ),
      ],
    ),
  );
}
