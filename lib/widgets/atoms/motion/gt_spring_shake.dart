import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Controller used to trigger a [GtSpringShake].
class GtSpringShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}

/// A controller-driven horizontal shake for validation and warning feedback.
class GtSpringShake extends GtStatefulWidget {
  final Widget child;
  final GtSpringShakeController controller;
  final double distance;
  final Duration duration;

  const GtSpringShake({
    super.key,
    required this.child,
    required this.controller,
    this.distance = 10,
    this.duration = GtMotion.fluid,
  });

  @override
  State<GtSpringShake> createState() => _GtSpringShakeState();
}

class _GtSpringShakeState extends State<GtSpringShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: widget.duration);
    widget.controller.addListener(_shake);
  }

  @override
  void didUpdateWidget(covariant GtSpringShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_shake);
      widget.controller.addListener(_shake);
    }
    _animation.duration = widget.duration;
  }

  void _shake() {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return;
    _animation.forward(from: 0);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_shake);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final t = _animation.value;
        final decay = 1 - t;
        final offset = widget.distance * decay * _wave(t);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
    );
  }

  double _wave(double value) {
    if (value < .2) return value / .2;
    if (value < .4) return 1 - ((value - .2) / .2) * 2;
    if (value < .6) return -1 + ((value - .4) / .2) * 2;
    if (value < .8) return 1 - ((value - .6) / .2) * 2;
    return -1 + ((value - .8) / .2);
  }
}
