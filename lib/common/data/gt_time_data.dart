import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A time of day to the second, as picked by a [GtTimeController].
///
/// [TimeOfDay] stops at minutes, so this value carries the [second] a pattern
/// such as `HH:mm:ss` shows. Convert with [GtTimeValue.fromTimeOfDay] and
/// [timeOfDay] where only hours and minutes matter.
@immutable
class GtTimeValue implements Comparable<GtTimeValue> {
  /// The hour of the day, from 0 to 23.
  final int hour;

  /// The minute of the hour, from 0 to 59.
  final int minute;

  /// The second of the minute, from 0 to 59.
  final int second;

  /// Creates a time of [hour], [minute] and [second].
  const GtTimeValue({required this.hour, this.minute = 0, this.second = 0})
    : assert(hour >= 0 && hour < 24, 'hour must be from 0 to 23'),
      assert(minute >= 0 && minute < 60, 'minute must be from 0 to 59'),
      assert(second >= 0 && second < 60, 'second must be from 0 to 59');

  /// Creates a time from [time], at [second] past its minute.
  GtTimeValue.fromTimeOfDay(TimeOfDay time, {int second = 0})
    : this(hour: time.hour, minute: time.minute, second: second);

  /// Creates the time of day of [date].
  GtTimeValue.fromDateTime(DateTime date)
    : this(hour: date.hour, minute: date.minute, second: date.second);

  /// Creates the time [seconds] after midnight.
  const GtTimeValue.fromSecondsOfDay(int seconds)
    : this(
        hour: seconds ~/ Duration.secondsPerHour,
        minute: seconds % Duration.secondsPerHour ~/ Duration.secondsPerMinute,
        second: seconds % Duration.secondsPerMinute,
      );

  /// The hour and minute of this time, without its second.
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  /// The seconds from midnight to this time.
  int get secondsOfDay {
    return hour * Duration.secondsPerHour +
        minute * Duration.secondsPerMinute +
        second;
  }

  /// Whether this time comes before [other] in the day.
  bool isBefore(GtTimeValue other) => secondsOfDay < other.secondsOfDay;

  /// Whether this time comes after [other] in the day.
  bool isAfter(GtTimeValue other) => secondsOfDay > other.secondsOfDay;

  /// This time on [date]'s day.
  DateTime onDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute, second);
  }

  /// Formats this time with the date [pattern], such as `HH:mm` or
  /// `hh:mm a`, in the app's locale.
  String format(String pattern) {
    // A fixed day keeps a daylight saving change out of the result.
    return onDate(DateTime(2000)).format(pattern);
  }

  @override
  int compareTo(GtTimeValue other) => secondsOfDay - other.secondsOfDay;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GtTimeValue && other.secondsOfDay == secondsOfDay;
  }

  @override
  int get hashCode => secondsOfDay.hashCode;

  @override
  String toString() {
    String pad(int value) => value.toString().padLeft(2, '0');
    return 'GtTimeValue(${pad(hour)}:${pad(minute)}:${pad(second)})';
  }
}

/// Holds the time picked in a [GtTimeField] or a [GtTimeWheelScroll], and the
/// earliest and latest times it may take.
///
/// Set [earliest] to the current time when the picked time is for today and
/// may not be in the past:
///
/// ```dart
/// final controller = GtTimeController(earliest: TimeOfDay.now());
/// ```
///
/// Read the pick as a [TimeOfDay] through [time], or to the second through
/// [value].
class GtTimeController extends ValueNotifier<GtTimeValue?> {
  /// Creates a controller holding [value], or [time] at the start of its
  /// minute, limited to [earliest] and [latest].
  GtTimeController({
    GtTimeValue? value,
    TimeOfDay? time,
    TimeOfDay? earliest,
    TimeOfDay? latest,
  }) : assert(value == null || time == null, 'give value or time, not both'),
       assert(
         earliest == null || latest == null || !_isAfter(earliest, latest),
         'earliest must not be after latest',
       ),
       _earliest = earliest,
       _latest = latest,
       super(value ?? _valueOf(time));

  /// The earliest time that may be picked, or null for midnight.
  TimeOfDay? _earliest;

  /// The latest time that may be picked, or null for the end of the day.
  TimeOfDay? _latest;

  /// [time] at the start of its minute, or null.
  static GtTimeValue? _valueOf(TimeOfDay? time) {
    if (time == null) return null;
    return GtTimeValue.fromTimeOfDay(time);
  }

  /// Whether [a] is a later minute of the day than [b].
  static bool _isAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour * 60 + a.minute > b.hour * 60 + b.minute;
  }

  /// The earliest time that may be picked, from its first second. Null allows
  /// any time from midnight.
  TimeOfDay? get earliest => _earliest;

  /// The latest time that may be picked, to its first second: a latest of
  /// 17:00 allows 17:00:00 but not 17:00:30. Null allows any time to the end
  /// of the day.
  TimeOfDay? get latest => _latest;

  /// Moves the earliest time that may be picked and drops a picked time
  /// before it.
  set earliest(TimeOfDay? time) => setLimits(earliest: time, latest: _latest);

  /// Moves the latest time that may be picked and drops a picked time after
  /// it.
  set latest(TimeOfDay? time) => setLimits(earliest: _earliest, latest: time);

  /// Moves both limits at once and drops a picked time outside them, so a
  /// window that moves past its old bounds never asserts halfway.
  void setLimits({TimeOfDay? earliest, TimeOfDay? latest}) {
    assert(
      earliest == null || latest == null || !_isAfter(earliest, latest),
      'earliest must not be after latest',
    );
    final changed = earliest != _earliest || latest != _latest;
    _earliest = earliest;
    _latest = latest;

    final picked = value;
    if (picked != null && !isAllowed(picked)) {
      value = null;
    } else if (changed) {
      notifyListeners();
    }
  }

  /// The earliest time that may be picked, to the second.
  GtTimeValue get earliestValue {
    return GtTimeValue.fromTimeOfDay(
      _earliest ?? TimeOfDay(hour: 0, minute: 0),
    );
  }

  /// The latest time that may be picked, to the second.
  GtTimeValue get latestValue {
    final latest = _latest;
    if (latest == null) return GtTimeValue(hour: 23, minute: 59, second: 59);
    return GtTimeValue.fromTimeOfDay(latest);
  }

  /// Whether [time] lies within [earliest] and [latest].
  bool isAllowed(GtTimeValue time) {
    return !time.isBefore(earliestValue) && !time.isAfter(latestValue);
  }

  /// The picked hour and minute, without the second.
  TimeOfDay? get time => value?.timeOfDay;

  /// Picks [time] at the start of its minute, or clears the pick when null.
  set time(TimeOfDay? time) => value = _valueOf(time);

  /// The picked time formatted with the date [pattern], or null when nothing
  /// is picked.
  String? formatted(String pattern) => value?.format(pattern);
}
