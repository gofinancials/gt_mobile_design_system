import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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

  /// A linear gradient tailored for avatar backgrounds.
  ///
  /// Transitions from a 10% opacity primary color into a 24% opacity primary color.
  Gradient get avatarGradient {
    return LinearGradient(
      colors: [
        context.palette.primary.alpha10,
        context.palette.primary.alpha24,
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }

  /// A linear gradient tailored for appbar avatar backgrounds.
  ///
  /// Transitions from a 24% opacity primary color into the solid primary color.
  Gradient get appbarAvatarGradient {
    return LinearGradient(
      colors: [context.palette.primary.alpha24, context.palette.primary.base],
      stops: [0, .6],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }

  /// A subtle, semi-transparent linear gradient typically used for ghost styling.
  ///
  /// Blends a solid white color into a 16% opacity white.
  Gradient get ghostGradient {
    return LinearGradient(
      colors: [
        context.palette.bg.white,
        context.palette.bg.white.setOpacity(.16),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }

  /// Creates a two-tone linear gradient.
  ///
  /// Transitions from the provided [light] color at the top-left to the [dark] color at the bottom-right.
  Gradient duoToneGradient(Color dark, Color light) {
    return LinearGradient(
      colors: [light, dark],
      stops: [0, 1],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
