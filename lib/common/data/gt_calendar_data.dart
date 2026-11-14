import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Represents the current selection state for a calendar.
///
/// This class holds a selected [day], a finished date [range], and, while a
/// range is being picked, the [pendingRangeStart] tapped first.
class GtCalendarValue {
  /// The currently selected single date, if any.
  ///
  /// In range mode the calendar also uses it as the day in focus, so it
  /// follows the last day tapped and the month picked from the header.
  final DateTime? day;

  /// The finished date range, if any.
  ///
  /// It is set only once both ends are picked. While a new range is being
  /// picked it keeps the last finished range, so a sheet closed halfway
  /// leaves the earlier choice in place; [rangeStart] and [rangeEnd] describe
  /// the pick in progress.
  final DateTimeRange? range;

  /// The start of a range whose end has not been picked yet, or null when no
  /// pick is in progress.
  final DateTime? pendingRangeStart;

  /// Creates a new [GtCalendarValue] with the specified [day], [range] and
  /// [pendingRangeStart].
  const GtCalendarValue({this.day, this.range, this.pendingRangeStart});

  /// The start of the range the calendar shows: the [pendingRangeStart] while
  /// a pick is in progress, otherwise the start of [range].
  DateTime? get rangeStart => pendingRangeStart ?? range?.start;

  /// The end of the range the calendar shows: null while a pick is in
  /// progress, otherwise the end of [range].
  DateTime? get rangeEnd => pendingRangeStart == null ? range?.end : null;

  /// Whether a range's start has been picked and its end is awaited.
  bool get isPickingRangeEnd => pendingRangeStart != null;

  /// Creates a copy of this value but with the given fields replaced with the new values.
  ///
  /// A null argument keeps the current value. To clear a field, set it on
  /// [GtCalendarController], whose setters replace the value outright, or
  /// build a new [GtCalendarValue].
  GtCalendarValue copyWith({
    DateTime? day,
    DateTimeRange? range,
    DateTime? pendingRangeStart,
  }) {
    return GtCalendarValue(
      day: day ?? this.day,
      range: range ?? this.range,
      pendingRangeStart: pendingRangeStart ?? this.pendingRangeStart,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtCalendarValue &&
        other.day == day &&
        other.range == range &&
        other.pendingRangeStart == pendingRangeStart;
  }

  @override
  int get hashCode => Object.hash(day, range, pendingRangeStart);
}

/// A controller for a calendar widget that manages the [GtCalendarValue] state.
///
/// It extends [ValueNotifier] to allow widgets to rebuild when the calendar selection
/// changes. It also manages the overall selectable date range boundaries of the calendar.
class GtCalendarController extends ValueNotifier<GtCalendarValue> {
  DateTimeRange? _dateRange;

  /// Creates a [GtCalendarController] with an initial [value] and an optional
  /// overall [dateRange] that defines the earliest and latest selectable dates.
  ///
  /// The [dateRange] may be a single day, but its start must not be after
  /// its end.
  GtCalendarController(super.value, {DateTimeRange? dateRange})
    : assert(dateRange == null || !dateRange.start.isAfter(dateRange.end)),
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

  /// Sets the earliest and latest selectable dates, or null for the default
  /// 200-year span, and notifies listeners.
  ///
  /// Use it when a screen's limits change after the controller is built, such
  /// as an account's opening date after the customer switches account. Any
  /// part of the selection outside the new limits is dropped: a [day], a
  /// [range] that is not wholly inside them, and a [pendingRangeStart].
  set dateRange(DateTimeRange? dateRange) {
    assert(dateRange == null || !dateRange.start.isAfter(dateRange.end));
    _dateRange = dateRange;
    if (dateRange == null) {
      notifyListeners();
      return;
    }

    // Compared as calendar dates: the calendar reports days in UTC, while
    // apps usually give the limits in local time.
    final first = DateUtils.dateOnly(dateRange.start);
    final last = DateUtils.dateOnly(dateRange.end);
    bool outside(DateTime? date) {
      if (date == null) return false;
      final dateOnly = DateTime(date.year, date.month, date.day);
      return dateOnly.isBefore(first) || dateOnly.isAfter(last);
    }

    final current = value;
    final next = GtCalendarValue(
      day: outside(current.day) ? null : current.day,
      range: outside(current.range?.start) || outside(current.range?.end)
          ? null
          : current.range,
      pendingRangeStart: outside(current.pendingRangeStart)
          ? null
          : current.pendingRangeStart,
    );
    if (next == current) {
      notifyListeners();
    } else {
      value = next;
    }
  }

  /// The limits set through the constructor or [dateRange], or null when the
  /// default span applies.
  DateTimeRange? get dateRange => _dateRange;

  /// Sets the currently selected single day.
  set day(DateTime? day) {
    value = GtCalendarValue(
      day: day,
      range: range,
      pendingRangeStart: pendingRangeStart,
    );
  }

  /// Sets the finished date range, or clears it when null.
  ///
  /// Either way it ends any pick in progress.
  set range(DateTimeRange? range) {
    value = GtCalendarValue(day: day, range: range);
  }

  /// Gets the currently selected single day.
  DateTime? get day => value.day;

  /// Gets the finished date range.
  ///
  /// See [GtCalendarValue.range].
  DateTimeRange? get range => value.range;

  /// Gets the start of a range whose end is still awaited.
  ///
  /// See [GtCalendarValue.pendingRangeStart].
  DateTime? get pendingRangeStart => value.pendingRangeStart;

  /// Gets the start of the range the calendar shows.
  ///
  /// See [GtCalendarValue.rangeStart].
  DateTime? get rangeStart => value.rangeStart;

  /// Gets the end of the range the calendar shows.
  ///
  /// See [GtCalendarValue.rangeEnd].
  DateTime? get rangeEnd => value.rangeEnd;

  /// Records a tap on [date] while picking a range, and returns the range
  /// once it is finished.
  ///
  /// The first tap sets [pendingRangeStart] and returns null; [range] keeps
  /// the last finished range meanwhile. The next tap finishes the range,
  /// in order whichever of the two days is earlier, and returns it. A second
  /// tap on the start day finishes a range of that one day.
  DateTimeRange? pickRangeDay(DateTime date) {
    final start = pendingRangeStart;
    if (start == null) {
      value = GtCalendarValue(day: date, range: range, pendingRangeStart: date);
      return null;
    }
    final finished = date.isBefore(start)
        ? DateTimeRange(start: date, end: start)
        : DateTimeRange(start: start, end: date);
    value = GtCalendarValue(day: date, range: finished);
    return finished;
  }

  /// Drops a pick in progress, keeping the last finished [range].
  void cancelRangePick() {
    if (pendingRangeStart == null) return;
    value = GtCalendarValue(day: day, range: range);
  }

  /// The earliest date that can be displayed and selected in the calendar.
  DateTime get firstDay => calendarRange.start;

  /// The latest date that can be displayed and selected in the calendar.
  DateTime get lastDay => calendarRange.end;

  /// The current, present-day date.
  DateTime get today => DateTime.now();

  /// Returns the currently selected single day formatted as a string.
  ///
  /// The string is formatted according to the provided [format], which
  /// defaults to `'dd/MM/yyyy'`. Returns `null` if no day is selected.
  String? formattedDay([String format = 'dd/MM/yyyy']) {
    return day?.format(format);
  }

  /// Returns the finished date range formatted as a string.
  ///
  /// The string is formatted according to the provided [format], which
  /// defaults to `'dd/MM/yyyy'`. Returns `null` if no range is finished.
  String? formattedRange([String format = 'dd/MM/yyyy']) {
    return range?.formattedDateRange(format);
  }
}

/// Defines the available selection behaviors for a calendar widget.
enum GtCalendarSelectionMode {
  /// Allows the user to select a single specific day.
  day,

  /// Allows the user to select a start and end date to form a range.
  range,
}
