import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// PALETTE GROUPS
// -----------------------------------------------------------------------------

/// Represents the core brand colors for the application.
///
/// Rather than hardcoding specific hues (like "blue" or "orange"), this semantic grouping
/// allows different host apps to inject their own primary brand identity while
/// keeping component logic identical. Includes opacities for interactive states.
class GtPaletteBrandColors {
  final Color dark;
  final Color darker;
  final Color base;
  final Color alpha16;
  final Color alpha10;

  const GtPaletteBrandColors({
    required this.dark,
    required this.darker,
    required this.base,
    required this.alpha16,
    required this.alpha10,
  });

  static GtPaletteBrandColors lerp(
      GtPaletteBrandColors? a, GtPaletteBrandColors? b, double t) {
    return GtPaletteBrandColors(
      dark: Color.lerp(a?.dark, b?.dark, t)!,
      darker: Color.lerp(a?.darker, b?.darker, t)!,
      base: Color.lerp(a?.base, b?.base, t)!,
      alpha16: Color.lerp(a?.alpha16, b?.alpha16, t)!,
      alpha10: Color.lerp(a?.alpha10, b?.alpha10, t)!,
    );
  }
}

/// Colors that remain absolutely constant regardless of the active theme
/// (e.g., absolute black and absolute white). Typically used where extreme
/// contrast must be guaranteed regardless of Light/Dark mode contexts.
class GtPaletteStaticColors {
  final Color black;
  final Color white;
  final Color shadow;

  const GtPaletteStaticColors({
    required this.black,
    required this.white,
    required this.shadow,
  });

  static GtPaletteStaticColors lerp(
      GtPaletteStaticColors? a, GtPaletteStaticColors? b, double t) {
    return GtPaletteStaticColors(
      black: Color.lerp(a?.black, b?.black, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
      shadow: Color.lerp(a?.shadow, b?.shadow, t)!,
    );
  }
}

/// Semantic backgrounds used to establish visual hierarchy and elevation.
///
/// Naming ranges from [strong] (most prominent) to [weak] (subtlest), allowing
/// surfaces and cards to naturally adapt their depths across Light and Dark modes.
class GtPaletteBgColors {
  final Color strong;
  final Color surface;
  final Color sub;
  final Color soft;
  final Color weak;
  final Color white;

  const GtPaletteBgColors({
    required this.strong,
    required this.surface,
    required this.sub,
    required this.soft,
    required this.weak,
    required this.white,
  });

  static GtPaletteBgColors lerp(
      GtPaletteBgColors? a, GtPaletteBgColors? b, double t) {
    return GtPaletteBgColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      surface: Color.lerp(a?.surface, b?.surface, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      weak: Color.lerp(a?.weak, b?.weak, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }
}

/// Colors applied to foreground elements like text and icons.
///
/// Designed to guarantee readability and accessible contrast ratios against
/// the corresponding [GtPaletteBgColors].
class GtPaletteContentColors {
  final Color strong;
  final Color sub;
  final Color soft;
  final Color disabled;
  final Color white;

  const GtPaletteContentColors({
    required this.strong,
    required this.sub,
    required this.soft,
    required this.disabled,
    required this.white,
  });

  static GtPaletteContentColors lerp(
      GtPaletteContentColors? a, GtPaletteContentColors? b, double t) {
    return GtPaletteContentColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      disabled: Color.lerp(a?.disabled, b?.disabled, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }
}

/// Colors used for boundaries, such as borders, dividers, and outlines.
///
/// Helps delineate structural areas without visually overwhelming the core content.
class GtPaletteStrokeColors {
  final Color strong;
  final Color sub;
  final Color soft;
  final Color white;

  const GtPaletteStrokeColors({
    required this.strong,
    required this.sub,
    required this.soft,
    required this.white,
  });

  static GtPaletteStrokeColors lerp(
      GtPaletteStrokeColors? a, GtPaletteStrokeColors? b, double t) {
    return GtPaletteStrokeColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }
}

/// Colors representing semantic UI states and structural feedback.
///
/// Includes various shades (dark to lighter) to support different component
/// architectures, such as subtle backgrounds for alerts or strong fills for badges.
class GtPaletteStateColors {
  final Color dark;
  final Color base;
  final Color light;
  final Color lighter;

  const GtPaletteStateColors({
    required this.dark,
    required this.base,
    required this.light,
    required this.lighter,
  });

  static GtPaletteStateColors lerp(
      GtPaletteStateColors? a, GtPaletteStateColors? b, double t) {
    return GtPaletteStateColors(
      dark: Color.lerp(a?.dark, b?.dark, t)!,
      base: Color.lerp(a?.base, b?.base, t)!,
      light: Color.lerp(a?.light, b?.light, t)!,
      lighter: Color.lerp(a?.lighter, b?.lighter, t)!,
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN THEME EXTENSION
// -----------------------------------------------------------------------------

/// The root semantic color palette for the design system.
///
/// This [ThemeExtension] is the cornerstone of the dynamic multi-app theming engine.
/// By strictly avoiding hardcoded colors in widgets and relying entirely on this
/// palette, applications can instantly switch branding (e.g., OneBank Pro vs Kids)
/// and natively support Light/Dark modes without altering underlying UI components.
base class GtPalette extends ThemeExtension<GtPalette> {
  // Brand
  final GtPaletteBrandColors primary;
  final GtPaletteBrandColors sterling;

  // Neutral
  final GtPaletteStaticColors staticColors;
  final GtPaletteBgColors bg;
  final GtPaletteContentColors text;
  final GtPaletteStrokeColors stroke;
  final GtPaletteContentColors icon;

  // States
  final GtPaletteStateColors faded;
  final GtPaletteStateColors information;
  final GtPaletteStateColors warning;
  final GtPaletteStateColors error;
  final GtPaletteStateColors success;
  final GtPaletteStateColors away;
  final GtPaletteStateColors feature;
  final GtPaletteStateColors verified;
  final GtPaletteStateColors highlighted;
  final GtPaletteStateColors stable;

  const GtPalette({
    required this.primary,
    required this.sterling,
    required this.staticColors,
    required this.bg,
    required this.text,
    required this.stroke,
    required this.icon,
    required this.faded,
    required this.information,
    required this.warning,
    required this.error,
    required this.success,
    required this.away,
    required this.feature,
    required this.verified,
    required this.highlighted,
    required this.stable,
  });

  @override
  ThemeExtension<GtPalette> lerp(
    covariant ThemeExtension<GtPalette>? other,
    double t,
  ) {
    if (other is! GtPalette) return this;

    return GtPalette(
      primary: GtPaletteBrandColors.lerp(primary, other.primary, t),
      sterling: GtPaletteBrandColors.lerp(sterling, other.sterling, t),
      staticColors:
          GtPaletteStaticColors.lerp(staticColors, other.staticColors, t),
      bg: GtPaletteBgColors.lerp(bg, other.bg, t),
      text: GtPaletteContentColors.lerp(text, other.text, t),
      stroke: GtPaletteStrokeColors.lerp(stroke, other.stroke, t),
      icon: GtPaletteContentColors.lerp(icon, other.icon, t),
      faded: GtPaletteStateColors.lerp(faded, other.faded, t),
      information: GtPaletteStateColors.lerp(information, other.information, t),
      warning: GtPaletteStateColors.lerp(warning, other.warning, t),
      error: GtPaletteStateColors.lerp(error, other.error, t),
      success: GtPaletteStateColors.lerp(success, other.success, t),
      away: GtPaletteStateColors.lerp(away, other.away, t),
      feature: GtPaletteStateColors.lerp(feature, other.feature, t),
      verified: GtPaletteStateColors.lerp(verified, other.verified, t),
      highlighted: GtPaletteStateColors.lerp(highlighted, other.highlighted, t),
      stable: GtPaletteStateColors.lerp(stable, other.stable, t),
    );
  }

  @override
  ThemeExtension<GtPalette> copyWith() {
    return this;
  }
}
