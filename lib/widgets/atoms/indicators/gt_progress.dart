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

  /// An accessible name describing what is progressing.
  ///
  /// Without it the bar is announced as a bare percentage, which tells the user
  /// how far along something is but not what.
  final String? semanticsLabel;

  /// Creates a new [GtProgress].
  const GtProgress({
    this.color,
    this.inactiveColor,
    this.size,
    super.key,
    this.value,
    this.semanticsLabel,
  });

  /// The progress spoken to assistive technologies, as a percentage of 100.
  ///
  /// Null while indeterminate, so that screen readers announce the bar as busy
  /// rather than claiming a position it does not have.
  ///
  /// Deliberately a bare number: the node carries a progress-bar role, and the
  /// framework asserts that its value parses as a number against the 0-100
  /// range. A "45%" string fails that check, and the platform adds the unit
  /// itself when speaking.
  String? get semanticsValue {
    final value = this.value;
    if (value == null) return null;
    return '${(value.clamp(0, 1) * 100).round()}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return RepaintBoundary(
      child: SizedBox(
        height: size ?? context.dp(6.px),
        child: LinearProgressIndicator(
          borderRadius: 999.circularBorderRadius,
          valueColor: AlwaysStoppedAnimation(color ?? palette.primary.base),
          backgroundColor: inactiveColor ?? palette.bg.soft,
          value: value,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        ),
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

  /// An accessible name describing what this slider adjusts.
  ///
  /// The adaptive slider announces its own value and exposes increment and
  /// decrement actions, but nothing names the control.
  final String? semanticsLabel;

  /// Creates a new [GtSlider].
  const GtSlider({
    this.color,
    this.onChanged,
    super.key,
    this.value,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final activeColor = color ?? palette.primary.base;
    final inactiveColor = palette.bg.sub;

    return RepaintBoundary(
      child: GtSemantics(
        // Slider owns its value and its enabled state; this only names it.
        role: .delegated,
        label: semanticsLabel,
        // A focusable child does not fold into an enclosing annotation on its
        // own, so the name and the slider would otherwise be two stops.
        mergeDescendants: semanticsLabel != null,
        child: Slider.adaptive(
          value: value ?? 0,
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          thumbColor: activeColor,
        ),
      ),
    );
  }
}

/// A progress indicator that smoothly animates towards its value.
///
/// The bar fills from 0 to [value] on first build and animates on from wherever
/// it currently sits whenever [value] changes, so callers update the value in
/// place rather than re-keying the widget to force a fresh fill. It also
/// supports an optional [isBuffering] state to display an underlying
/// indeterminate animation.
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

  /// Optional [onCompleted] callback.
  final OnPressed? onDone;

  /// Creates a new [GtAnimatedProgress].
  const GtAnimatedProgress({
    required this.value,
    this.duration,
    this.valueColor,
    this.isBuffering = false,
    this.width,
    this.height,
    this.inActiveColor,
    this.onDone,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _GtAnimatedProgressState();
  }
}

class _GtAnimatedProgressState extends State<GtAnimatedProgress>
    with SingleTickerProviderStateMixin {
  static const _defaultDuration = Duration(milliseconds: 300);

  late final AnimationController _ctrl;

  /// The fill currently painted, tweened from where the bar was to [_target].
  late Animation<double> _progress;

  double get _target => widget.value.clamp(0, 1);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: widget.duration ?? _defaultDuration,
      vsync: this,
    );
    _progress = _tween(from: 0);
    _ctrl.addListener(_progressListener);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant GtAnimatedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _ctrl.duration = widget.duration ?? _defaultDuration;
    }

    if (widget.value == oldWidget.value) return;

    // Pick up from the painted fill rather than from zero: the value moves
    // while the bar is on screen, and restarting the sweep would read as the
    // progress dropping back before catching up.
    _progress = _tween(from: _progress.value);
    _ctrl.forward(from: 0);
  }

  /// A linear sweep from [from] to the current [_target].
  Animation<double> _tween({required double from}) {
    return _ctrl.drive(Tween<double>(begin: from, end: _target));
  }

  void _progressListener() {
    if (_progress.value < 1) return;
    widget.onDone?.call();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_progressListener);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueColor = widget.valueColor ?? palette.primary.base;
    final trackColor = palette.bg.soft;
    final borderRadius = 999.circularBorderRadius;
    final height = widget.height ?? context.dp(6.px);

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: height,
          width: widget.width ?? double.infinity,
        ),
        child: AnimatedBuilder(
          animation: _progress,
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
                      size: height,
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      foregroundPainter: GtProgressPainter(
                        borderRadius: 999.radius,
                        color: valueColor,
                        value: _progress.value,
                        height: height,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
