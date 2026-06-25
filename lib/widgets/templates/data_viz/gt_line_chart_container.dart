import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays an interactive line chart within a styled container.
///
/// It renders a customizable trend line using the provided [items] and supports
/// gradient fills. The container also includes a header displaying a [title],
/// the aggregated total of the data points, and an interactive date range selector
/// that opens a calendar modal.
class GtLineChartContainer extends GtStatelessWidget with GtBottomSheetMixin {
  /// The main title displayed in the chart header (e.g., "Total Spending").
  final String title;

  /// The title used for the calendar selection modal (e.g., "Select Date Range").
  final String calendarTitle;

  /// The primary color of the line chart stroke and UI accents.
  final Color color;

  /// An optional linear gradient applied to fill the area beneath the chart line.
  final LinearGradient? gradient;

  /// The controller managing the calendar's date range state and selection.
  final GtCalendarController controller;

  /// The list of data points to plot on the line chart.
  final List<GtLineChartItem> items;

  /// The maximum Y-axis value for the chart.
  ///
  /// If null, the chart automatically scales to the highest value found in [items].
  final double? maxValue;

  /// A callback invoked when the user selects a new date range from the calendar modal.
  final OnChanged<DateTimeRange> onRangeUpdate;

  /// An optional formatter to customize how the total aggregated sum is displayed.
  ///
  /// If null, the sum is formatted as currency by default.
  final TransformCall<String>? sumFormatter;

  /// The fixed width of the chart container.
  ///
  /// If null, it expands to fill the available horizontal space.
  final double? width;

  /// The fixed height of the chart area.
  ///
  /// Defaults to 165.0.
  final double height;

  /// Controls the visibility of the Y-axis labels.
  ///
  /// If `true`, the labels will be hidden. Defaults to `false`.
  final bool hideYAxisLabels;

  /// Creates a new [GtLineChartContainer].
  ///
  /// The [items], [calendarTitle], [title], [color], [controller], and
  /// [onRangeUpdate] parameters must not be null.
  const GtLineChartContainer({
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
    this.width,
    this.height = 165,
    this.hideYAxisLabels = false,
  });

  /// Retrieves the currently selected date range from the [controller].
  ///
  /// If the controller's range is null, it defaults to the past 28 days ending today.
  DateTimeRange get range {
    final defaultRange = DateTimeRange<DateTime>(
      start: .now().subtract(28.days),
      end: .now(),
    );
    return controller.range ?? defaultRange;
  }

  /// Formats the selected date range for display in the header text.
  String get _formattedRange {
    final start = range.start;
    final end = range.end;

    if (start.isSameDay(end)) {
      return range.formattedDateRange("hh:mm");
    }

    return range.formattedDateRange("dd MMM");
  }

  /// Formats the selected date range for display within the calendar action button.
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

  /// Displays the calendar bottom sheet modal for date range selection.
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

  /// Calculates the total sum of all data points and formats it for display.
  String get _sum {
    final num sum = items.fold(0, (acc, item) => acc + item.value);
    if (sumFormatter != null) return sumFormatter!(sum);
    return sum.asCurrency();
  }

  @override
  Widget build(BuildContext context) {
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
              value: _sum,
              range: _formattedRange,
              actionText: _formattedBtnRange,
              isSameDay: range.start.isSameDay(range.end),
              onTapAction: () => _showCalendar(context),
            ),
            GtLineChartArea(
              items,
              width: width,
              height: height,
              color: color,
              gradient: gradient,
              max: maxValue,
              hideYAxisLabels: hideYAxisLabels,
              key: ValueKey(
                Object.hash(items, width, height, color, gradient, maxValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
