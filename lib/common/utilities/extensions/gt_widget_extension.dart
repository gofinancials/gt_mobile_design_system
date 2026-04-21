import 'package:flutter/material.dart';

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
