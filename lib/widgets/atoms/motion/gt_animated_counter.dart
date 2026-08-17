import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

typedef GtCounterFormatter = String Function(num value);

/// Animates changed numeric characters vertically like an odometer.
class GtAnimatedCounter extends GtStatefulWidget {
  final num value;
  final GtCounterFormatter? formatter;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration duration;
  final Curve curve;

  const GtAnimatedCounter({
    super.key,
    required this.value,
    this.formatter,
    this.style,
    this.textAlign = TextAlign.start,
    this.duration = GtMotion.normal,
    this.curve = GtSpringCurves.gentle,
  });

  @override
  State<GtAnimatedCounter> createState() => _GtAnimatedCounterState();
}

class _GtAnimatedCounterState extends State<GtAnimatedCounter> {
  late num _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant GtAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousValue = oldWidget.value;
  }

  String _format(num value) => widget.formatter?.call(value) ?? '$value';

  @override
  Widget build(BuildContext context) {
    final value = _format(widget.value);
    final direction = widget.value >= _previousValue ? 1.0 : -1.0;
    final duration = GtMotion.adaptiveDuration(context, widget.duration);

    return Semantics(
      label: value,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: .min,
        mainAxisAlignment: switch (widget.textAlign) {
          TextAlign.center => MainAxisAlignment.center,
          TextAlign.end || TextAlign.right => MainAxisAlignment.end,
          _ => MainAxisAlignment.start,
        },
        children: [
          for (final (index, character) in value.characters.indexed)
            ClipRect(
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: widget.curve,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == ValueKey('$index-$character');
                  final begin = Offset(0, isIncoming ? direction : -direction);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: begin,
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: GtText(
                  character,
                  key: ValueKey('$index-$character'),
                  style: widget.style ?? context.textStyles.h4(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
