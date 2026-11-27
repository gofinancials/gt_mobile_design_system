import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The parts of a time that a [GtTimeWheelScroll] can show as wheels.
enum GtTimeWheelField {
  /// A wheel of hours, in 24-hour or 12-hour form as the pattern asks.
  hour,

  /// A wheel of minutes, at the minute step.
  minute,

  /// A wheel of seconds, at the second step.
  second,

  /// A wheel of the locale's AM and PM labels.
  period,
}

/// What a time pattern such as `HH:mm` or `hh:mm a` asks of the wheels.
@immutable
class GtTimePattern {
  /// The pattern this was read from.
  final String pattern;

  /// The pattern's hour symbols, such as `HH` or `h`, which format each hour
  /// on the hour wheel.
  final String hourToken;

  /// Whether the pattern shows seconds, so a second wheel is needed.
  final bool hasSeconds;

  /// Whether the pattern shows hours in 12-hour form with an AM/PM marker,
  /// so a period wheel is needed.
  final bool is12Hour;

  /// The wheels the pattern needs, in the order its fields appear, so a
  /// locale pattern that puts the marker first, such as `a h:mm`, puts the
  /// period wheel first.
  final List<GtTimeWheelField> fields;

  /// Creates a read pattern; see [GtTimePattern.parse].
  const GtTimePattern._({
    required this.pattern,
    required this.hourToken,
    required this.hasSeconds,
    required this.is12Hour,
    required this.fields,
  });

  /// Reads [pattern], a date pattern of hours and minutes with optional
  /// seconds and an AM/PM marker. Quoted text is ignored.
  ///
  /// A pattern in 12-hour form (`h` or `K`) must carry its marker (`a`), or
  /// a morning and an evening time would look the same.
  factory GtTimePattern.parse(String pattern) {
    final symbols = pattern.replaceAll(RegExp("'[^']*'"), '');
    final hourToken = RegExp('[hHkK]+').firstMatch(symbols)?.group(0);
    assert(hourToken != null, 'a time pattern needs an hour: $pattern');
    assert(symbols.contains('m'), 'a time pattern needs minutes: $pattern');
    final token = hourToken ?? 'HH';
    final is12Hour = token.startsWith('h') || token.startsWith('K');
    final hasPeriod = symbols.contains('a');
    assert(
      !is12Hour || hasPeriod,
      'a 12-hour pattern needs an AM/PM marker (a): $pattern',
    );
    final hasSeconds = symbols.contains('s');

    final positions = <GtTimeWheelField, int>{
      .hour: symbols.indexOf(token),
      .minute: symbols.indexOf('m'),
      if (hasSeconds) .second: symbols.indexOf('s'),
      if (is12Hour) .period: symbols.indexOf('a'),
    };
    final fields = positions.keys.toList()
      ..sort((a, b) => positions[a]!.compareTo(positions[b]!));

    return GtTimePattern._(
      pattern: pattern,
      hourToken: token,
      hasSeconds: hasSeconds,
      is12Hour: is12Hour,
      fields: List.unmodifiable(fields),
    );
  }
}

/// A time picker made of hour, minute and, as its [pattern] needs, second
/// and AM/PM [GtWheelScroll]s placed side by side.
///
/// The wheels read and write the time of a [GtTimeController] and only offer
/// times between its [GtTimeController.earliest] and
/// [GtTimeController.latest]. Minutes move in steps of [minuteStep] and
/// seconds in steps of [secondStep]; an hour with no step inside the limits
/// leaves the hour wheel. When a change leaves the time outside the limits,
/// it moves to the nearest time that is allowed.
///
/// The [pattern] decides the wheels: `HH:mm` shows hours and minutes,
/// `HH:mm:ss` adds seconds, and `hh:mm a` shows 12-hour hours with an AM/PM
/// wheel labelled in the app's locale. Screen readers step through each
/// wheel as [GtWheelScroll] allows.
///
/// Until the user scrolls, an empty controller shows the next step from now,
/// or the nearest allowed time, without picking it. Set [selectInitialTime]
/// to pick the shown time as the wheels open. When no step fits inside the
/// limits, the wheels are disabled.
class GtTimeWheelScroll extends GtStatefulWidget {
  /// The controller holding the picked time and its limits.
  final GtTimeController? controller;

  /// The date pattern that decides the wheels, such as `HH:mm`, `HH:mm:ss`
  /// or `hh:mm a`. See [GtTimePattern.parse].
  ///
  /// Defaults to `HH:mm`.
  final String pattern;

  /// The minutes between neighbouring items of the minute wheel, from 1 to
  /// 59. Defaults to 1; 15 offers quarter hours.
  final int minuteStep;

  /// The seconds between neighbouring items of the second wheel, from 1 to
  /// 59. Defaults to 1. Only a pattern with seconds uses it.
  final int secondStep;

  /// Whether the shown time is picked as the wheels open when the controller
  /// holds none, so a customer who sees the time they want need not scroll,
  /// or holds one the wheels cannot show, such as 14:17 on a 15-minute step,
  /// so the pick matches the wheels.
  ///
  /// Defaults to false. [GtTimeField] sets it.
  final bool selectInitialTime;

  /// Callback fired when the user scrolls to a new time.
  final OnChanged<GtTimeValue>? onChanged;

  /// Whether each wheel shows its label as a header. Defaults to true.
  ///
  /// Screen readers announce the labels either way.
  final bool showLabels;

  /// The label of the hour wheel. Defaults to the translated "hour".
  final String? hourLabel;

  /// The label of the minute wheel. Defaults to the translated "minute".
  final String? minuteLabel;

  /// The label of the second wheel. Defaults to the translated "second".
  final String? secondLabel;

  /// The label of the AM/PM wheel. Defaults to the locale's two markers,
  /// such as "AM/PM".
  final String? periodLabel;

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

  /// The widest each wheel may grow, in logical pixels. See
  /// [GtWheelScrollGroup.maxWheelWidth].
  final double? maxWheelWidth;

  /// Creates a [GtTimeWheelScroll].
  const GtTimeWheelScroll({
    super.key,
    this.controller,
    this.pattern = "HH:mm",
    this.minuteStep = 1,
    this.secondStep = 1,
    this.selectInitialTime = false,
    this.onChanged,
    this.showLabels = true,
    this.hourLabel,
    this.minuteLabel,
    this.secondLabel,
    this.periodLabel,
    this.size = .regular,
    this.isEnabled = true,
    this.selectedStyle,
    this.itemStyle,
    this.labelStyle,
    this.selectedDecoration,
    this.fadeGradient,
    this.backgroundColor,
    this.padding,
    this.maxWheelWidth,
  }) : assert(
         minuteStep > 0 && minuteStep < 60,
         'minuteStep must be from 1 to 59',
       ),
       assert(
         secondStep > 0 && secondStep < 60,
         'secondStep must be from 1 to 59',
       );

  @override
  State<GtTimeWheelScroll> createState() => _GtTimeWheelScrollState();
}

/// The state for [GtTimeWheelScroll].
///
/// Times are worked in seconds of the day. The steps lay a grid over the
/// day: an hour, a minute on the minute step and a second on the second step
/// (only second 0 when the pattern has no seconds). Every time the wheels
/// offer is on that grid and between [_first] and [_last].
class _GtTimeWheelScrollState extends State<GtTimeWheelScroll> {
  /// The seconds in an hour.
  static const _hour = Duration.secondsPerHour;

  /// The seconds in a minute.
  static const _minute = Duration.secondsPerMinute;

  /// The controller in use, either [GtTimeWheelScroll.controller] or one
  /// created locally.
  late GtTimeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GtTimeController();
    if (widget.selectInitialTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final first = _first;
        if (first == null || first > _last) return;
        final value = _controller.value;
        final shown = _shownTime(value);
        if (value?.secondsOfDay == shown) return;
        _select(shown);
      });
    }
  }

  @override
  void didUpdateWidget(covariant GtTimeWheelScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    if (oldWidget.controller == null) _controller.dispose();
    _controller = widget.controller ?? GtTimeController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  /// [GtTimeWheelScroll.pattern] as last read, kept so it is read again
  /// only when the pattern changes.
  GtTimePattern? _parsed;

  /// What [GtTimeWheelScroll.pattern] asks of the wheels.
  GtTimePattern get _pattern {
    final parsed = _parsed;
    if (parsed != null && parsed.pattern == widget.pattern) return parsed;
    return _parsed = GtTimePattern.parse(widget.pattern);
  }

  /// The minutes between neighbouring items of the minute wheel.
  int get _minuteStep => widget.minuteStep;

  /// The second step, or a full minute when the pattern has no seconds so
  /// only second 0 is on the grid.
  int get _secondStep => _pattern.hasSeconds ? widget.secondStep : _minute;

  /// The last minute of an hour on the grid.
  int get _lastMinute => 59 ~/ _minuteStep * _minuteStep;

  /// The last second of a minute on the grid.
  int get _lastSecond => 59 ~/ _secondStep * _secondStep;

  /// [value] rounded up to a multiple of [step].
  static int _ceilTo(int value, int step) => (value + step - 1) ~/ step * step;

  /// The first time on the grid at or after [seconds], or null when the day
  /// ends first.
  int? _ceil(int seconds) {
    int hour = seconds ~/ _hour;
    int minute = seconds % _hour ~/ _minute;
    int second = _ceilTo(seconds % _minute, _secondStep);
    if (second >= _minute) {
      second = 0;
      minute += 1;
    }
    if (minute % _minuteStep != 0) {
      minute = _ceilTo(minute, _minuteStep);
      second = 0;
    }
    if (minute >= 60) {
      minute = 0;
      second = 0;
      hour += 1;
    }
    if (hour >= 24) return null;
    return hour * _hour + minute * _minute + second;
  }

  /// The last time on the grid at or before [seconds].
  int _floor(int seconds) {
    final hour = seconds ~/ _hour;
    int minute = seconds % _hour ~/ _minute;
    int second = seconds % _minute ~/ _secondStep * _secondStep;
    if (minute % _minuteStep != 0) {
      minute = minute ~/ _minuteStep * _minuteStep;
      second = _lastSecond;
    }
    return hour * _hour + minute * _minute + second;
  }

  /// The first time the wheels offer, or null when no step is left in the
  /// day after the earliest time.
  int? get _first => _ceil(_controller.earliestValue.secondsOfDay);

  /// The last time the wheels offer.
  int get _last => _floor(_controller.latestValue.secondsOfDay);

  /// Returns [seconds] moved onto the grid and between [_first] and [_last].
  int _clamp(int seconds) {
    final first = _first;
    if (first == null || first > _last) return _floor(seconds);
    if (seconds < first) return first;
    if (seconds > _last) return _last;
    return _floor(seconds);
  }

  /// The time the wheels show for [value]: the value moved into range, or
  /// for no value the next step from now.
  int _shownTime(GtTimeValue? value) {
    if (value != null) return _clamp(value.secondsOfDay);
    final now = GtTimeValue.fromDateTime(DateTime.now()).secondsOfDay;
    return _clamp(_ceil(now) ?? _last);
  }

  /// Picks the time [seconds] after midnight and reports it.
  void _select(int seconds) {
    final time = GtTimeValue.fromSecondsOfDay(seconds);
    _controller.value = time;
    widget.onChanged?.call(time);
  }

  /// Wheel items for [values], in order, labelled by [label].
  List<GtWheelScrollData<int>> _items(
    Iterable<int> values,
    String Function(int value) label,
  ) {
    final list = values.toList();
    return [
      for (int i = 0; i < list.length; i++)
        GtWheelScrollData(data: list[i], label: label(list[i]), index: i),
    ];
  }

  /// The values from [first] to [last], [step] apart.
  Iterable<int> _range(int first, int last, [int step = 1]) sync* {
    for (int value = first; value <= last; value += step) {
      yield value;
    }
  }

  /// [value] as two digits.
  static String _pad(int value) => value.toString().padLeft(2, '0');

  /// The hours the wheel offers, in the shown time's half of the day for a
  /// 12-hour pattern. Each item's data is the hour in 24-hour form.
  List<GtWheelScrollData<int>> _hoursFor(int shown, int first, int last) {
    final pattern = _pattern;
    int from = first ~/ _hour;
    int to = last ~/ _hour;
    if (pattern.is12Hour) {
      final noon = shown ~/ _hour >= 12 ? 12 : 0;
      if (from < noon) from = noon;
      if (to > noon + 11) to = noon + 11;
    }
    return _items(
      _range(from, to),
      (hour) => GtTimeValue(hour: hour).format(pattern.hourToken),
    );
  }

  /// The minutes the wheel offers in [hour].
  List<GtWheelScrollData<int>> _minutesFor(int hour, int first, int last) {
    final from = hour == first ~/ _hour ? first % _hour ~/ _minute : 0;
    final to = hour == last ~/ _hour ? last % _hour ~/ _minute : _lastMinute;
    return _items(_range(from, to, _minuteStep), _pad);
  }

  /// The seconds the wheel offers in [minute] of [hour].
  List<GtWheelScrollData<int>> _secondsFor(
    int hour,
    int minute,
    int first,
    int last,
  ) {
    final start = hour * _hour + minute * _minute;
    final from = start == first - first % _minute ? first % _minute : 0;
    final to = start == last - last % _minute ? last % _minute : _lastSecond;
    return _items(_range(from, to, _secondStep), _pad);
  }

  /// The halves of the day the period wheel offers: 0 for AM, 12 for PM.
  List<GtWheelScrollData<int>> _periodsFor(int first, int last) {
    return _items([
      if (first ~/ _hour < 12) 0,
      if (last ~/ _hour >= 12) 12,
    ], (noon) => GtTimeValue(hour: noon).format('a'));
  }

  /// The label of [field]'s wheel.
  String _labelOf(GtTimeWheelField field) {
    return switch (field) {
      .hour => widget.hourLabel ?? "hour".ctr(),
      .minute => widget.minuteLabel ?? "minute".ctr(),
      .second => widget.secondLabel ?? "second".ctr(),
      .period =>
        widget.periodLabel ??
            [
              0,
              12,
            ].map((noon) => GtTimeValue(hour: noon).format('a')).join('/'),
    };
  }

  /// Builds the wheel that edits the [field] part of the time [shown]
  /// seconds after midnight.
  Widget _buildWheel(
    GtTimeWheelField field,
    int shown, {
    required int first,
    required int last,
    required bool hasSlots,
  }) {
    final hour = shown ~/ _hour;
    final minute = shown % _hour ~/ _minute;
    final second = shown % _minute;

    final items = switch (field) {
      .hour => _hoursFor(shown, first, last),
      .minute => _minutesFor(hour, first, last),
      .second => _secondsFor(hour, minute, first, last),
      .period => _periodsFor(first, last),
    };
    final value = switch (field) {
      .hour => hour,
      .minute => minute,
      .second => second,
      .period => hour >= 12 ? 12 : 0,
    };
    final label = _labelOf(field);

    String? header;
    if (widget.showLabels) {
      header = label;
    }

    return GtWheelScroll<int>(
      key: ValueKey("gt_time_wheel_scroll_${field.name}"),
      items: items,
      value: value,
      label: header,
      semanticsLabel: label,
      size: widget.size,
      isEnabled: widget.isEnabled && hasSlots,
      selectedStyle: widget.selectedStyle,
      itemStyle: widget.itemStyle,
      labelStyle: widget.labelStyle,
      selectedDecoration: widget.selectedDecoration,
      fadeGradient: widget.fadeGradient,
      onChanged: (item) {
        final picked = switch (field) {
          .hour => item.data * _hour + minute * _minute + second,
          .minute => hour * _hour + item.data * _minute + second,
          .second => hour * _hour + minute * _minute + item.data,
          .period =>
            (hour % 12 + item.data) * _hour + minute * _minute + second,
        };
        _select(_clamp(picked));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericListener(
      valueListenable: _controller,
      builder: (value) {
        final shown = _shownTime(value);
        final ceiled = _first;
        final last = _last;
        final hasSlots = ceiled != null && ceiled <= last;
        // Without a step in range, the wheels show the shown time alone.
        final first = hasSlots ? ceiled : shown;

        return GtWheelScrollGroup(
          color: widget.backgroundColor,
          padding: widget.padding,
          maxWheelWidth: widget.maxWheelWidth,
          children: [
            for (final field in _pattern.fields)
              _buildWheel(
                field,
                shown,
                first: first,
                last: hasSlots ? last : shown,
                hasSlots: hasSlots,
              ),
          ],
        );
      },
    );
  }
}
