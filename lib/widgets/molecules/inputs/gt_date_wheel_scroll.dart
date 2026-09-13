import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The parts of a date that a [GtDateWheelScroll] can show as wheels.
enum GtDateWheelField {
  /// A wheel of the days in the selected month.
  day,

  /// A wheel of the months in the selected year.
  month,

  /// A wheel of the years between the controller's first and last day.
  year,
}

/// A date picker made of day, month and year [GtWheelScroll]s placed side by
/// side.
///
/// The wheels read and write the selected day of a [GtCalendarController] and
/// only offer dates between its [GtCalendarController.firstDay] and
/// [GtCalendarController.lastDay]. The day wheel follows the length of the
/// selected month, leap years included. When a month or year change leaves the
/// selected day out of range, the day moves to the nearest valid one.
///
/// Until the user scrolls, an empty controller shows today, or the nearest
/// selectable date, without selecting it.
class GtDateWheelScroll extends GtStatefulWidget {
  /// The controller holding the selected date and the selectable range.
  final GtCalendarController? controller;

  /// The date parts to show as wheels. They are always laid out as day, month,
  /// then year.
  ///
  /// Defaults to all three.
  final Set<GtDateWheelField> fields;

  /// Callback fired when the user scrolls to a new date.
  final OnChanged<DateTime>? onChanged;

  /// Whether each wheel shows its label as a header. Defaults to true.
  ///
  /// Screen readers announce the labels either way.
  final bool showLabels;

  /// The label of the day wheel. Defaults to the translated "day".
  final String? dayLabel;

  /// The label of the month wheel. Defaults to the translated "month".
  final String? monthLabel;

  /// The label of the year wheel. Defaults to the translated "year".
  final String? yearLabel;

  /// The date format used for month names. Defaults to `"MMMM"`.
  final String monthFormat;

  /// The visual scale of the wheels. Defaults to [GtWheelScrollSize.regular].
  final GtWheelScrollSize size;

  /// Whether the wheels respond to scrolling. Defaults to true.
  final bool isEnabled;

  /// The text style of each wheel's selected item. See
  /// [GtWheelScroll.selectedStyle].
  final TextStyle? selectedStyle;

  /// The text style of the items around each wheel's selected one. See
  /// [GtWheelScroll.itemStyle].
  final TextStyle? itemStyle;

  /// The text style of the wheel labels. See [GtWheelScroll.labelStyle].
  final TextStyle? labelStyle;

  /// The decoration of the band behind each wheel's selected item. See
  /// [GtWheelScroll.selectedDecoration].
  final Decoration? selectedDecoration;

  /// The gradient that fades each wheel's items above and below the selected
  /// one. See [GtWheelScroll.fadeGradient].
  final Gradient? fadeGradient;

  /// The background color of the card holding the wheels. See
  /// [GtWheelScrollGroup.color].
  final Color? backgroundColor;

  /// The padding inside the card holding the wheels. See
  /// [GtWheelScrollGroup.padding].
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtDateWheelScroll].
  const GtDateWheelScroll({
    super.key,
    this.controller,
    this.fields = const {.day, .month, .year},
    this.onChanged,
    this.showLabels = true,
    this.dayLabel,
    this.monthLabel,
    this.yearLabel,
    this.monthFormat = "MMMM",
    this.size = .regular,
    this.isEnabled = true,
    this.selectedStyle,
    this.itemStyle,
    this.labelStyle,
    this.selectedDecoration,
    this.fadeGradient,
    this.backgroundColor,
    this.padding,
  });

  @override
  State<GtDateWheelScroll> createState() => _GtDateWheelScrollState();
}

/// The state for [GtDateWheelScroll].
class _GtDateWheelScrollState extends State<GtDateWheelScroll> {
  /// The controller in use, either [GtDateWheelScroll.controller] or one
  /// created locally.
  late GtCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GtCalendarController(GtCalendarValue());
  }

  @override
  void didUpdateWidget(covariant GtDateWheelScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? GtCalendarController(GtCalendarValue());
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  /// The earliest selectable date, without its time of day.
  DateTime get _firstDay => DateUtils.dateOnly(_controller.firstDay);

  /// The latest selectable date, without its time of day.
  DateTime get _lastDay => DateUtils.dateOnly(_controller.lastDay);

  /// The years between the first and last selectable day.
  List<GtWheelScrollData<int>> get _years {
    final first = _firstDay.year;
    return [
      for (int year = first; year <= _lastDay.year; year++)
        GtWheelScrollData(data: year, label: "$year", index: year - first),
    ];
  }

  /// The selectable months of [year].
  List<GtWheelScrollData<int>> _monthsOf(int year) {
    int first = DateTime.january;
    int last = DateTime.december;
    if (year == _firstDay.year) {
      first = _firstDay.month;
    }
    if (year == _lastDay.year) {
      last = _lastDay.month;
    }

    return [
      for (int month = first; month <= last; month++)
        GtWheelScrollData(
          data: month,
          label: DateTime(year, month).format(widget.monthFormat),
          index: month - first,
        ),
    ];
  }

  /// The selectable days of [month] in [year].
  List<GtWheelScrollData<int>> _daysOf(int year, int month) {
    int first = 1;
    int last = DateUtils.getDaysInMonth(year, month);
    if (year == _firstDay.year && month == _firstDay.month) {
      first = _firstDay.day;
    }
    if (year == _lastDay.year && month == _lastDay.month) {
      last = _lastDay.day;
    }

    return [
      for (int day = first; day <= last; day++)
        GtWheelScrollData(data: day, label: "$day", index: day - first),
    ];
  }

  /// Returns [date] without its time of day, moved into the selectable range.
  DateTime _clamp(DateTime date) {
    final day = DateUtils.dateOnly(date);
    if (day.isBefore(_firstDay)) return _firstDay;
    if (day.isAfter(_lastDay)) return _lastDay;
    return day;
  }

  /// Builds a date from [year], [month] and [day], pulling the day back to the
  /// month's last day and the result into the selectable range.
  DateTime _compose(int year, int month, int day) {
    final monthLength = DateUtils.getDaysInMonth(year, month);
    return _clamp(DateTime(year, month, math.min(day, monthLength)));
  }

  /// Selects [date] on the controller and reports it.
  void _select(DateTime date) {
    _controller.day = date;
    widget.onChanged?.call(date);
  }

  /// Builds the wheel that edits the [field] part of [date].
  Widget _buildWheel(GtDateWheelField field, DateTime date) {
    final label = switch (field) {
      .day => widget.dayLabel ?? "day".ctr(),
      .month => widget.monthLabel ?? "month".ctr(),
      .year => widget.yearLabel ?? "year".ctr(),
    };
    final items = switch (field) {
      .day => _daysOf(date.year, date.month),
      .month => _monthsOf(date.year),
      .year => _years,
    };
    final value = switch (field) {
      .day => date.day,
      .month => date.month,
      .year => date.year,
    };

    String? header;
    if (widget.showLabels) {
      header = label;
    }

    return GtWheelScroll<int>(
      key: ValueKey("gt_date_wheel_scroll_${field.name}"),
      items: items,
      value: value,
      label: header,
      semanticsLabel: label,
      size: widget.size,
      isEnabled: widget.isEnabled,
      selectedStyle: widget.selectedStyle,
      itemStyle: widget.itemStyle,
      labelStyle: widget.labelStyle,
      selectedDecoration: widget.selectedDecoration,
      fadeGradient: widget.fadeGradient,
      onChanged: (item) {
        final selected = switch (field) {
          .day => _compose(date.year, date.month, item.data),
          .month => _compose(date.year, item.data, date.day),
          .year => _compose(item.data, date.month, date.day),
        };
        _select(selected);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericListener(
      valueListenable: _controller,
      builder: (value) {
        final date = _clamp(value.day ?? _controller.today);

        return GtWheelScrollGroup(
          color: widget.backgroundColor,
          padding: widget.padding,
          children: [
            for (final field in GtDateWheelField.values)
              if (widget.fields.contains(field)) _buildWheel(field, date),
          ],
        );
      },
    );
  }
}
