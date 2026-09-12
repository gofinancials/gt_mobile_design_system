import 'package:flutter/painting.dart';

/// Resolves optional text styling without changing the existing default.
abstract final class GtTextStyleOverrides {
  /// A supplied [style] replaces [fallback]. An explicit [color] then wins
  /// over the selected style's colour or foreground paint. Other properties
  /// remain unchanged. Null overrides return the original fallback instance.
  static TextStyle resolve(TextStyle? style, TextStyle fallback, Color? color) {
    final resolved = style ?? fallback;
    if (color == null) return resolved;
    if (resolved.foreground != null) {
      return resolved.copyWith(foreground: Paint()..color = color);
    }
    return resolved.copyWith(color: color);
  }
}
