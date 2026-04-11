import 'package:flutter/material.dart';

/// A centralized styling class that provides access to the application's
/// typographic system and text styles.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// text styles, scaling factors, and responsive typography tokens as defined
/// in the design system.
class GtTextStyles {
  /// The [BuildContext] used to access the current theme and scaling utilities.
  final BuildContext context;

  /// Creates an instance of [GtTextStyles].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent styles.
  const GtTextStyles(this.context);
}
