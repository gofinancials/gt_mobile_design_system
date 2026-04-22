import 'package:flutter/cupertino.dart';

/// A simple data class that holds a pair of non-null [Widget]s.
///
/// This is typically used to represent a leading and trailing widget
/// or any other required pairing of two UI elements.
final class GtWidgetPair {
  /// The first or leading widget in the pair.
  final Widget head;

  /// The second or trailing widget in the pair.
  final Widget tail;

  /// Creates a [GtWidgetPair] with the provided [head] and [tail] widgets.
  const GtWidgetPair({required this.head, required this.tail});
}

/// A simple data class that holds a pair of optional [Widget]s.
///
/// This is useful when passing an optional leading/trailing pair to
/// components like app bars or list tiles, where one, both, or neither
/// widget may be provided.
final class GtOptionalWidgetPair {
  /// The first or leading optional widget in the pair.
  final Widget? head;

  /// The second or trailing optional widget in the pair.
  final Widget? tail;

  /// Creates a [GtOptionalWidgetPair] with the provided [head] and [tail].
  const GtOptionalWidgetPair({required this.head, required this.tail});

  /// Returns `true` if at least one of the widgets ([head] or [tail]) is not null.
  bool get hasValue => head != null || tail != null;
}
