import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Represents a single data point in a [GtLineChart].
class GtLineChartItem extends AppEquatable {
  /// An optional label for the data point.
  final String? label;

  /// The date and time associated with this data point.
  final DateTime date;

  /// The numerical value of this data point.
  final num value;

  /// An optional formatter function to convert the value into a custom string representation.
  final TransformCall<String>? formatter;

  /// Creates a new [GtLineChartItem].
  const GtLineChartItem(
    this.value, {
    required this.date,
    this.label,
    this.formatter,
  });

  @override
  List<Object?> get props => [date, value, label];
}

/// A widget that displays an interactive line chart over a given date range.
///
/// It renders a customizable trend line using [items], supports gradient fills,
/// and includes an interactive tooltip when hovering or dragging across the chart.
class GtLineChart extends GtStatelessWidget with GtBottomSheetMixin {
  /// The main title displayed in the chart header.
  final String title;

  /// The title used for the calendar selection modal.
  final String calendarTitle;

  /// The primary color of the line chart stroke.
  final Color color;

  /// An optional linear gradient applied to the chart line.
  final LinearGradient? gradient;

  /// The controller managing the calendar's date range state.
  final GtCalendarController controller;

  /// The list of data points to plot on the chart.
  final List<GtLineChartItem> items;

  /// The optional maximum Y-axis value. If null, it defaults to the highest value in [items].
  final double? maxValue;

  /// A callback invoked when the user selects a new date range from the calendar modal.
  final OnChanged<DateTimeRange> onRangeUpdate;

  /// An optional formatter to customize the display of the total aggregated sum.
  final TransformCall<String>? sumFormatter;

  /// Creates a new [GtLineChart].
  const GtLineChart({
    super.key,
    required this.items,
    required this.calendarTitle,
    required this.title,
    required this.color,
    required this.controller,
    this.maxValue,
    required this.onRangeUpdate,
    this.sumFormatter,
    this.gradient,
  });

  DateTimeRange get range {
    final defaultRange = DateTimeRange<DateTime>(
      start: .now().subtract(28.days),
      end: .now(),
    );
    return controller.range ?? defaultRange;
  }

  String get _formattedRange {
    final start = range.start;
    final end = range.end;

    if (start.isSameDay(end)) {
      return range.formattedDateRange("hh:mm");
    }

    return range.formattedDateRange("dd MMM");
  }

  String get _formattedBtnRange {
    final start = range.start;
    final end = range.end;

    if (start.isSameDay(end)) {
      return range.formattedDateRange("hh:mm");
    }

    if (start.isSameMonth(end) && range.duration.inDays >= 28) {
      return start.format("MMMM");
    }

    return range.formattedDateRange("dd/MM/yyyy");
  }

  String getFormattedSum(double sum) {
    if (sumFormatter != null) {
      return sumFormatter!(sum);
    }
    return sum.asCurrency();
  }

  void _showCalendar(BuildContext context) {
    showDraggableSheet(
      context,
      builder: (scrollController) => GtCalendarModal(
        scrollController,
        controller: controller,
        title: calendarTitle,
        selectionMode: .range,
        onSelectRange: (range) {
          onRangeUpdate(range);
          AppDebouncer(500.milliseconds).run(context.pop);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items];
    sortedItems.sort((a, b) => a.value.compareTo(b.value));
    final values = items.mapList((it) => it.value);
    final max = maxValue ?? sortedItems.last.value;
    final min = math.min(0, sortedItems.first.value);
    final sum = getFormattedSum(values.fold(0.0, (acc, item) => (acc + item)));

    return RepaintBoundary(
      child: GtCard(
        borderRadius: context.borderRadius3Xl,
        padding: context.insets.fromLTRBDp(12.px, 16.px, 12.px, 20.px),
        child: Column(
          spacing: context.spacingMd,
          mainAxisAlignment: .center,
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            GtLineChartHeader(
              title: title,
              value: sum,
              range: _formattedRange,
              actionText: _formattedBtnRange,
              isSameDay: range.start.isSameDay(range.end),
              onTapAction: () => _showCalendar(context),
            ),

            GtSizedBox(
              height: 165,
              child: _GtInteractiveLineChartArea(
                items: items,
                values: values,
                color: color,
                gradient: gradient,
                max: max,
                min: min,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The header section of the [GtLineChart].
///
/// Displays the [title], the aggregated [value], the selected [range],
/// and a button to trigger the calendar modal.
class GtLineChartHeader extends GtStatelessWidget {
  /// The title of the chart.
  final String title;

  /// The formatted aggregated sum of the chart's data points.
  final String value;

  /// The formatted string representation of the current date range.
  final String? range;

  /// The text displayed inside the calendar action button.
  final String actionText;

  /// Whether the current date range spans only a single day.
  final bool isSameDay;

  /// The callback invoked when the calendar action button is tapped.
  final OnPressed onTapAction;

  /// Creates a new [GtLineChartHeader].
  const GtLineChartHeader({
    super.key,
    required this.title,
    required this.value,
    this.range,
    required this.actionText,
    this.isSameDay = false,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final palette = context.palette;

    return Row(
      crossAxisAlignment: .start,
      spacing: context.spacingBase,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              GtText(
                title.upper,
                style: styles.buttonXs(color: palette.text.sub),
              ),
              const GtGap.ySm(),
              GtText(value, style: styles.h5()),
              if (range.hasValue) ...[
                const GtGap.yBase(),
                Text.rich(
                  TextSpan(
                    style: styles.buttonXs(color: palette.text.soft),
                    children: [
                      WidgetSpan(
                        child: GtIcon(
                          isSameDay ? GtIcons.clock : GtIcons.calendar,
                          size: 14,
                          variant: .soft,
                        ),
                        alignment: .middle,
                      ),
                      const WidgetSpan(child: GtGap.hSm()),
                      TextSpan(text: range?.upper),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        GtRaisedButton(
          onPressed: onTapAction,
          text: actionText,
          trailing: GtIcons.chevronDown,
          color: palette.bg.soft,
          textColor: palette.text.strong,
          variant: .black,
          size: .pill,
          alignment: .topRight,
        ),
      ],
    );
  }
}

class _GtInteractiveLineChartArea extends StatefulWidget {
  final List<GtLineChartItem> items;
  final List<num> values;
  final Color color;
  final LinearGradient? gradient;
  final num max;
  final num min;

  const _GtInteractiveLineChartArea({
    required this.items,
    required this.values,
    required this.color,
    this.gradient,
    required this.max,
    required this.min,
  });

  @override
  State<_GtInteractiveLineChartArea> createState() =>
      _GtInteractiveLineChartAreaState();
}

class _GtInteractiveLineChartAreaState
    extends State<_GtInteractiveLineChartArea> {
  int? _selectedIndex;

  void _handlePan(double dx, double width) {
    if (!widget.values.hasValue) return;
    double segmentWidth = width / (widget.values.length - 1);

    final index = (dx / segmentWidth).round().clamp(
      0,
      widget.values.length - 1,
    );
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  void _clearSelection() {
    if (_selectedIndex == null) return;
    setState(() => _selectedIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final yTextStyle = context.textStyles.chartYtick(
      color: context.palette.text.sub,
    );
    final yMax = widget.max.asCurrencyShort("");
    final yMin = widget.min.asCurrencyShort("");

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return GestureDetector(
          onTapDown: (details) {
            _handlePan(details.localPosition.dx, maxWidth);
          },
          onPanStart: (details) {
            _handlePan(details.localPosition.dx, maxWidth);
          },
          onPanUpdate: (details) {
            _handlePan(details.localPosition.dx, maxWidth);
          },
          onPanEnd: (_) => _clearSelection(),
          onPanCancel: _clearSelection,
          child: CustomPaint(
            painter: GtTrendPainter(
              widget.values,
              color: widget.color,
              gradient: widget.gradient,
              maxValue: widget.max,
              selectedIndex: _selectedIndex,
              selectedFillColor: context.palette.bg.weak,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: GtText(yMax, style: yTextStyle),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GtText(yMin, style: yTextStyle),
                ),
                if (_selectedIndex != null)
                  _ChartTooltip(
                    item: widget.items.elementAtOrNull(_selectedIndex!),
                    count: widget.items.length,
                    index: _selectedIndex!,
                    maxWidth: maxWidth,
                    maxHeight: constraints.maxHeight,
                    max: widget.max,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChartTooltip extends GtStatelessWidget {
  final GtLineChartItem? item;
  final int index;
  final int count;
  final num max;
  final double maxWidth;
  final double maxHeight;

  const _ChartTooltip({
    required this.item,
    required this.max,
    required this.count,
    required this.index,
    required this.maxWidth,
    required this.maxHeight,
  });

  String? get formattedValue {
    if (item?.formatter != null) {
      return item?.formatter?.call(item!.value.toString());
    }
    return item?.value.asCurrencyShort("N");
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) return const Offstage();

    final segmentWidth = count > 1 ? maxWidth / (count - 1) : maxWidth;
    final x = segmentWidth * index;

    final tooltipWidth = context.dp(36.px);
    final leftPos = (x - tooltipWidth / 2).clamp(0.0, maxWidth - tooltipWidth);
    final topPos = maxHeight * (1 - (item!.value / max));

    return Positioned(
      left: leftPos,
      top: topPos + context.dp(8.px),
      child: GtPill(
        text: formattedValue.value,
        variant: .strong,
        bgColor: context.palette.bg.strong,
        textColor: context.palette.text.white,
        padding: context.insets.allDp(4.px),
      ),
    );
  }
}
