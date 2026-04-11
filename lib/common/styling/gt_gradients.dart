import 'package:flutter/material.dart';

/// A centralized styling class that provides access to the application's
/// standard gradient styles.
///
/// This class uses the provided [BuildContext] to resolve theme-dependent
/// colors and create standardized linear, radial, or sweep gradients
/// as defined in the design system.
class GtGradients {
  /// The [BuildContext] used to access the current theme and color palettes.
  final BuildContext context;

  /// Creates an instance of [GtGradients].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent gradient colors.
  const GtGradients(this.context);
}