import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A utility extension on [Widget] providing convenient syntactic sugar.
extension WidgetExtensions on Widget {
  /// Duplicates this widget [count] times and returns them as a [List].
  ///
  /// This operator allows for concisely generating multiple instances of the
  /// same widget. It is particularly useful for repeating spacers, dividers,
  /// or placeholder items within layouts like [Row] or [Column].
  ///
  /// Example:
  /// ```dart
  /// Row(children: [ ...(SizedBox(width: 8) * 3) ])
  /// ```
  List<Widget> operator *(int count) {
    return List.generate(count, (_) => this);
  }
}

/// Resolves a consistent color pair and gradient from a [String], based on
/// its first character.
///
/// Useful for giving placeholders such as initials-based avatars a color
/// that stays the same for the same name, without storing it anywhere.
///
/// Example:
/// ```dart
/// DecoratedBox(
///   decoration: BoxDecoration(gradient: user.name.toGradient(context)),
/// )
/// ```
extension StringGradientResolutionExtension on String {
  /// Returns the `(first, second)` colors for this string from [palette].
  ///
  /// The first letter, ignoring case, picks one of four color families by
  /// cycling through the alphabet: `a`, `b`, `c`, `d` map to red, sky,
  /// green and orange, then `e` starts over at red, and so on. Each pair is
  /// the family's `50` shade followed by its 10% alpha shade.
  ///
  /// Empty strings and strings that start with anything other than a
  /// letter fall back to yellow.
  (Color, Color) colorPair(BuildContext context) {
    final palette = context.palette;
    final first = hasValue ? this[0] : "_";

    if (context.isInDarkMode) {
      return switch (first.lower) {
        'a' ||
        'e' ||
        'i' ||
        'm' ||
        'q' ||
        'u' ||
        'y' => (palette.raw.green400, palette.raw.green800),
        'b' ||
        'f' ||
        'j' ||
        'n' ||
        'r' ||
        'v' ||
        'z' => (palette.raw.red400, palette.raw.red800),
        'c' ||
        'g' ||
        'k' ||
        'o' ||
        's' ||
        'w' => (palette.raw.yellow400, palette.raw.yellow800),
        'd' ||
        'h' ||
        'l' ||
        'p' ||
        't' ||
        'x' => (palette.raw.blue400, palette.raw.blue800),
        _ => (palette.raw.orange400, palette.raw.orange800),
      };
    }

    return switch (first.lower) {
      'a' ||
      'e' ||
      'i' ||
      'm' ||
      'q' ||
      'u' ||
      'y' => (palette.raw.red50, palette.raw.redAlpha10),
      'b' ||
      'f' ||
      'j' ||
      'n' ||
      'r' ||
      'v' ||
      'z' => (palette.raw.sky50, palette.raw.skyAlpha10),
      'c' ||
      'g' ||
      'k' ||
      'o' ||
      's' ||
      'w' => (palette.raw.green50, palette.raw.greenAlpha10),
      'd' ||
      'h' ||
      'l' ||
      'p' ||
      't' ||
      'x' => (palette.raw.orange50, palette.raw.orangeAlpha10),
      _ => (palette.raw.yellow50, palette.raw.yellowAlpha10),
    };
  }

  /// Builds a [GtGradients.stringGradient] from this string's [colorPair],
  /// using the palette from [context].
  Gradient toGradient(BuildContext context) {
    final colors = colorPair(context);
    return context.gradients.stringGradient(colors.$1, colors.$2);
  }
}
