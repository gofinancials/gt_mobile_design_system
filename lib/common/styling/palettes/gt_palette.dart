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
  final Color alpha24;
  final Color alpha16;
  final Color alpha10;

  const GtPaletteBrandColors({
    required this.dark,
    required this.darker,
    required this.base,
    required this.alpha24,
    required this.alpha16,
    required this.alpha10,
  });

  List<Color> get all => [dark, darker, base, alpha24, alpha16, alpha10];

  static GtPaletteBrandColors lerp(
    GtPaletteBrandColors? a,
    GtPaletteBrandColors? b,
    double t,
  ) {
    return GtPaletteBrandColors(
      dark: Color.lerp(a?.dark, b?.dark, t)!,
      darker: Color.lerp(a?.darker, b?.darker, t)!,
      base: Color.lerp(a?.base, b?.base, t)!,
      alpha24: Color.lerp(a?.alpha24, b?.alpha24, t)!,
      alpha16: Color.lerp(a?.alpha16, b?.alpha16, t)!,
      alpha10: Color.lerp(a?.alpha10, b?.alpha10, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteBrandColors) return false;

    return other.dark == dark &&
        other.darker == darker &&
        other.base == base &&
        other.alpha16 == alpha16 &&
        other.alpha10 == alpha10;
  }

  @override
  int get hashCode => Object.hash(dark, darker, base, alpha16, alpha10);
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

  List<Color> get all => [black, white, shadow];

  static GtPaletteStaticColors lerp(
    GtPaletteStaticColors? a,
    GtPaletteStaticColors? b,
    double t,
  ) {
    return GtPaletteStaticColors(
      black: Color.lerp(a?.black, b?.black, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
      shadow: Color.lerp(a?.shadow, b?.shadow, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStaticColors) return false;

    return other.black == black &&
        other.white == white &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(black, white, shadow);
}

/// Colors specifically tailored for large cover areas, marketing screens, or
/// specialized background treatments, providing distinct light and dark variants.
class GtPaletteCoverColors {
  final Color light;
  final Color dark;

  const GtPaletteCoverColors({required this.light, required this.dark});

  List<Color> get all => [light, dark];

  static GtPaletteCoverColors lerp(
    GtPaletteCoverColors? a,
    GtPaletteCoverColors? b,
    double t,
  ) {
    return GtPaletteCoverColors(
      light: Color.lerp(a?.light, b?.light, t)!,
      dark: Color.lerp(a?.dark, b?.dark, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteCoverColors) return false;

    return other.light == light && other.dark == dark;
  }

  @override
  int get hashCode => Object.hash(light, dark);
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

  List<Color> get all => [strong, surface, sub, soft, weak, white];

  static GtPaletteBgColors lerp(
    GtPaletteBgColors? a,
    GtPaletteBgColors? b,
    double t,
  ) {
    return GtPaletteBgColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      surface: Color.lerp(a?.surface, b?.surface, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      weak: Color.lerp(a?.weak, b?.weak, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteBgColors) return false;

    return other.strong == strong &&
        other.surface == surface &&
        other.sub == sub &&
        other.soft == soft &&
        other.weak == weak &&
        other.white == white;
  }

  @override
  int get hashCode => Object.hash(strong, surface, sub, soft, weak, white);
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

  List<Color> get all => [strong, sub, soft, disabled, white];

  static GtPaletteContentColors lerp(
    GtPaletteContentColors? a,
    GtPaletteContentColors? b,
    double t,
  ) {
    return GtPaletteContentColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      disabled: Color.lerp(a?.disabled, b?.disabled, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteContentColors) return false;
    return other.strong == strong &&
        other.sub == sub &&
        other.soft == soft &&
        other.disabled == disabled &&
        other.white == white;
  }

  @override
  int get hashCode => Object.hash(strong, sub, soft, disabled, white);
}

class GtPaletteTextColors extends GtPaletteContentColors {
  final Color darkerSub;

  const GtPaletteTextColors({
    required super.strong,
    required super.sub,
    required super.soft,
    required super.disabled,
    required super.white,
    required this.darkerSub,
  });

  @override
  List<Color> get all => [...super.all, darkerSub];

  static GtPaletteTextColors lerp(
    GtPaletteTextColors? a,
    GtPaletteTextColors? b,
    double t,
  ) {
    return GtPaletteTextColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      disabled: Color.lerp(a?.disabled, b?.disabled, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
      darkerSub: Color.lerp(a?.darkerSub, b?.darkerSub, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteTextColors) return false;
    return other.strong == strong &&
        other.sub == sub &&
        other.soft == soft &&
        other.disabled == disabled &&
        other.darkerSub == darkerSub &&
        other.white == white;
  }

  @override
  int get hashCode =>
      Object.hash(strong, sub, soft, disabled, white, darkerSub);
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

  List<Color> get all => [strong, sub, soft, white];

  static GtPaletteStrokeColors lerp(
    GtPaletteStrokeColors? a,
    GtPaletteStrokeColors? b,
    double t,
  ) {
    return GtPaletteStrokeColors(
      strong: Color.lerp(a?.strong, b?.strong, t)!,
      sub: Color.lerp(a?.sub, b?.sub, t)!,
      soft: Color.lerp(a?.soft, b?.soft, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStrokeColors) return false;

    return other.strong == strong &&
        other.sub == sub &&
        other.soft == soft &&
        other.white == white;
  }

  @override
  int get hashCode => Object.hash(strong, sub, soft, white);
}

/// Colors representing semantic UI states and structural feedback.
///
/// Includes various shades (dark to lighter) to support different component
/// architectures, such as subtle backgrounds for alerts or strong fills for badges.
class GtPaletteStateColors {
  final Color darker;
  final Color dark;
  final Color base;
  final Color light;
  final Color lighter;

  const GtPaletteStateColors({
    required this.darker,
    required this.dark,
    required this.base,
    required this.light,
    required this.lighter,
  });

  List<Color> get all => [darker, dark, base, light, lighter];

  static GtPaletteStateColors lerp(
    GtPaletteStateColors? a,
    GtPaletteStateColors? b,
    double t,
  ) {
    return GtPaletteStateColors(
      darker: Color.lerp(a?.darker, b?.darker, t)!,
      dark: Color.lerp(a?.dark, b?.dark, t)!,
      base: Color.lerp(a?.base, b?.base, t)!,
      light: Color.lerp(a?.light, b?.light, t)!,
      lighter: Color.lerp(a?.lighter, b?.lighter, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStateColors) return false;

    return other.dark == dark &&
        other.base == base &&
        other.darker == darker &&
        other.light == light &&
        other.lighter == lighter;
  }

  @override
  int get hashCode => Object.hash(darker, dark, base, light, lighter);
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

  // Cover
  final GtPaletteCoverColors coverColors;

  // Neutral
  final GtPaletteStaticColors staticColors;
  final GtPaletteBgColors bg;
  final GtPaletteTextColors text;
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
    required this.coverColors,
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

  List<Color> get all => [
    ...primary.all,
    ...coverColors.all,
    ...staticColors.all,
    ...bg.all,
    ...text.all,
    ...stroke.all,
    ...icon.all,
    ...faded.all,
    ...information.all,
    ...warning.all,
    ...error.all,
    ...success.all,
    ...away.all,
    ...feature.all,
    ...verified.all,
    ...highlighted.all,
    ...stable.all,
  ];

  @override
  ThemeExtension<GtPalette> lerp(
    covariant ThemeExtension<GtPalette>? other,
    double t,
  ) {
    if (other is! GtPalette) return this;

    return GtPalette(
      primary: GtPaletteBrandColors.lerp(primary, other.primary, t),
      coverColors: GtPaletteCoverColors.lerp(coverColors, other.coverColors, t),
      staticColors: GtPaletteStaticColors.lerp(
        staticColors,
        other.staticColors,
        t,
      ),
      bg: GtPaletteBgColors.lerp(bg, other.bg, t),
      text: GtPaletteTextColors.lerp(text, other.text, t),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPalette) return false;

    return other.primary == primary &&
        other.coverColors == coverColors &&
        other.staticColors == staticColors &&
        other.bg == bg &&
        other.text == text &&
        other.stroke == stroke &&
        other.icon == icon &&
        other.faded == faded &&
        other.information == information &&
        other.warning == warning &&
        other.error == error &&
        other.success == success &&
        other.away == away &&
        other.feature == feature &&
        other.verified == verified &&
        other.highlighted == highlighted &&
        other.stable == stable;
  }

  @override
  int get hashCode => Object.hash(
    primary,
    coverColors,
    staticColors,
    bg,
    text,
    stroke,
    icon,
    faded,
    information,
    warning,
    error,
    success,
    away,
    feature,
    verified,
    highlighted,
    stable,
  );
}
