import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Adds tactile press feedback without participating in the gesture arena.
class GtPressable extends GtStatefulWidget {
  final Widget child;
  final bool enabled;
  final double pressedScale;
  final Duration duration;
  final Curve releaseCurve;
  final HapticFeedbackType? hapticFeedbackType;

  const GtPressable({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = GtMotion.buttonPressScale,
    this.duration = GtMotion.fast,
    this.releaseCurve = GtSpringCurves.bouncy,
    this.hapticFeedbackType,
  }) : assert(pressedScale > 0 && pressedScale <= 1);

  @override
  State<GtPressable> createState() => _GtPressableState();
}

class _GtPressableState extends State<GtPressable> {
  final ValueNotifier<bool> _pressed = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _pressed.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (!widget.enabled || _pressed.value == value) return;
    _pressed.value = value;
    if (value && widget.hapticFeedbackType != null) {
      triggerHaptic(widget.hapticFeedbackType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: BoolListener(
        valueListenable: _pressed,
        builder: (isPressed) {
          final canScale = (widget.enabled && !reduceMotion && isPressed);
          final scale = canScale ? widget.pressedScale : 1.0;

          return AnimatedScale(
            scale: scale,
            duration: GtMotion.adaptiveDuration(context, widget.duration),
            curve: isPressed ? GtSpringCurves.interactive : widget.releaseCurve,
            child: widget.child,
          );
        },
      ),
    );
  }
}
