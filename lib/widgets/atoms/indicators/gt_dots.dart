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

  /// An accessible name describing the current position, already localised.
  ///
  /// The dots themselves carry no text, so without this the whole indicator is
  /// invisible to a screen reader and the user has no way to tell how many
  /// pages there are or which one they are on. Supply something like
  /// "Page 2 of 5".
  ///
  /// No default is provided deliberately: the design system has no dictionary
  /// of its own, and a missing translation key would be spoken aloud verbatim.
  final String? semanticsLabel;

  /// Creates a new [GtDots] indicator.
  const GtDots(
    this.activeIndex, {
    this.length = 3,
    super.key,
    this.semanticsLabel,
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
      child: GtSemantics(
        label: semanticsLabel,
        // The individual dots are decoration; the label carries the position.
        excludeDescendants: semanticsLabel != null,
        container: semanticsLabel != null,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: children,
        ),
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

  /// An accessible name describing the current position, already localised.
  ///
  /// See [GtDots.semanticsLabel] for why no default is supplied.
  final String? semanticsLabel;

  /// Creates a new [GtScaledDots] indicator.
  const GtScaledDots(
    this.activeIndex, {
    this.length = 3,
    this.activeColor,
    this.inActiveColor,
    this.maxSize = 8,
    this.semanticsLabel,
    super.key,
  }) : assert(activeIndex != null);

  /// The size of the dot at [index], shrinking from [size] the further it is
  /// from [activeIndex].
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
      child: GtSemantics(
        label: semanticsLabel,
        // The individual dots are decoration; the label carries the position.
        excludeDescendants: semanticsLabel != null,
        container: semanticsLabel != null,
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
      ),
    );
  }
}

/// A private widget drawing one dot of [GtDots] or [GtScaledDots].
///
/// Inside an enabled [GtSkeleton] it is painted as a circular [GtBone].
class _Dot extends StatelessWidget {
  /// Whether this dot marks the active position.
  final bool active;

  /// The color of an active dot. Defaults to the palette's primary color.
  final Color? activeColor;

  /// The color of an inactive dot. Defaults to the palette's disabled icon
  /// color.
  final Color? inActiveColor;

  /// The diameter of the dot. Defaults to 8.
  final double? size;

  /// Creates a [_Dot].
  const _Dot(this.active, {this.activeColor, this.inActiveColor, this.size});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorActive = activeColor ?? palette.primary.base;
    final colorInActive = inActiveColor ?? palette.icon.disabled;

    final color = active ? colorActive : colorInActive;

    Widget dot = AnimatedContainer(
      duration: 300.milliseconds,
      curve: Curves.easeIn,
      height: size ?? context.dp(8.px),
      width: size ?? context.dp(8.px),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    if (context.inSkeleton) {
      dot = GtBone(shape: .circle, child: dot);
    }
    return dot;
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

  /// The color of the inactive dots
  final Color? inactiveColor;

  /// Whether the dots should be filled with color when inactive, or just outlined.
  final bool filled;

  /// Creates a new [GtInputDot] indicator.
  const GtInputDots({
    this.maxLength = 4,
    required this.inputValue,
    this.inactiveColor,
    this.filled = false,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.palette.text.strong;
    final fallbackInactiveColor = filled ? context.palette.bg.sub : activeColor;
    final computedInactiveColor = inactiveColor ?? fallbackInactiveColor;

    List<Widget> children = List.generate(maxLength, (index) {
      final isActive = index < inputValue.length;
      final color = isActive ? activeColor : computedInactiveColor;

      return _InputDot(isActive, color: color, filled: filled);
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

/// A private widget drawing one dot of [GtInputDots].
///
/// Inside an enabled [GtSkeleton] it is painted as a circular [GtBone].
class _InputDot extends StatelessWidget {
  /// The color of the dot's fill or ring.
  final Color color;

  /// Whether this dot stands for an entered character.
  final bool active;

  /// Whether an inactive dot is filled rather than drawn as a ring.
  final bool filled;

  /// Creates an [_InputDot].
  const _InputDot(this.active, {required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final contentColor = active ? color : Colors.transparent;
    final size = 24 * (active ? 1.1 : 1);

    Widget dot = AnimatedContainer(
      duration: 300.milliseconds,
      curve: Curves.easeIn,
      height: context.dp(size.px),
      width: context.dp(size.px),
      decoration: BoxDecoration(
        color: filled ? color : contentColor,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
      ),
    );
    if (context.inSkeleton) {
      dot = GtBone(shape: .circle, child: dot);
    }
    return dot;
  }
}
