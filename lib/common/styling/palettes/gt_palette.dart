import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/common/styling/gt_colors.dart';

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
  final Color transparent;

  const GtPaletteStaticColors({
    required this.black,
    required this.white,
    required this.shadow,
    required this.transparent,
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
      transparent: Color.lerp(a?.transparent, b?.transparent, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStaticColors) return false;

    return other.black == black &&
        other.white == white &&
        other.shadow == shadow &&
        other.transparent == transparent;
  }

  @override
  int get hashCode => Object.hash(black, white, shadow, transparent);
}

/// Dedicated semantic colors and gradient stops for styling physical and virtual
/// payment cards (e.g., Classic, Business, Prime, and World card tiers).
class GtPaletteCardColors {
  /// Base background color for Classic tier payment cards.
  final Color classic;

  /// Base background color for Business tier payment cards.
  final Color business;

  /// Base background color for Prime tier payment cards.
  final Color prime;

  /// First color stop for World/Premium tier gradient payment cards.
  final Color worldStop1;

  /// Second color stop for World/Premium tier gradient payment cards.
  final Color worldStop2;

  /// Third color stop for World/Premium tier gradient payment cards.
  final Color worldStop3;

  const GtPaletteCardColors({
    required this.classic,
    required this.business,
    required this.prime,
    required this.worldStop1,
    required this.worldStop2,
    required this.worldStop3,
  });

  /// Returns the color gradient used for the World/Premium card tier backgrounds,
  /// blending the three distinct color stops from left to right.
  LinearGradient get worldGradient => LinearGradient(
    begin: .centerLeft,
    end: .centerRight,
    stops: [0, .48, 1],
    colors: [worldStop1, worldStop2, worldStop3],
  );

  /// Returns a list of all primary colors and gradient stops used across all card tiers,
  /// including Classic, Business, Prime, and the multi-stop World/Premium gradient.
  List<Color> get all => [
    classic,
    business,
    prime,
    worldStop1,
    worldStop2,
    worldStop3,
  ];

  static GtPaletteCardColors lerp(
    GtPaletteCardColors? a,
    GtPaletteCardColors? b,
    double t,
  ) {
    return GtPaletteCardColors(
      classic: Color.lerp(a?.classic, b?.classic, t)!,
      business: Color.lerp(a?.business, b?.business, t)!,
      prime: Color.lerp(a?.prime, b?.prime, t)!,
      worldStop1: Color.lerp(a?.worldStop1, b?.worldStop1, t)!,
      worldStop2: Color.lerp(a?.worldStop2, b?.worldStop2, t)!,
      worldStop3: Color.lerp(a?.worldStop3, b?.worldStop3, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteCardColors) return false;

    return other.classic == classic &&
        other.business == business &&
        other.prime == prime &&
        other.worldStop1 == worldStop1 &&
        other.worldStop2 == worldStop2 &&
        other.worldStop3 == worldStop3;
  }

  @override
  int get hashCode =>
      Object.hash(classic, business, prime, worldStop1, worldStop2, worldStop3);
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
  final Color weaker;
  final Color white;
  final Color warm;
  final Color neutralWarm50;
  final Color sky;

  const GtPaletteBgColors({
    required this.strong,
    required this.surface,
    required this.sub,
    required this.soft,
    required this.weak,
    required this.weaker,
    required this.white,
    required this.warm,
    required this.neutralWarm50,
    required this.sky,
  });

  List<Color> get all => [
    strong,
    surface,
    sub,
    soft,
    weak,
    weaker,
    warm,
    neutralWarm50,
    white,
    sky,
  ];

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
      weaker: Color.lerp(a?.weaker, b?.weaker, t)!,
      white: Color.lerp(a?.white, b?.white, t)!,
      neutralWarm50: Color.lerp(a?.neutralWarm50, b?.neutralWarm50, t)!,
      warm: Color.lerp(a?.warm, b?.warm, t)!,
      sky: Color.lerp(a?.sky, b?.sky, t)!,
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
        other.white == white &&
        other.warm == warm &&
        other.sky == sky &&
        other.neutralWarm50 == neutralWarm50;
  }

  @override
  int get hashCode => Object.hash(
    strong,
    surface,
    sub,
    soft,
    weak,
    weaker,
    white,
    neutralWarm50,
  );
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

  // Static
  final GtPaletteStaticColors staticColors;
  final GtPaletteCardColors cardColors;

  // Neutral
  final GtPaletteBgColors bg;
  final GtPaletteBgColors fill;
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
  final GtPaletteStateColors infoAlt;

  const GtPalette({
    required this.primary,
    required this.coverColors,
    required this.staticColors,
    required this.cardColors,
    required this.bg,
    required this.fill,
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
    required this.infoAlt,
  });

  List<Color> get all => [
    ...primary.all,
    ...coverColors.all,
    ...cardColors.all,
    ...staticColors.all,
    ...bg.all,
    ...text.all,
    ...stroke.all,
    ...icon.all,
    ...faded.all,
    ...information.all,
    ...infoAlt.all,
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
      cardColors: GtPaletteCardColors.lerp(cardColors, other.cardColors, t),
      bg: GtPaletteBgColors.lerp(bg, other.bg, t),
      fill: GtPaletteBgColors.lerp(fill, other.fill, t),
      text: GtPaletteTextColors.lerp(text, other.text, t),
      stroke: GtPaletteStrokeColors.lerp(stroke, other.stroke, t),
      icon: GtPaletteContentColors.lerp(icon, other.icon, t),
      faded: GtPaletteStateColors.lerp(faded, other.faded, t),
      information: GtPaletteStateColors.lerp(information, other.information, t),
      infoAlt: GtPaletteStateColors.lerp(infoAlt, other.infoAlt, t),
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
        other.cardColors == cardColors &&
        other.bg == bg &&
        other.fill == fill &&
        other.text == text &&
        other.stroke == stroke &&
        other.icon == icon &&
        other.faded == faded &&
        other.information == information &&
        other.infoAlt == infoAlt &&
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
    fill,
    text,
    stroke,
    icon,
    faded,
    information,
    infoAlt,
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

// -----------------------------------------------------------------------------
// BASE LIGHT & DARK PALETTES
// -----------------------------------------------------------------------------

/// Base class for Light mode palettes providing standard default color definitions.
base class GtLightPalette extends GtPalette {
  GtLightPalette({
    required super.primary,
    required super.coverColors,
    GtPaletteStaticColors? staticColors,
    GtPaletteCardColors? cardColors,
    GtPaletteBgColors? bg,
    GtPaletteBgColors? fill,
    GtPaletteTextColors? text,
    GtPaletteContentColors? icon,
    GtPaletteStrokeColors? stroke,
    GtPaletteStateColors? faded,
    GtPaletteStateColors? information,
    GtPaletteStateColors? infoAlt,
    GtPaletteStateColors? warning,
    GtPaletteStateColors? error,
    GtPaletteStateColors? success,
    GtPaletteStateColors? away,
    GtPaletteStateColors? feature,
    GtPaletteStateColors? verified,
    GtPaletteStateColors? highlighted,
    GtPaletteStateColors? stable,
  }) : super(
         staticColors:
             staticColors ??
             GtPaletteStaticColors(
               black: GtColors.neutral950.value,
               white: GtColors.neutral0.value,
               shadow: GtColors.neutralGray700.value,
               transparent: GtColors.transparent.value,
             ),
         cardColors:
             cardColors ??
             GtPaletteCardColors(
               classic: GtColors.maroon700.value,
               business: GtColors.green925.value,
               prime: GtColors.cream.value,
               worldStop1: GtColors.ash.value,
               worldStop2: GtColors.neutral800.value,
               worldStop3: GtColors.night.value,
             ),
         bg:
             bg ??
             GtPaletteBgColors(
               strong: GtColors.neutral950.value,
               surface: GtColors.neutral800.value,
               sub: GtColors.neutral300.value,
               soft: GtColors.neutral200.value,
               weak: GtColors.neutral50.value,
               white: GtColors.neutral0.value,
               warm: GtColors.yellow25.value,
               neutralWarm50: GtColors.neutralWarm50.value,
               weaker: GtColors.neutral25.value,
               sky: GtColors.skyAlpha5.value,
             ),
         fill:
             fill ??
             GtPaletteBgColors(
               strong: GtColors.neutral950.value,
               surface: GtColors.neutral800.value,
               sub: GtColors.neutral300.value,
               soft: GtColors.neutral200.value,
               weak: GtColors.neutral12.value,
               white: GtColors.neutral0.value,
               warm: GtColors.yellow25.value,
               neutralWarm50: GtColors.neutralWarm50.value,
               weaker: GtColors.neutral25.value,
               sky: GtColors.skyAlpha5.value,
             ),
         text:
             text ??
             GtPaletteTextColors(
               strong: GtColors.neutral950.value,
               sub: GtColors.neutral500.value,
               darkerSub: GtColors.neutral600.value,
               soft: GtColors.neutral400.value,
               disabled: GtColors.neutral300.value,
               white: GtColors.neutral0.value,
             ),
         icon:
             icon ??
             GtPaletteContentColors(
               strong: GtColors.neutral950.value,
               sub: GtColors.neutral600.value,
               soft: GtColors.neutral400.value,
               disabled: GtColors.neutral300.value,
               white: GtColors.neutral0.value,
             ),
         stroke:
             stroke ??
             GtPaletteStrokeColors(
               strong: GtColors.neutral950.value,
               sub: GtColors.neutral300.value,
               soft: GtColors.neutral200.value,
               white: GtColors.neutral0.value,
             ),
         faded:
             faded ??
             GtPaletteStateColors(
               darker: GtColors.neutral700.value,
               dark: GtColors.neutral800.value,
               base: GtColors.neutral500.value,
               light: GtColors.neutral200.value,
               lighter: GtColors.neutral100.value,
             ),
         information:
             information ??
             GtPaletteStateColors(
               darker: GtColors.blue700.value,
               dark: GtColors.blue950.value,
               base: GtColors.blue500.value,
               light: GtColors.blue200.value,
               lighter: GtColors.blue50.value,
             ),
         infoAlt:
             infoAlt ??
             GtPaletteStateColors(
               darker: GtColors.tealBlue800.value,
               dark: GtColors.tealBlue700.value,
               base: GtColors.tealBlue600.value,
               light: GtColors.tealBlueAlpha24.value,
               lighter: GtColors.tealBlueAlpha16.value,
             ),
         warning:
             warning ??
             GtPaletteStateColors(
               darker: GtColors.orange700.value,
               dark: GtColors.orange950.value,
               base: GtColors.orange500.value,
               light: GtColors.orange200.value,
               lighter: GtColors.orange50.value,
             ),
         error:
             error ??
             GtPaletteStateColors(
               darker: GtColors.red700.value,
               dark: GtColors.red950.value,
               base: GtColors.red500.value,
               light: GtColors.red200.value,
               lighter: GtColors.red50.value,
             ),
         success:
             success ??
             GtPaletteStateColors(
               darker: GtColors.green700.value,
               dark: GtColors.green950.value,
               base: GtColors.green500.value,
               light: GtColors.green200.value,
               lighter: GtColors.green50.value,
             ),
         away:
             away ??
             GtPaletteStateColors(
               darker: GtColors.yellow700.value,
               dark: GtColors.yellow950.value,
               base: GtColors.yellow500.value,
               light: GtColors.yellow200.value,
               lighter: GtColors.yellow50.value,
             ),
         feature:
             feature ??
             GtPaletteStateColors(
               darker: GtColors.purple700.value,
               dark: GtColors.purple950.value,
               base: GtColors.purple500.value,
               light: GtColors.purple200.value,
               lighter: GtColors.purple50.value,
             ),
         verified:
             verified ??
             GtPaletteStateColors(
               darker: GtColors.sky700.value,
               dark: GtColors.sky950.value,
               base: GtColors.sky500.value,
               light: GtColors.sky200.value,
               lighter: GtColors.sky50.value,
             ),
         highlighted:
             highlighted ??
             GtPaletteStateColors(
               darker: GtColors.pink700.value,
               dark: GtColors.pink950.value,
               base: GtColors.pink500.value,
               light: GtColors.pink200.value,
               lighter: GtColors.pink50.value,
             ),
         stable:
             stable ??
             GtPaletteStateColors(
               darker: GtColors.teal700.value,
               dark: GtColors.teal950.value,
               base: GtColors.teal500.value,
               light: GtColors.teal200.value,
               lighter: GtColors.teal50.value,
             ),
       );
}

/// Base class for Dark mode palettes providing standard default color definitions.
base class GtDarkPalette extends GtPalette {
  GtDarkPalette({
    required super.primary,
    required super.coverColors,
    GtPaletteStaticColors? staticColors,
    GtPaletteCardColors? cardColors,
    GtPaletteBgColors? bg,
    GtPaletteBgColors? fill,
    GtPaletteTextColors? text,
    GtPaletteContentColors? icon,
    GtPaletteStrokeColors? stroke,
    GtPaletteStateColors? faded,
    GtPaletteStateColors? information,
    GtPaletteStateColors? infoAlt,
    GtPaletteStateColors? warning,
    GtPaletteStateColors? error,
    GtPaletteStateColors? success,
    GtPaletteStateColors? away,
    GtPaletteStateColors? feature,
    GtPaletteStateColors? verified,
    GtPaletteStateColors? highlighted,
    GtPaletteStateColors? stable,
  }) : super(
         staticColors:
             staticColors ??
             GtPaletteStaticColors(
               black: GtColors.neutral950.value,
               white: GtColors.neutral0.value,
               shadow: GtColors.neutralGray700.dark,
               transparent: GtColors.transparent.value,
             ),
         cardColors:
             cardColors ??
             GtPaletteCardColors(
               classic: GtColors.maroon700.value,
               business: GtColors.green925.value,
               prime: GtColors.cream.value,
               worldStop1: GtColors.ash.value,
               worldStop2: GtColors.neutral800.value,
               worldStop3: GtColors.night.value,
             ),
         bg:
             bg ??
             GtPaletteBgColors(
               strong: GtColors.neutral950.dark,
               surface: GtColors.neutral800.dark,
               sub: GtColors.neutral300.dark,
               soft: GtColors.neutral200.dark,
               weak: GtColors.neutral50.dark,
               white: GtColors.neutral0.dark,
               warm: GtColors.yellow25.dark,
               neutralWarm50: GtColors.neutralWarm50.dark,
               weaker: GtColors.neutral25.dark,
               sky: GtColors.neutral200.dark,
             ),
         fill:
             fill ??
             GtPaletteBgColors(
               strong: GtColors.neutral950.dark,
               surface: GtColors.neutral800.dark,
               sub: GtColors.neutral300.dark,
               soft: GtColors.neutral200.dark,
               weak: GtColors.neutral12.dark,
               white: GtColors.neutral0.dark,
               warm: GtColors.yellow25.dark,
               neutralWarm50: GtColors.neutralWarm50.dark,
               weaker: GtColors.neutral25.dark,
               sky: GtColors.neutral200.dark,
             ),
         text:
             text ??
             GtPaletteTextColors(
               strong: GtColors.neutral950.dark,
               sub: GtColors.neutral500.dark,
               darkerSub: GtColors.neutral600.dark,
               soft: GtColors.neutral400.dark,
               disabled: GtColors.neutral300.dark,
               white: GtColors.neutral0.dark,
             ),
         icon:
             icon ??
             GtPaletteContentColors(
               strong: GtColors.neutral950.dark,
               sub: GtColors.neutral600.dark,
               soft: GtColors.neutral400.dark,
               disabled: GtColors.neutral300.dark,
               white: GtColors.neutral0.dark,
             ),
         stroke:
             stroke ??
             GtPaletteStrokeColors(
               strong: GtColors.neutral950.dark,
               sub: GtColors.neutral300.dark,
               soft: GtColors.neutral200.dark,
               white: GtColors.neutral0.dark,
             ),
         faded:
             faded ??
             GtPaletteStateColors(
               darker: GtColors.neutral200.value,
               dark: GtColors.neutral300.value,
               base: GtColors.neutral500.value,
               light: GtColors.neutralAlpha24.value,
               lighter: GtColors.neutralAlpha16.value,
             ),
         information:
             information ??
             GtPaletteStateColors(
               darker: GtColors.blue200.value,
               dark: GtColors.blue400.value,
               base: GtColors.blue600.value,
               light: GtColors.blueAlpha24.value,
               lighter: GtColors.blueAlpha16.value,
             ),
         infoAlt:
             infoAlt ??
             GtPaletteStateColors(
               darker: GtColors.tealBlue600.value,
               dark: GtColors.tealBlue700.value,
               base: GtColors.tealBlue800.value,
               light: GtColors.tealBlueAlpha24.value,
               lighter: GtColors.tealBlueAlpha16.value,
             ),
         warning:
             warning ??
             GtPaletteStateColors(
               darker: GtColors.orange200.value,
               dark: GtColors.orange400.value,
               base: GtColors.orange600.value,
               light: GtColors.orangeAlpha24.value,
               lighter: GtColors.orangeAlpha16.value,
             ),
         error:
             error ??
             GtPaletteStateColors(
               darker: GtColors.red200.value,
               dark: GtColors.red400.value,
               base: GtColors.red600.value,
               light: GtColors.redAlpha24.value,
               lighter: GtColors.redAlpha16.value,
             ),
         success:
             success ??
             GtPaletteStateColors(
               darker: GtColors.green200.value,
               dark: GtColors.green400.value,
               base: GtColors.green600.value,
               light: GtColors.greenAlpha24.value,
               lighter: GtColors.greenAlpha16.value,
             ),
         away:
             away ??
             GtPaletteStateColors(
               darker: GtColors.yellow200.value,
               dark: GtColors.yellow400.value,
               base: GtColors.yellow600.value,
               light: GtColors.yellowAlpha24.value,
               lighter: GtColors.yellowAlpha16.value,
             ),
         feature:
             feature ??
             GtPaletteStateColors(
               darker: GtColors.purple200.value,
               dark: GtColors.purple400.value,
               base: GtColors.purple600.value,
               light: GtColors.purpleAlpha24.value,
               lighter: GtColors.purpleAlpha16.value,
             ),
         verified:
             verified ??
             GtPaletteStateColors(
               darker: GtColors.sky200.value,
               dark: GtColors.sky400.value,
               base: GtColors.sky600.value,
               light: GtColors.skyAlpha24.value,
               lighter: GtColors.skyAlpha16.value,
             ),
         highlighted:
             highlighted ??
             GtPaletteStateColors(
               darker: GtColors.pink200.value,
               dark: GtColors.pink400.value,
               base: GtColors.pink600.value,
               light: GtColors.pinkAlpha24.value,
               lighter: GtColors.pinkAlpha16.value,
             ),
         stable:
             stable ??
             GtPaletteStateColors(
               darker: GtColors.teal200.value,
               dark: GtColors.teal400.value,
               base: GtColors.teal600.value,
               light: GtColors.tealAlpha24.value,
               lighter: GtColors.tealAlpha16.value,
             ),
       );
}
