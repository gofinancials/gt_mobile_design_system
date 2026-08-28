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

/// Represents the raw unmapped primitive [GtColors] resolved for a specific theme mode.
///
/// Use this when you need direct access to a specific brand token (e.g. `context.palette.raw.blue500`
/// or `context.palette.rawColors.neutral950`) without going through semantic slot mappings.
///
/// In [GtLightPalette], this resolves to [GtColors.value] (the light/default variant).
/// In [GtDarkPalette], this resolves to [GtColors.dark] (the dark mode variant).
class GtPaletteRawColors {
  final bool isDark;

  const GtPaletteRawColors({this.isDark = false});

  const GtPaletteRawColors.light() : isDark = false;
  const GtPaletteRawColors.dark() : isDark = true;

  Color _resolve(GtColors color) => isDark ? color.dark : color.value;

  /// Resolves the given [GtColors] enum token according to the active theme mode.
  Color call(GtColors color) => _resolve(color);

  /// Resolves the given [GtColors] enum token according to the active theme mode.
  Color operator [](GtColors color) => _resolve(color);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORSETS
  // ---------------------------------------------------------------------------
  Color get ash => _resolve(GtColors.ash);
  Color get night => _resolve(GtColors.night);
  Color get white => _resolve(GtColors.white);
  Color get cream => _resolve(GtColors.cream);
  Color get black => _resolve(GtColors.black);
  Color get tertiaryText => _resolve(GtColors.tertiaryText);
  Color get transparent => _resolve(GtColors.transparent);

  // ---------------------------------------------------------------------------
  // NEUTRAL / TEXT
  // ---------------------------------------------------------------------------
  Color get neutral950 => _resolve(GtColors.neutral950);
  Color get neutral800 => _resolve(GtColors.neutral800);
  Color get neutral700 => _resolve(GtColors.neutral700);
  Color get neutral600 => _resolve(GtColors.neutral600);
  Color get neutral500 => _resolve(GtColors.neutral500);
  Color get neutral400 => _resolve(GtColors.neutral400);
  Color get neutral300 => _resolve(GtColors.neutral300);
  Color get neutral200 => _resolve(GtColors.neutral200);
  Color get neutral100 => _resolve(GtColors.neutral100);
  Color get neutral50 => _resolve(GtColors.neutral50);
  Color get neutral25 => _resolve(GtColors.neutral25);
  Color get neutral12 => _resolve(GtColors.neutral12);
  Color get neutral0 => _resolve(GtColors.neutral0);

  // ---------------------------------------------------------------------------
  // NEUTRAL / GRAY
  // ---------------------------------------------------------------------------
  Color get neutralGray950 => _resolve(GtColors.neutralGray950);
  Color get neutralGray900 => _resolve(GtColors.neutralGray900);
  Color get neutralGray800 => _resolve(GtColors.neutralGray800);
  Color get neutralGray700 => _resolve(GtColors.neutralGray700);
  Color get neutralGray600 => _resolve(GtColors.neutralGray600);
  Color get neutralGray500 => _resolve(GtColors.neutralGray500);
  Color get neutralGray400 => _resolve(GtColors.neutralGray400);
  Color get neutralGray300 => _resolve(GtColors.neutralGray300);
  Color get neutralGray200 => _resolve(GtColors.neutralGray200);
  Color get neutralGray100 => _resolve(GtColors.neutralGray100);
  Color get neutralGray50 => _resolve(GtColors.neutralGray50);
  Color get neutralWarm50 => _resolve(GtColors.neutralWarm50);
  Color get neutralGray0 => _resolve(GtColors.neutralGray0);

  // ---------------------------------------------------------------------------
  // VIBRANTS - BLUE
  // ---------------------------------------------------------------------------
  Color get blue950 => _resolve(GtColors.blue950);
  Color get blue900 => _resolve(GtColors.blue900);
  Color get blue800 => _resolve(GtColors.blue800);
  Color get blue700 => _resolve(GtColors.blue700);
  Color get blue600 => _resolve(GtColors.blue600);
  Color get blue500 => _resolve(GtColors.blue500);
  Color get blue400 => _resolve(GtColors.blue400);
  Color get blue300 => _resolve(GtColors.blue300);
  Color get blue200 => _resolve(GtColors.blue200);
  Color get blue100 => _resolve(GtColors.blue100);
  Color get blue50 => _resolve(GtColors.blue50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - ORANGE
  // ---------------------------------------------------------------------------
  Color get orange950 => _resolve(GtColors.orange950);
  Color get orange900 => _resolve(GtColors.orange900);
  Color get orange800 => _resolve(GtColors.orange800);
  Color get orange700 => _resolve(GtColors.orange700);
  Color get orange600 => _resolve(GtColors.orange600);
  Color get orange500 => _resolve(GtColors.orange500);
  Color get orange400 => _resolve(GtColors.orange400);
  Color get orange300 => _resolve(GtColors.orange300);
  Color get orange200 => _resolve(GtColors.orange200);
  Color get orange100 => _resolve(GtColors.orange100);
  Color get orange50 => _resolve(GtColors.orange50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - RED
  // ---------------------------------------------------------------------------
  Color get red950 => _resolve(GtColors.red950);
  Color get red900 => _resolve(GtColors.red900);
  Color get red800 => _resolve(GtColors.red800);
  Color get red700 => _resolve(GtColors.red700);
  Color get red600 => _resolve(GtColors.red600);
  Color get red500 => _resolve(GtColors.red500);
  Color get red400 => _resolve(GtColors.red400);
  Color get red300 => _resolve(GtColors.red300);
  Color get red200 => _resolve(GtColors.red200);
  Color get red100 => _resolve(GtColors.red100);
  Color get red50 => _resolve(GtColors.red50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - GREEN
  // ---------------------------------------------------------------------------
  Color get green950 => _resolve(GtColors.green950);
  Color get green925 => _resolve(GtColors.green925);
  Color get green900 => _resolve(GtColors.green900);
  Color get green800 => _resolve(GtColors.green800);
  Color get green700 => _resolve(GtColors.green700);
  Color get green600 => _resolve(GtColors.green600);
  Color get green500 => _resolve(GtColors.green500);
  Color get green400 => _resolve(GtColors.green400);
  Color get green300 => _resolve(GtColors.green300);
  Color get green200 => _resolve(GtColors.green200);
  Color get green100 => _resolve(GtColors.green100);
  Color get green50 => _resolve(GtColors.green50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - YELLOW
  // ---------------------------------------------------------------------------
  Color get yellow950 => _resolve(GtColors.yellow950);
  Color get yellow900 => _resolve(GtColors.yellow900);
  Color get yellow800 => _resolve(GtColors.yellow800);
  Color get yellow700 => _resolve(GtColors.yellow700);
  Color get yellow600 => _resolve(GtColors.yellow600);
  Color get yellow500 => _resolve(GtColors.yellow500);
  Color get yellow400 => _resolve(GtColors.yellow400);
  Color get yellow300 => _resolve(GtColors.yellow300);
  Color get yellow200 => _resolve(GtColors.yellow200);
  Color get yellow100 => _resolve(GtColors.yellow100);
  Color get yellow50 => _resolve(GtColors.yellow50);
  Color get yellow25 => _resolve(GtColors.yellow25);

  // ---------------------------------------------------------------------------
  // VIBRANTS - PURPLE
  // ---------------------------------------------------------------------------
  Color get purple950 => _resolve(GtColors.purple950);
  Color get purple900 => _resolve(GtColors.purple900);
  Color get purple800 => _resolve(GtColors.purple800);
  Color get purple700 => _resolve(GtColors.purple700);
  Color get purple600 => _resolve(GtColors.purple600);
  Color get purple500 => _resolve(GtColors.purple500);
  Color get purple400 => _resolve(GtColors.purple400);
  Color get purple300 => _resolve(GtColors.purple300);
  Color get purple200 => _resolve(GtColors.purple200);
  Color get purple100 => _resolve(GtColors.purple100);
  Color get purple50 => _resolve(GtColors.purple50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - PINK
  // ---------------------------------------------------------------------------
  Color get pink950 => _resolve(GtColors.pink950);
  Color get pink900 => _resolve(GtColors.pink900);
  Color get pink800 => _resolve(GtColors.pink800);
  Color get pink700 => _resolve(GtColors.pink700);
  Color get pink600 => _resolve(GtColors.pink600);
  Color get pink500 => _resolve(GtColors.pink500);
  Color get pink400 => _resolve(GtColors.pink400);
  Color get pink300 => _resolve(GtColors.pink300);
  Color get pink200 => _resolve(GtColors.pink200);
  Color get pink100 => _resolve(GtColors.pink100);
  Color get pink50 => _resolve(GtColors.pink50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL
  // ---------------------------------------------------------------------------
  Color get teal950 => _resolve(GtColors.teal950);
  Color get teal900 => _resolve(GtColors.teal900);
  Color get teal800 => _resolve(GtColors.teal800);
  Color get teal700 => _resolve(GtColors.teal700);
  Color get teal600 => _resolve(GtColors.teal600);
  Color get teal500 => _resolve(GtColors.teal500);
  Color get teal400 => _resolve(GtColors.teal400);
  Color get teal300 => _resolve(GtColors.teal300);
  Color get teal200 => _resolve(GtColors.teal200);
  Color get teal100 => _resolve(GtColors.teal100);
  Color get teal50 => _resolve(GtColors.teal50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL BLUE
  // ---------------------------------------------------------------------------
  Color get tealBlue800 => _resolve(GtColors.tealBlue800);
  Color get tealBlue700 => _resolve(GtColors.tealBlue700);
  Color get tealBlue600 => _resolve(GtColors.tealBlue600);

  // ---------------------------------------------------------------------------
  // VIBRANTS - SKY
  // ---------------------------------------------------------------------------
  Color get sky950 => _resolve(GtColors.sky950);
  Color get sky900 => _resolve(GtColors.sky900);
  Color get sky800 => _resolve(GtColors.sky800);
  Color get sky700 => _resolve(GtColors.sky700);
  Color get sky600 => _resolve(GtColors.sky600);
  Color get sky500 => _resolve(GtColors.sky500);
  Color get sky400 => _resolve(GtColors.sky400);
  Color get sky300 => _resolve(GtColors.sky300);
  Color get sky200 => _resolve(GtColors.sky200);
  Color get sky100 => _resolve(GtColors.sky100);
  Color get sky50 => _resolve(GtColors.sky50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - MAROON
  // ---------------------------------------------------------------------------
  Color get maroon800 => _resolve(GtColors.maroon800);
  Color get maroon700 => _resolve(GtColors.maroon700);
  Color get maroon600 => _resolve(GtColors.maroon600);

  // ---------------------------------------------------------------------------
  // ALPHA COLORSETS
  // ---------------------------------------------------------------------------
  Color get blueAlpha24 => _resolve(GtColors.blueAlpha24);
  Color get blueAlpha16 => _resolve(GtColors.blueAlpha16);
  Color get blueAlpha15 => _resolve(GtColors.blueAlpha15);
  Color get blueAlpha10 => _resolve(GtColors.blueAlpha10);
  Color get blueAlpha8 => _resolve(GtColors.blueAlpha8);
  Color get blueAlpha3 => _resolve(GtColors.blueAlpha3);

  Color get navyAlpha24 => _resolve(GtColors.navyAlpha24);
  Color get navyAlpha16 => _resolve(GtColors.navyAlpha16);
  Color get navyAlpha15 => _resolve(GtColors.navyAlpha15);
  Color get navyAlpha10 => _resolve(GtColors.navyAlpha10);
  Color get navyAlpha8 => _resolve(GtColors.navyAlpha8);
  Color get navyAlpha3 => _resolve(GtColors.navyAlpha3);

  Color get orangeAlpha24 => _resolve(GtColors.orangeAlpha24);
  Color get orangeAlpha16 => _resolve(GtColors.orangeAlpha16);
  Color get orangeAlpha15 => _resolve(GtColors.orangeAlpha15);
  Color get orangeAlpha10 => _resolve(GtColors.orangeAlpha10);
  Color get orangeAlpha8 => _resolve(GtColors.orangeAlpha8);
  Color get orangeAlpha3 => _resolve(GtColors.orangeAlpha3);

  Color get redAlpha24 => _resolve(GtColors.redAlpha24);
  Color get redAlpha16 => _resolve(GtColors.redAlpha16);
  Color get redAlpha15 => _resolve(GtColors.redAlpha15);
  Color get redAlpha10 => _resolve(GtColors.redAlpha10);
  Color get redAlpha8 => _resolve(GtColors.redAlpha8);
  Color get redAlpha3 => _resolve(GtColors.redAlpha3);

  Color get greenAlpha24 => _resolve(GtColors.greenAlpha24);
  Color get greenAlpha16 => _resolve(GtColors.greenAlpha16);
  Color get greenAlpha15 => _resolve(GtColors.greenAlpha15);
  Color get greenAlpha10 => _resolve(GtColors.greenAlpha10);
  Color get greenAlpha8 => _resolve(GtColors.greenAlpha8);
  Color get greenAlpha3 => _resolve(GtColors.greenAlpha3);

  Color get yellowAlpha24 => _resolve(GtColors.yellowAlpha24);
  Color get yellowAlpha16 => _resolve(GtColors.yellowAlpha16);
  Color get yellowAlpha15 => _resolve(GtColors.yellowAlpha15);
  Color get yellowAlpha10 => _resolve(GtColors.yellowAlpha10);
  Color get yellowAlpha8 => _resolve(GtColors.yellowAlpha8);
  Color get yellowAlpha3 => _resolve(GtColors.yellowAlpha3);

  Color get skyAlpha24 => _resolve(GtColors.skyAlpha24);
  Color get skyAlpha16 => _resolve(GtColors.skyAlpha16);
  Color get skyAlpha15 => _resolve(GtColors.skyAlpha15);
  Color get skyAlpha10 => _resolve(GtColors.skyAlpha10);
  Color get skyAlpha8 => _resolve(GtColors.skyAlpha8);
  Color get skyAlpha3 => _resolve(GtColors.skyAlpha3);

  Color get purpleAlpha24 => _resolve(GtColors.purpleAlpha24);
  Color get purpleAlpha16 => _resolve(GtColors.purpleAlpha16);
  Color get purpleAlpha15 => _resolve(GtColors.purpleAlpha15);
  Color get purpleAlpha10 => _resolve(GtColors.purpleAlpha10);
  Color get purpleAlpha8 => _resolve(GtColors.purpleAlpha8);
  Color get purpleAlpha3 => _resolve(GtColors.purpleAlpha3);

  Color get pinkAlpha24 => _resolve(GtColors.pinkAlpha24);
  Color get pinkAlpha16 => _resolve(GtColors.pinkAlpha16);
  Color get pinkAlpha15 => _resolve(GtColors.pinkAlpha15);
  Color get pinkAlpha10 => _resolve(GtColors.pinkAlpha10);
  Color get pinkAlpha8 => _resolve(GtColors.pinkAlpha8);
  Color get pinkAlpha3 => _resolve(GtColors.pinkAlpha3);

  Color get tealAlpha24 => _resolve(GtColors.tealAlpha24);
  Color get tealAlpha16 => _resolve(GtColors.tealAlpha16);
  Color get tealAlpha15 => _resolve(GtColors.tealAlpha15);
  Color get tealAlpha10 => _resolve(GtColors.tealAlpha10);
  Color get tealAlpha8 => _resolve(GtColors.tealAlpha8);
  Color get tealAlpha3 => _resolve(GtColors.tealAlpha3);

  Color get tealBlueAlpha24 => _resolve(GtColors.tealBlueAlpha24);
  Color get tealBlueAlpha16 => _resolve(GtColors.tealBlueAlpha16);
  Color get tealBlueAlpha15 => _resolve(GtColors.tealBlueAlpha15);
  Color get tealBlueAlpha10 => _resolve(GtColors.tealBlueAlpha10);
  Color get tealBlueAlpha8 => _resolve(GtColors.tealBlueAlpha8);
  Color get tealBlueAlpha3 => _resolve(GtColors.tealBlueAlpha3);

  Color get whiteAlpha24 => _resolve(GtColors.whiteAlpha24);
  Color get whiteAlpha16 => _resolve(GtColors.whiteAlpha16);
  Color get whiteAlpha15 => _resolve(GtColors.whiteAlpha15);
  Color get whiteAlpha10 => _resolve(GtColors.whiteAlpha10);
  Color get whiteAlpha8 => _resolve(GtColors.whiteAlpha8);
  Color get whiteAlpha3 => _resolve(GtColors.whiteAlpha3);

  Color get neutralAlpha24 => _resolve(GtColors.neutralAlpha24);
  Color get neutralAlpha16 => _resolve(GtColors.neutralAlpha16);
  Color get neutralAlpha15 => _resolve(GtColors.neutralAlpha15);
  Color get neutralAlpha10 => _resolve(GtColors.neutralAlpha10);
  Color get neutralAlpha8 => _resolve(GtColors.neutralAlpha8);
  Color get neutralAlpha3 => _resolve(GtColors.neutralAlpha3);

  Color get blackAlpha24 => _resolve(GtColors.blackAlpha24);
  Color get blackAlpha16 => _resolve(GtColors.blackAlpha16);
  Color get blackAlpha15 => _resolve(GtColors.blackAlpha15);
  Color get blackAlpha10 => _resolve(GtColors.blackAlpha10);
  Color get blackAlpha8 => _resolve(GtColors.blackAlpha8);
  Color get blackAlpha3 => _resolve(GtColors.blackAlpha3);

  Color get maroonAlpha24 => _resolve(GtColors.maroonAlpha24);
  Color get maroonAlpha16 => _resolve(GtColors.maroonAlpha16);
  Color get maroonAlpha15 => _resolve(GtColors.maroonAlpha15);
  Color get maroonAlpha10 => _resolve(GtColors.maroonAlpha10);
  Color get maroonAlpha8 => _resolve(GtColors.maroonAlpha8);
  Color get maroonAlpha3 => _resolve(GtColors.maroonAlpha3);

  Color get skyAlpha5 => _resolve(GtColors.skyAlpha5);
  Color get darkGreen => _resolve(GtColors.darkGreen);
  Color get lemon => _resolve(GtColors.lemon);
  Color get blue => _resolve(GtColors.blue);
  Color get navy => _resolve(GtColors.navy);

  List<Color> get all => GtColors.values.map(_resolve).toList();

  static GtPaletteRawColors lerp(
    GtPaletteRawColors? a,
    GtPaletteRawColors? b,
    double t,
  ) {
    if (t < 0.5) return a ?? const GtPaletteRawColors.light();
    return b ?? const GtPaletteRawColors.dark();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteRawColors) return false;
    return other.isDark == isDark;
  }

  @override
  int get hashCode => isDark.hashCode;
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

  /// Direct access to the raw [GtColors] design tokens resolved for this palette's mode.
  GtPaletteRawColors get raw => const GtPaletteRawColors.light();

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
    ...raw.all,
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

  @override
  GtPaletteRawColors get raw => const GtPaletteRawColors.dark();
}
