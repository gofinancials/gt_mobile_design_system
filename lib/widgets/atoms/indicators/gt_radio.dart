import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtRadio<T> extends GtStatelessWidget {
  final T value;
  final T? groupValue;
  final bool? condition;
  final OnChanged<T> onChanged;
  final Color? activeColor;
  final bool disabled;

  const GtRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.disabled = false,
    this.activeColor,
  }) : condition = null;

  const GtRadio.conditional({
    super.key,
    required this.value,
    required this.condition,
    required this.onChanged,
    this.activeColor,
    this.disabled = false,
  }) : groupValue = null;

  bool get _isActive {
    if (condition != null) {
      return condition!;
    }
    return groupValue == value;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final color = activeColor ?? palette.primary.base;
    final borderColor = _isActive ? color : palette.bg.soft;
    final size = context.dp(20.px);

    return RepaintBoundary(
      child: GtDisabledOverlay(
        disabled,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(value);
          },
          child: AnimatedContainer(
            duration: 500.milliseconds,
            height: size,
            width: size,
            constraints: BoxConstraints.tightFor(height: size, width: size),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.8),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: GtAnimatedSwitcher(
              child: Builder(
                builder: (context) {
                  if (_isActive) return _ActiveInnerContainer(color);
                  return const _InActiveInnerContainer();
                },
                key: ValueKey<T>(value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveInnerContainer extends StatelessWidget {
  final Color color;

  const _ActiveInnerContainer(this.color);

  @override
  Widget build(BuildContext context) {
    final size = context.dp(10.px);

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _InActiveInnerContainer extends StatelessWidget {
  const _InActiveInnerContainer();

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.icon.white,
          shape: BoxShape.circle,
          boxShadow: context.shadows.indicatorShadow(),
        ),
      ),
    );
  }
}
