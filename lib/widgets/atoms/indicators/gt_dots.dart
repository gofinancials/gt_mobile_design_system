import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtDots extends StatelessWidget {
  final int length;
  final Color? activeColor;
  final Color? inActiveColor;
  final int? activeIndex;

  const GtDots(
    this.activeIndex, {
    this.length = 3,
    super.key,
    this.activeColor,
    this.inActiveColor,
  }) : assert(activeIndex != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.generate(length, (index) {
      final isActive = activeIndex == index;
      return _Dot(
        isActive,
        activeColor: activeColor,
        inActiveColor: inActiveColor,
      );
    });
    final spacing = context.dp(context.spacing.base.px);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: spacing,
      children: children,
    );
  }
}

class GtScaledDots extends StatelessWidget {
  final int length;
  final int? activeIndex;
  final Color? activeColor;
  final Color? inActiveColor;
  final double maxSize;

  const GtScaledDots(
    this.activeIndex, {
    this.length = 3,
    this.activeColor,
    this.inActiveColor,
    this.maxSize = 8,
    super.key,
  }) : assert(activeIndex != null);

  double _calculateSize(int index, double size) {
    if (index == activeIndex) return size;
    final distance = ((activeIndex ?? 0) - index).abs();
    if (distance == 0) return size;
    final distanceFraction = distance / length;
    return size - (size * distanceFraction);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dp(context.spacing.base.px);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(length, (index) {
        final isActive = activeIndex == index;
        return _Dot(
          isActive,
          activeColor: activeColor,
          inActiveColor: inActiveColor,
          size: _calculateSize(index, context.dp(maxSize.px)),
        );
      }),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  final Color? activeColor;
  final Color? inActiveColor;
  final double? size;

  const _Dot(this.active, {this.activeColor, this.inActiveColor, this.size});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorActive = activeColor ?? palette.primary.base;
    final colorInActive = inActiveColor ?? palette.icon.disabled;

    final color = active ? colorActive : colorInActive;

    return AnimatedContainer(
      duration: 300.milliseconds,
      curve: Curves.easeIn,
      height: size ?? context.dp(8.px),
      width: size ?? context.dp(8.px),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
