import 'package:flutter/material.dart';

/// A centralized styling class that provides access to the application's
/// form input styles and decorations.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// colors, border radii, padding, and typography for various input components
/// (e.g., text fields, dropdowns) as defined in the design system.
class GtInputStyles {
  /// The [BuildContext] used to access the current theme and adaptive sizing utilities.
  final BuildContext context;

  /// Creates an instance of [GtInputStyles].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent input styles.
  const GtInputStyles(this.context);
}
