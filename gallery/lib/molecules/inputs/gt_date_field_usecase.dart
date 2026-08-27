import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDateField', type: GtDateField)
Widget playgroundGtDateFieldUseCase(BuildContext context) {
  return const _DateFieldPreview();
}

class _DateFieldPreview extends GtStatefulWidget {
  const _DateFieldPreview();

  @override
  State<_DateFieldPreview> createState() => _DateFieldPreviewState();
}

class _DateFieldPreviewState extends State<_DateFieldPreview> {
  final _dateCtrl = GtCalendarController(GtCalendarValue());
  final _dateRangeCtrl = GtCalendarController(GtCalendarValue());

  @override
  void dispose() {
    _dateCtrl.dispose();
    _dateRangeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = context.knobs.string(
      label: 'Label',
      initialValue: 'Select date',
    );
    final calendarTitle = context.knobs.string(
      label: 'Calendar Title',
      initialValue: 'Pick a date',
    );
    final isRange = context.knobs.boolean(
      label: 'Range Picker Mode',
      initialValue: false,
    );
    final decoration = context.knobs.object
        .dropdown<(String, GtInputDecoration)>(
          label: 'Input Style',
          options: context.inputStyles.all,
          initialOption: context.inputStyles.all.first,
          labelBuilder: (v) => v.$1,
        );

    final codeSnippet = isRange
        ? '''
final _dateRangeCtrl = GtCalendarController(GtCalendarValue());

GtDateField.range(
  controller: _dateRangeCtrl,
  label: '$label',
  calendarTitle: '$calendarTitle',
  decoration: /* Selected: ${decoration.$1} */,
)'''
        : '''
final _dateCtrl = GtCalendarController(GtCalendarValue());

GtDateField(
  controller: _dateCtrl,
  label: '$label',
  calendarTitle: '$calendarTitle',
  decoration: /* Selected: ${decoration.$1} */,
)''';

    return GtWidgetDocPage(
      title: 'GtDateField',
      description: '''
<b>GtDateField</b> is a date picker input that opens a calendar modal on tap.

<b>Constructors:</b>
• <b>GtDateField()</b> — Single date picker.
• <b>GtDateField.range()</b> — Date range picker (start → end).''',
      code: codeSnippet,
      child: SizedBox(
        width: 320.px,
        child: isRange
            ? GtDateField.range(
                controller: _dateRangeCtrl,
                label: label,
                calendarTitle: calendarTitle,
                decoration: decoration.$2,
              )
            : GtDateField(
                controller: _dateCtrl,
                label: label,
                calendarTitle: calendarTitle,
                decoration: decoration.$2,
              ),
      ),
    );
  }
}
