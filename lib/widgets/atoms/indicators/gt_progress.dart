import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A linear progress indicator for the Go Tech design system.
///
/// If [value] is null, this widget displays an indeterminate progress animation.
/// Otherwise, it displays a determinate progress bar filling up to [value].
class GtProgress extends GtStatelessWidget {
  /// The color of the active progress indicator. Defaults to the primary base color.
  final Color? color;

  /// The background color of the progress track. Defaults to a soft background color.
  final Color? inactiveColor;

  /// The height of the progress bar. Defaults to 4dp.
  final double? size;

  /// The current progress value, from 0.0 to 1.0. If null, the indicator is indeterminate.
  final double? value;

  /// The border radius of the progress bar track and indicator. Defaults to [BorderRadius.zero].
  final BorderRadius borderRadius;

  /// Creates a new [GtProgress].
  const GtProgress({
    this.color,
    this.inactiveColor,
    this.size,
    this.borderRadius = BorderRadius.zero,
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: size ?? context.dp(4.px),
      child: LinearProgressIndicator(
        borderRadius: borderRadius,
        valueColor: AlwaysStoppedAnimation(color ?? palette.primary.base),
        backgroundColor: inactiveColor ?? palette.bg.soft,
        value: value,
      ),
    );
  }
}

/// An adaptive slider widget for the Go Tech design system.
///
/// Wraps [Slider.adaptive] to provide consistent styling based on the current palette.
class GtSlider extends GtStatelessWidget {
  /// The color of the active track and the thumb. Defaults to the primary base color.
  final Color? color;

  /// The current value of the slider.
  final double? value;

  /// Called when the user is selecting a new value for the slider.
  final OnChanged<double>? onChanged;

  /// Creates a new [GtSlider].
  const GtSlider({this.color, this.onChanged, super.key, this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final activeColor = color ?? palette.primary.base;
    final inactiveColor = palette.bg.sub;

    return Slider.adaptive(
      value: value ?? 0,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: activeColor,
    );
  }
}

/// A progress indicator that smoothly animates its value upon initialization.
///
/// This widget animates from 0 to the target [value]. It also supports an optional
/// [isBuffering] state to display an underlying indeterminate animation.
class GtAnimatedProgress extends StatefulWidget {
  /// The target progress value to animate towards, from 0.0 to 1.0.
  final double value;

  /// The total width of the progress bar. Defaults to [double.infinity].
  final double? width;

  /// The height of the progress bar. Defaults to 4dp.
  final double? height;

  /// The duration of the fill animation. Defaults to 300 milliseconds.
  final Duration? duration;

  /// The color of the active progress portion. Defaults to the primary base color.
  final Color? valueColor;

  /// The background color of the track.
  final Color? inActiveColor;

  /// Whether to show an underlying indeterminate buffering animation.
  final bool isBuffering;

  /// The border radius for the progress bar. Defaults to a fully rounded pill shape.
  final BorderRadius? borderRadius;

  /// Creates a new [GtAnimatedProgress].
  const GtAnimatedProgress({
    required this.value,
    this.duration,
    this.valueColor,
    this.borderRadius,
    this.isBuffering = false,
    this.width,
    this.height,
    this.inActiveColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _GtAnimatedProgressState();
  }
}

class _GtAnimatedProgressState extends State<GtAnimatedProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: widget.duration ?? 300.milliseconds,
      lowerBound: 0,
      upperBound: widget.value > 0 ? widget.value : 0.000001,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueColor = widget.valueColor ?? palette.primary.base;
    final trackColor = palette.bg.soft;
    final borderRadius = widget.borderRadius ?? 999.circularBorderRadius;
    final height = widget.height ?? context.dp(4.px);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: height,
        width: widget.width ?? double.infinity,
      ),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GtProgress(
                    value: widget.isBuffering ? null : 0,
                    color: valueColor.setOpacity(.2),
                    inactiveColor: trackColor,
                    borderRadius: borderRadius,
                    size: height,
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    foregroundPainter: GtProgressPainter(
                      borderRadius: widget.borderRadius?.bottomLeft,
                      color: valueColor,
                      value: _ctrl.value,
                      height: height,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
