import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A circular countdown indicator that acts as a shrinking pie chart.
///
/// This widget smoothly animates a pie chart shrinking over a specified [duration],
/// displaying the remaining seconds in the center.
class GtCountdownPie extends GtStatefulWidget {
  /// The total duration of the countdown.
  ///
  /// Defaults to 1 minute (60 seconds) if not provided.
  final Duration? duration;

  /// The background color for the pie chart track.
  ///
  /// Defaults to a light success color from the current palette if not specified.
  final Color? trackColor;

  /// The primary color used for the remaining countdown value slice.
  ///
  /// Defaults to the base success color from the current palette.
  final Color? color;

  /// The thickness of the circular progress indicator.
  ///
  /// Defaults to 4.0.
  final double strokeWidth;

  /// The bounding size (width and height) of the countdown widget.
  ///
  /// Defaults to 52.0.
  final double size;

  /// Creates a new [GtCountdownPie].
  const GtCountdownPie({
    this.trackColor,
    this.color,
    this.strokeWidth = 4.0,
    this.size = 52,
    this.duration,
    super.key,
  });

  @override
  State<GtCountdownPie> createState() => _GtCountdownPieState();
}

class _GtCountdownPieState extends State<GtCountdownPie>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration ?? 1.minutes;
    _ctrl = AnimationController(
      duration: _duration,
      lowerBound: 0,
      upperBound: _seconds,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double get _seconds => _duration.inSeconds.toDouble();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final trackColor = widget.trackColor ?? palette.success.light;
    final color = widget.color ?? palette.success.base;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          double fraction = 1 - (_ctrl.value / _seconds).clamp(0, 1);
          final count = (_seconds - _ctrl.value.round()).toStringAsFixed(0);

          return GtSquareBox(
            size: widget.size,
            child: CustomPaint(
              painter: GtPiePainter(
                value: fraction,
                strokeWidth: widget.strokeWidth,
                trackColor: trackColor,
                clockWise: true,
                valueColor: color,
                strokeCap: StrokeCap.round,
              ),
              child: Center(
                child: FittedBox(
                  child: GtText(
                    count,
                    style: context.textStyles.h6(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
