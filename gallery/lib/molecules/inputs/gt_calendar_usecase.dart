import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCalendar', type: GtCalendar)
Widget playgroundGtCalendarUseCase(BuildContext context) {
  return const _CalendarPreview();
}

class _CalendarPreview extends GtStatefulWidget {
  const _CalendarPreview();

  @override
  State<_CalendarPreview> createState() => _CalendarPreviewState();
}

class _CalendarPreviewState extends State<_CalendarPreview> {
  final _calendarCtrl = GtCalendarController(GtCalendarValue());
  String _appliedLimits = _limitOptions.first;

  /// Applies [option]'s limits after this frame, as setting them notifies
  /// the calendar mid-build otherwise.
  void _applyLimits(String option) {
    if (option == _appliedLimits) return;
    _appliedLimits = option;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _calendarCtrl.dateRange = _limitsFor(option);
    });
  }

  @override
  void dispose() {
    _calendarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectionMode = context.knobs.object.dropdown(
      label: "Selection Mode",
      options: GtCalendarSelectionMode.values,
      initialOption: GtCalendarSelectionMode.day,
      labelBuilder: (value) => value.name.capitalise(),
    );
    final limits = context.knobs.object.dropdown<String>(
      label: 'Date Limits',
      options: _limitOptions,
      initialOption: _limitOptions.first,
    );
    _applyLimits(limits);

    return GtWidgetDocPage(
      title: 'GtCalendar',
      description:
          'A month calendar for picking a day or a range. In range mode the '
          'first tap marks a start, held as pendingRangeStart, and the second '
          'finishes the range whichever way round; tapping the start again '
          'picks a single day. onSelectRange fires only for a finished range. '
          'Days outside the controller\'s dateRange are drawn disabled and '
          'ignore taps, and dateRange can be set again when the limits change.',
      code:
          '''
final controller = GtCalendarController(GtCalendarValue());${_limitsFor(limits) == null ? '' : '\ncontroller.dateRange = DateTimeRange(start: ..., end: ...); // $limits'}

GtCalendar(
  controller: controller,
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
              if (selectionMode == .day) {
                return GtText("Selected day is: $day", textAlign: .center);
              }
              final start =
                  data.rangeStart?.format("dd MMM yyyy") ?? "No start selected";
              final end = switch (data.rangeEnd) {
                final end? => end.format("dd MMM yyyy"),
                _ when data.isPickingRangeEnd => "Tap an end date",
                _ => "No end selected",
              };

              return GtText("Range: $start - $end", textAlign: .center);
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
