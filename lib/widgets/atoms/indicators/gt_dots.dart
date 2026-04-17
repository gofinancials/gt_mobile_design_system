import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standard row of dot indicators, typically used for carousels or paginated content.
class GtDots extends StatelessWidget {
  /// The total number of dots to display.
  final int length;

  /// The color of the active dot. Defaults to the primary base color from the current palette.
  final Color? activeColor;

  /// The color of the inactive dots. Defaults to the disabled icon color from the current palette.
  final Color? inActiveColor;

  /// The index of the currently active dot.
  final int? activeIndex;

  /// Creates a new [GtDots] indicator.
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

    return RepaintBoundary(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: children,
      ),
    );
  }
}

/// A row of dot indicators that dynamically scales down the size of dots based on their distance from the active dot.
class GtScaledDots extends StatelessWidget {
  /// The total number of dots to display.
  final int length;

  /// The index of the currently active dot.
  final int? activeIndex;

  /// The color of the active dot. Defaults to the primary base color.
  final Color? activeColor;

  /// The color of the inactive dots. Defaults to the disabled icon color.
  final Color? inActiveColor;

  /// The maximum size of the active dot. Other dots will scale down proportionally from this size.
  final double maxSize;

  /// Creates a new [GtScaledDots] indicator.
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

    return RepaintBoundary(
      child: Wrap(
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
      ),
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

/// A specialized dot indicator typically used for PIN or passcode inputs.
///
/// Displays a series of hollow circles that fill in as the [inputValue] grows.
class GtInputDots extends StatelessWidget {
  /// The total number of input dots to display (e.g., the required PIN length).
  final int maxLength;

  /// The current input string. The number of filled dots corresponds to the length of this string.
  final String inputValue;

  /// The color used for both the filled active dots and the borders of the inactive dots.
  final Color? color;

  /// Creates a new [GtInputDot] indicator.
  const GtInputDots({
    this.maxLength = 4,
    required this.inputValue,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.generate(maxLength, (index) {
      final isActive = index < inputValue.length;

      return _InputDot(isActive, color: color);
    });
    final spacing = context.dp(context.spacing.base.px);

    return RepaintBoundary(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: children,
      ),
    );
  }
}

class _InputDot extends StatelessWidget {
  final Color? color;
  final bool active;

  const _InputDot(this.active, {this.color});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final computedColor = color ?? palette.text.strong;
    final borderColor = computedColor;
    final contentColor = active ? computedColor : GtColors.transparent.value;

    return Transform.scale(
      scale: active ? 1.1 : 1,
      child: AnimatedContainer(
        duration: 300.milliseconds,
        curve: Curves.easeIn,
        height: context.dp(24.px),
        width: context.dp(24.px),
        decoration: BoxDecoration(
          color: contentColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 4),
        ),
      ),
    );
  }
}
