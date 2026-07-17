import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCalendar', type: GtCalendar)
Widget playgroundGtCalendarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtCalendar',
    description: 'Documentation for GtCalendar',
    code: '''
GtCalendar(
  controller: GtCalendarController(GtCalendarValue()),
)
''',
    child: GtCalendar(
      controller: GtCalendarController(GtCalendarValue()),
    ),
  );
}
