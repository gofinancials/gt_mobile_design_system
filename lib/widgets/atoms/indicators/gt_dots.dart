import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standard row of dot indicators, typically used for carousels or paginated content.
///
/// By default every page gets a dot, and a long list wraps onto further rows.
/// Set [maxVisible] to cap the row: past that many pages it shows a sliding
/// window of [maxVisible] dots around [activeIndex] on a single row.
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

  /// The most dots drawn at once, or null to draw one for every page.
  ///
  /// When [length] is at most [maxVisible] the dots are drawn as they are
  /// without it. Beyond that exactly [maxVisible] dots sit on one row, a
  /// window onto the list: the active dot sits in its middle, except near
  /// either end of the list, where it moves out to the edge of the window.
  /// The dots keep their full size, except an inactive dot at the edge of the
  /// window with more pages beyond it, which is drawn at half size to read as more
  /// pages that way. As [activeIndex] changes the window slides over 300ms,
  /// the dot leaving it shrinking away and the one entering it growing in.
  ///
  /// [semanticsLabel] should still give the real position, such as
  /// "Card 12 of 30", since the window only shows part of the list.
  final int? maxVisible;

  /// Creates a new [GtDots] indicator.
  const GtDots(
    this.activeIndex, {
    this.length = 3,
    super.key,
    this.semanticsLabel,
    this.activeColor,
    this.inActiveColor,
    this.maxVisible,
  }) : assert(activeIndex != null),
       assert(maxVisible == null || maxVisible > 0);

  @override
  Widget build(BuildContext context) {
    final spacing = context.dp(context.spacing.base.px);
    final size = context.dp(8.px);

    Widget child;
    if (maxVisible case final visible? when length > visible) {
      child = _DotWindow(
        activeIndex: activeIndex ?? 0,
        length: length,
        visible: visible,
        slot: size + spacing,
        height: size,
        dotBuilder: (index, {required first, required last}) {
          double dotSize = size;
          if (index < first || index > last) {
            dotSize = 0;
          } else if (index != activeIndex &&
              ((index == first && first > 0) ||
                  (index == last && last < length - 1))) {
            dotSize = size / 2;
          }
          return _Dot(
            activeIndex == index,
            activeColor: activeColor,
            inActiveColor: inActiveColor,
            size: dotSize,
          );
        },
      );
    } else {
      child = Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(length, (index) {
          return _Dot(
            activeIndex == index,
            activeColor: activeColor,
            inActiveColor: inActiveColor,
          );
        }),
      );
    }

    return RepaintBoundary(
      child: GtSemantics(
        label: semanticsLabel,
        // The individual dots are decoration; the label carries the position.
        excludeDescendants: semanticsLabel != null,
        container: semanticsLabel != null,
        child: child,
      ),
    );
  }
}

/// A row of dot indicators that dynamically scales down the size of dots based on their distance from the active dot.
///
/// By default every page gets a dot, and a long list wraps onto further rows.
/// Set [maxVisible] to cap the row: past that many pages it shows a sliding
/// window of [maxVisible] dots around [activeIndex] on a single row.
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

  /// The most dots drawn at once, or null to draw one for every page.
  ///
  /// When [length] is at most [maxVisible] the dots are drawn as they are
  /// without it. Beyond that exactly [maxVisible] dots sit on one row, a
  /// window onto the list: the active dot sits in its middle, except near
  /// either end of the list, where it moves out to the edge of the window.
  /// Dots shrink with their distance from the active dot within the window,
  /// so the small dots at an edge read as more pages that way. As
  /// [activeIndex] changes the window slides over 300ms, the dot leaving it
  /// shrinking away and the one entering it growing in.
  ///
  /// [semanticsLabel] should still give the real position, such as
  /// "Card 12 of 30", since the window only shows part of the list.
  final int? maxVisible;

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
    this.maxVisible,
    this.semanticsLabel,
    super.key,
  }) : assert(activeIndex != null),
       assert(maxVisible == null || maxVisible > 0);

  /// The size of the dot at [index], shrinking from [size] the further it is
  /// from [activeIndex], by a [count]th of [size] for each step away.
  double _calculateSize(int index, double size, {int? count}) {
    if (index == activeIndex) return size;
    final distance = ((activeIndex ?? 0) - index).abs();
    if (distance == 0) return size;
    final distanceFraction = distance / (count ?? length);
    return size - (size * distanceFraction);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dp(context.spacing.base.px);
    final size = context.dp(maxSize.px);

    Widget child;
    if (maxVisible case final visible? when length > visible) {
      child = _DotWindow(
        activeIndex: activeIndex ?? 0,
        length: length,
        visible: visible,
        slot: size + spacing,
        height: size,
        dotBuilder: (index, {required first, required last}) {
          final inWindow = index >= first && index <= last;
          return _Dot(
            activeIndex == index,
            activeColor: activeColor,
            inActiveColor: inActiveColor,
            size: inWindow ? _calculateSize(index, size, count: visible) : 0,
          );
        },
      );
    } else {
      child = Wrap(
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
            size: _calculateSize(index, size),
          );
        }),
      );
    }

    return RepaintBoundary(
      child: GtSemantics(
        label: semanticsLabel,
        // The individual dots are decoration; the label carries the position.
        excludeDescendants: semanticsLabel != null,
        container: semanticsLabel != null,
        child: child,
      ),
    );
  }
}

/// A private widget showing [visible] of [length] dots, a
/// window that slides along the list to keep [activeIndex] in view.
///
/// Every dot takes a [slot] of the same width on one long row, which is
/// clipped to [visible] slots and slid along under the clip, so moving the
/// window animates rather than jumps. Only the dots in the window and one to
/// either side of it are built; the rest are empty slots.
class _DotWindow extends StatelessWidget {
  /// The index of the active dot, the window's anchor.
  final int activeIndex;

  /// The total number of pages.
  final int length;

  /// How many dots the window shows; less than [length].
  final int visible;

  /// The width given to each dot, its largest size plus the gap after it.
  final double slot;

  /// The height of the row, the largest dot's size.
  final double height;

  /// Builds the dot for page `index`, given the first and last pages in the
  /// window; a dot outside them should be drawn at no size.
  final Widget Function(int index, {required int first, required int last})
  dotBuilder;

  /// Creates a [_DotWindow].
  const _DotWindow({
    required this.activeIndex,
    required this.length,
    required this.visible,
    required this.slot,
    required this.height,
    required this.dotBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeIndex.clamp(0, length - 1);
    final first = (active - visible ~/ 2).clamp(0, length - visible);
    final last = first + visible - 1;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Each dot is centred in its slot, half a gap in from either side; the
    // window starts and ends at the dots, not the slots.
    final inset = (slot - height) / 2;

    final row = Row(
      mainAxisSize: .min,
      children: [
        for (var index = 0; index < length; index++)
          SizedBox(
            width: slot,
            height: height,
            child: index >= first - 1 && index <= last + 1
                ? Center(
                    child: dotBuilder(index, first: first, last: last),
                  )
                : null,
          ),
      ],
    );

    return ClipRect(
      child: SizedBox(
        width: slot * visible - inset * 2,
        height: height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: first.toDouble()),
          duration: 300.milliseconds,
          curve: Curves.easeIn,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset((offset * slot + inset) * (rtl ? 1 : -1), 0),
              child: child,
            );
          },
          child: OverflowBox(
            alignment: AlignmentDirectional.centerStart,
            maxWidth: double.infinity,
            child: row,
          ),
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
