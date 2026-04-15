import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtProgress extends GtStatelessWidget {
  final Color? color;
  final Color? inactiveColor;
  final double? size;
  final double? value;
  final BorderRadius borderRadius;

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

class GtSlider extends GtStatelessWidget {
  final Color? color;
  final double? value;
  final OnChanged<double>? onChanged;

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

class GtAnimatedProgress extends StatefulWidget {
  final double value;
  final double? width;
  final double? height;
  final Duration? duration;
  final Color? valueColor;
  final Color? inActiveColor;
  final bool isBuffering;
  final BorderRadius? borderRadius;

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
        builder: (_, __) {
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
