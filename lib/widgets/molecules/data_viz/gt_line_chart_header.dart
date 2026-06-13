import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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
