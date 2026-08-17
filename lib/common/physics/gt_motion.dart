import 'package:flutter/widgets.dart';

/// Shared timing and scale tokens for motion across the design system.
abstract final class GtMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration fluid = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);

  static const double buttonPressScale = 0.97;
  static const double cardPressScale = 0.985;
  static const double iconPressScale = 0.92;

  /// Returns [Duration.zero] when the platform asks animations to be disabled.
  static Duration adaptiveDuration(BuildContext context, Duration duration) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false
        ? Duration.zero
        : duration;
  }
}
