import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The foundational blueprint for an application's design system theme.
///
/// This abstract class aggregates all styling primitives (colors, typography,
/// spacing, shadows, etc.) and native Flutter theme data. Host applications
/// must implement this class to provide their specific brand identity and
/// token configurations.
abstract class GtThemeData {
  /// The color palette used when the application is in light mode.
  GtPalette lightPalette;

  /// The color palette used when the application is in dark mode.
  GtPalette darkPalette;

  /// The compiled Material [ThemeData] for dark mode.
  ThemeData get materialDark;

  /// The compiled Material [ThemeData] for light mode.
  ThemeData get materialLight;

  /// The compiled [CupertinoThemeData] for light mode, if applicable.
  CupertinoThemeData? get cupertinoLight;

  /// The compiled [CupertinoThemeData] for dark mode, if applicable.
  CupertinoThemeData? get cupertinoDark;

  /// The grid layout configuration for the theme.
  GtGrid get grid;

  /// The typography font family definitions.
  GtFonts get fonts;

  /// Resolves the border radius tokens for the given [context].
  GtRadii radii(BuildContext context);

  /// Resolves the shadow and elevation tokens for the given [context].
  GtShadows shadows(BuildContext context);

  /// Resolves the spacing and layout gap tokens for the given [context].
  GtSpacing spacing(BuildContext context);

  /// Resolves the gradient styles for the given [context].
  GtGradients gradients(BuildContext context);

  /// Resolves the typography and text styles for the given [context].
  GtTextStyles textStyles(BuildContext context);

  /// Resolves the form input styles and decorations for the given [context].
  GtInputStyles inputStyles(BuildContext context);

  /// The default page transition animations mapped by target platform.
  Map<TargetPlatform, PageTransitionsBuilder> get defaultTransitions {
    Map<TargetPlatform, PageTransitionsBuilder> transitionMap = {};
    for (final platform in TargetPlatform.values) {
      transitionMap[platform] = const CupertinoPageTransitionsBuilder();
    }
    return transitionMap;
  }

  /// Creates a base instance of [GtThemeData].
  ///
  /// Requires the foundational [lightPalette] and [darkPalette] that drive
  /// the semantic coloring engine for the host application.
  GtThemeData({required this.lightPalette, required this.darkPalette});
}
