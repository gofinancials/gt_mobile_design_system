import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Represents the current selection state for a calendar.
///
/// This class holds either a single selected [day] or a selected date [range].
class GtCalendarValue {
  /// The currently selected single date, if any.
  final DateTime? day;

  /// The currently selected date range, if any.
  final DateTimeRange? range;

  /// Creates a new [GtCalendarValue] with the specified [day] and/or [range].
  const GtCalendarValue({this.day, this.range});

  /// Creates a copy of this value but with the given fields replaced with the new values.
  GtCalendarValue copyWith({DateTime? day, DateTimeRange? range}) {
    return GtCalendarValue(day: day ?? this.day, range: range ?? this.range);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtCalendarValue && other.day == day && other.range == range;
  }

  @override
  int get hashCode => Object.hash(day, range);
}

/// A controller for a calendar widget that manages the [GtCalendarValue] state.
///
/// It extends [ValueNotifier] to allow widgets to rebuild when the calendar selection
/// changes. It also manages the overall selectable date range boundaries of the calendar.
class GtCalendarController extends ValueNotifier<GtCalendarValue> {
  DateTimeRange? _dateRange;

  /// Creates a [GtCalendarController] with an initial [value] and an optional
  /// overall [dateRange] that defines the earliest and latest selectable dates.
  GtCalendarController(super.value, {DateTimeRange? dateRange})
    : assert(
        dateRange == null ||
            (dateRange.start.isBefore(dateRange.end) ||
                dateRange.start.difference(dateRange.end).inMonths > 1),
      ),
      _dateRange = dateRange;

  /// The overall allowed date boundaries for the calendar.
  ///
  /// If no range was provided during initialization, this defaults to a 200-year span
  /// centered around the currently selected day (or today, if no day is selected).
  DateTimeRange get calendarRange {
    if (_dateRange != null) return _dateRange!;
    final hundredYears = 365.days * 100;
    final functor = day ?? today;
    _dateRange = DateTimeRange(
      start: functor.subtract(hundredYears),
      end: functor.add(hundredYears),
    );
    return _dateRange!;
  }

  /// Sets the currently selected single day.
  set day(DateTime? day) {
    value = value.copyWith(day: day);
  }

  /// Sets the currently selected date range.
  set range(DateTimeRange? range) {
    value = value.copyWith(range: range);
  }

  /// Gets the currently selected single day.
  DateTime? get day => value.day;

  /// Gets the currently selected date range.
  DateTimeRange? get range => value.range;

  /// The earliest date that can be displayed and selected in the calendar.
  DateTime get firstDay => calendarRange.start;

  /// The latest date that can be displayed and selected in the calendar.
  DateTime get lastDay => calendarRange.end;

  /// The current, present-day date.
  DateTime get today => DateTime.now();
}

/// Defines the available selection behaviors for a calendar widget.
enum GtCalendarSelectionMode {
  /// Allows the user to select a single specific day.
  day,

  /// Allows the user to select a start and end date to form a range.
  range,
}
