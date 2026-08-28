import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays an animated semicircular gauge chart.
///
/// It visually represents a [value] between 0.0 and 1.0 using a [GtArcPainter].
/// Optional [center] content can be provided to display information inside the gauge.
class GtGuageChart extends GtStatelessWidget {
  /// The fill percentage of the gauge, bounded between 0.0 and 1.0.
  final double value;

  /// The optional height of the chart. Defaults to 188px.
  final double? height;

  /// The optional width of the chart.
  final double? width;

  /// The widget displayed at the center of the gauge, typically a [GtGuageChartCenter].
  final GtGuageChartCenter? center;

  /// The color of the background track arc. If null, it defaults to the [variant]'s background color.
  final Color? trackColor;

  /// The color of the foreground value arc. If null, it defaults to the [variant]'s icon color.
  final Color? valueColor;

  /// The thickness of the gauge arc. Defaults to 34.3.
  final double strokeWidth;

  /// The shape of the endpoints of the gauge arc. Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// The variant used to determine the default colors if [trackColor] or [valueColor] are omitted.
  final GtCardVariant variant;

  /// A plain-language summary of what the gauge shows, already localised.
  ///
  /// The gauge is drawn by a [CustomPainter], so it is pure pixels to a screen
  /// reader. Supply a sentence carrying the same information the picture does,
  /// such as "Credit score 720 out of 850, good".
  final String? semanticsLabel;

  /// Creates a new [GtGuageChart].
  ///
  /// The [value] must be between 0.0 and 1.0 inclusive.
  const GtGuageChart({
    this.semanticsLabel,
    required this.value,
    this.height,
    this.width,
    this.center,
    this.trackColor,
    this.valueColor,
    this.strokeWidth = 34.3,
    this.strokeCap = StrokeCap.round,
    this.variant = .primary,
    super.key,
  }) : assert(value >= 0 && value <= 1);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final chartValueColor = valueColor ?? variant.getIconColor(palette);
    final chartTrackColor = trackColor ?? variant.getBgColor(palette);
    final w = width ?? double.infinity;
    final h = height ?? context.dp(188.px);

    return GtSemantics(
      label: semanticsLabel,
      // The painted arc conveys nothing on its own, and the centre widget is
      // a fragment rather than a description. The summary replaces both.
      excludeDescendants: semanticsLabel != null,
      container: semanticsLabel != null,
      child: Container(
        constraints: BoxConstraints.expand(width: w, height: h),
        height: h,
        width: w,
        child: RepaintBoundary(
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: value),
            duration: 1.seconds,
            curve: GtSpringCurves.snappy,
            builder: (_, double animatedValue, _) {
              return CustomPaint(
                painter: GtArcPainter(
                  value: animatedValue,
                  trackColor: chartTrackColor,
                  valueColor: chartValueColor,
                  strokeCap: strokeCap,
                  strokeWidth: strokeWidth,
                ),
                child: Padding(
                  padding: context.insets.onlyDp(top: 40.px),
                  child: FittedBox(fit: .scaleDown, child: center),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
