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
  String _appliedLimits = _limitOptions.first;

  /// Applies [option]'s limits to both controllers after this frame, as
  /// setting them notifies the fields mid-build otherwise.
  void _applyLimits(String option) {
    if (option == _appliedLimits) return;
    _appliedLimits = option;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final limits = _limitsFor(option);
      _dateCtrl.dateRange = limits;
      _dateRangeCtrl.dateRange = limits;
    });
  }

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
    final startLabel = context.knobs.string(
      label: 'Range Start Label',
      initialValue: 'Start',
    );
    final endLabel = context.knobs.string(
      label: 'Range End Label',
      initialValue: 'End',
    );
    final limits = context.knobs.object.dropdown<String>(
      label: 'Date Limits',
      options: _limitOptions,
      initialOption: _limitOptions.first,
    );
    _applyLimits(limits);
    final limitsSnippet = switch (_limitsFor(limits)) {
      final range? =>
        '\n// Limits can change later, e.g. after switching account:\n'
            '_dateRangeCtrl.dateRange = DateTimeRange(\n'
            '  start: DateTime(${range.start.year}, ${range.start.month}, ${range.start.day}),\n'
            '  end: DateTime(${range.end.year}, ${range.end.month}, ${range.end.day}),\n'
            ');\n',
      _ => '',
    };
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
$limitsSnippet
GtDateField.range(
  controller: _dateRangeCtrl,
  label: '$label',
  calendarTitle: '$calendarTitle',
  rangeStartLabel: '$startLabel',
  rangeEndLabel: '$endLabel',
  decoration: /* Selected: ${decoration.$1} */,
)'''
        : '''
final _dateCtrl = GtCalendarController(GtCalendarValue());
$limitsSnippet
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
• <b>GtDateField.range()</b> — Date range picker (start → end).

In the range picker the first tap marks the start and the second finishes the range, whichever way round; tapping the start again picks a single day. With <b>rangeStartLabel</b> and <b>rangeEndLabel</b> set, the sheet shows both ends above the calendar and outlines the one the next tap sets. The field and <b>onChanged</b> change only once the range is finished, and closing the sheet after one tap keeps the earlier range.

Days outside the controller's <b>dateRange</b> are drawn disabled. Set <b>dateRange</b> again whenever the limits change; try the Date Limits knob.''',
      code: codeSnippet,
      child: SizedBox(
        width: 320.px,
        child: isRange
            ? GtDateField.range(
                controller: _dateRangeCtrl,
                label: label,
                calendarTitle: calendarTitle,
                rangeStartLabel: startLabel,
                rangeEndLabel: endLabel,
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

/// The date limits a preview can apply, by knob label.
DateTimeRange? _limitsFor(String option) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return switch (option) {
    'Past year, up to today' => DateTimeRange(
      start: today.subtract(const Duration(days: 365)),
      end: today,
    ),
    'Next 30 days' => DateTimeRange(
      start: today,
      end: today.add(const Duration(days: 30)),
    ),
    _ => null,
  };
}

const _limitOptions = ['None', 'Past year, up to today', 'Next 30 days'];
