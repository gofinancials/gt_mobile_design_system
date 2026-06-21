import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays an interactive line chart area.
///
/// It renders a customizable trend line based on the provided [items], supports
/// optional line gradient fills, and includes an interactive tooltip
/// that appears when the user taps, hovers, or drags across the chart area.
class GtLineChartArea extends StatefulWidget {
  /// The primary color of the line chart stroke.
  final Color color;

  /// The width of the chart area.
  ///
  /// If null, it expands to fill the available horizontal space.
  final double? width;

  /// The fixed height of the chart area.
  ///
  /// Defaults to 165.0.
  final double height;

  /// An optional linear gradient applied to fill the area beneath the chart line.
  final LinearGradient? gradient;

  /// The list of data points to plot on the chart.
  final List<GtLineChartItem> items;

  /// The maximum value of the y-axis. If null, it will be calculated from the data.
  final num? max;

  /// The minimum value of the y-axis. If null, it will be calculated from the data.
  final num? min;

  /// Controls the visibility of the Y-axis labels.
  ///
  /// If `true`, the labels will be hidden. Defaults to `false`.
  final bool hideYAxisLabels;

  /// Creates a new [GtLineChartArea].
  ///
  /// The [items] and [color] parameters must not be null.
  const GtLineChartArea(
    this.items, {
    super.key,
    this.width,
    this.height = 165,
    this.gradient,
    required this.color,
    this.max,
    this.min,
    this.hideYAxisLabels = false,
  });

  @override
  State createState() => _GtLineChartAreaState();
}

class _GtLineChartAreaState extends State<GtLineChartArea> {
  late final List<num> values;
  late ValueNotifier<int?> _selectedIndex;

  late final num _max;
  late final num _min;

  @override
  void initState() {
    super.initState();
    values = widget.items.mapList((it) => it.value);

    final sortedItems = [...values];
    sortedItems.sort();
    _max = math.max(widget.max ?? 0, sortedItems.last);
    _min = math.min(widget.min ?? 0, sortedItems.first);
    _selectedIndex = ValueNotifier(null);
  }

  /// Updates the selected index based on the horizontal position.
  void _updateIndex(double dx, double width) {
    if (!values.hasValue) return;
    double segmentWidth = width / (values.length - 1);

    final index = (dx / segmentWidth).round().clamp(0, values.length - 1);

    _selectedIndex.value = index;
  }

  /// Clears the currently selected data point, hiding the tooltip.
  void _clearSelection() {
    _selectedIndex.value = null;
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final yTextStyle = context.textStyles.chartYtick(
      color: context.palette.text.sub,
    );
    final yMax = _max.asCurrencyShort("");
    final yMin = _min.asCurrencyShort("");

    return GtSizedBox(
      height: widget.height,
      width: widget.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return GestureDetector(
            onTapDown: (details) {
              _updateIndex(details.localPosition.dx, maxWidth);
            },
            onPanStart: (details) {
              _updateIndex(details.localPosition.dx, maxWidth);
            },
            onPanUpdate: (details) {
              _updateIndex(details.localPosition.dx, maxWidth);
            },
            onPanEnd: (_) => _clearSelection(),
            onPanCancel: _clearSelection,
            child: MouseRegion(
              onHover: (event) {
                _updateIndex(event.localPosition.dx, maxWidth);
              },
              onExit: (_) => _clearSelection(),
              child: NumberListener(
                valueListenable: _selectedIndex,
                builder: (index) {
                  return CustomPaint(
                    painter: GtTrendPainter(
                      values,
                      color: widget.color,
                      gradient:
                          widget.gradient ?? context.gradients.chartGradient,
                      maxValue: _max,
                      selectedIndex: index,
                      selectedFillColor: context.palette.bg.weak,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (!widget.hideYAxisLabels) ...[
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
                        ],
                        if (index != null)
                          _ChartTooltip(
                            item: widget.items.elementAtOrNull(index),
                            count: widget.items.length,
                            index: index,
                            maxWidth: maxWidth,
                            maxHeight: constraints.maxHeight,
                            max: _max,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// An internal widget that displays a tooltip for a specific chart data point.
///
/// It positions itself based on the [index] and the data [item]'s value relative
/// to the chart's [maxWidth] and [maxHeight].
class _ChartTooltip extends GtStatelessWidget {
  /// The data item to display in the tooltip.
  final GtLineChartItem? item;

  /// The index of the selected data point.
  final int index;

  /// The total number of data points in the chart.
  final int count;

  /// The maximum value across all data points, used for calculating vertical position.
  final num max;

  /// The maximum available width for the chart area.
  final double maxWidth;

  /// The maximum available height for the chart area.
  final double maxHeight;

  /// Creates a new [_ChartTooltip].
  const _ChartTooltip({
    required this.item,
    required this.max,
    required this.count,
    required this.index,
    required this.maxWidth,
    required this.maxHeight,
  });

  /// Retrieves the formatted string value to display within the tooltip.
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
