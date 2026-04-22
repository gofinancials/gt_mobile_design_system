import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A versatile spinner that either animates indefinitely or acts as a pie chart.
///
/// When [value] is null, this widget displays a continuous spinning animation.
/// When [value] is provided, it smoothly animates to display a pie chart representing
/// the given progress.
class GtSpinner extends GtStatefulWidget {
  /// The progress value of the spinner, ranging from 0.0 to 1.0.
  ///
  /// If null, the widget acts as an indeterminate spinner and animates indefinitely.
  /// If provided, it paints a determinate pie chart based on the value.
  final double? value;

  /// The background color for the pie chart track when [value] is provided.
  ///
  /// Defaults to [color] with 10% opacity if not specified.
  final Color? trackColor;

  /// The primary color used for the spinner or pie chart value.
  ///
  /// Defaults to the strong text color from the current palette.
  final Color? color;

  /// The thickness of the spinning circular progress indicator.
  final double strokeWidth;

  /// The bounding size (width and height) of the spinner.
  final double size;

  /// The position of the spinner on the cartesian plane.
  ///
  /// Defaults to [Alignment.center].
  final Alignment alignment;

  /// Creates a new [GtSpinner].
  const GtSpinner({
    this.value,
    this.trackColor,
    this.color,
    this.strokeWidth = 4.0,
    this.size = 22,
    super.key,
    this.alignment = .center,
  });

  @override
  State<GtSpinner> createState() => _GtSpinnerState();
}

class _GtSpinnerState extends State<GtSpinner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final trackColor = widget.trackColor;
    final color = widget.color ?? palette.text.strong;

    return Align(
      alignment: widget.alignment,
      child: RepaintBoundary(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Builder(
            builder: (context) {
              if (widget.value == null) {
                return RepeatingAnimationBuilder(
                  animatable: Tween<double>(begin: 0.0, end: 360),
                  duration: 1.seconds,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * math.pi / 180,
                      child: child,
                    );
                  },
                  child: CustomPaint(
                    painter: GtCircularProgressPainter(
                      color: color,
                      strokeWidth: widget.strokeWidth,
                    ),
                  ),
                );
              }
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: widget.value),
                duration: 1.seconds,
                builder: (context, value, child) {
                  return CustomPaint(
                    painter: GtPiePainter(
                      value: value,
                      strokeWidth: widget.strokeWidth,
                      trackColor: trackColor ?? color.setOpacity(0.1),
                      valueColor: color,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
