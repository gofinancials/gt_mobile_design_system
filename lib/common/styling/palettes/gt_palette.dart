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
  /// The deep brand shade, used where the brand color must read strongly.
  final Color dark;

  /// The deepest brand shade, used for brand ink such as text and status bars.
  final Color darker;

  /// The main brand color, used for primary actions and accents.
  final Color base;

  /// The brand color at 24% opacity, for pressed and selected states.
  final Color alpha24;

  /// The brand color at 16% opacity, for splashes and tinted containers.
  final Color alpha16;

  /// The brand color at 10% opacity, for hover, focus and highlight states.
  final Color alpha10;

  /// Creates a [GtPaletteBrandColors].
  const GtPaletteBrandColors({
    required this.dark,
    required this.darker,
    required this.base,
    required this.alpha24,
    required this.alpha16,
    required this.alpha10,
  });

  /// Every color in this group, in declaration order.
  List<Color> get all => [dark, darker, base, alpha24, alpha16, alpha10];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteBrandColors] are equal when all their colors except
  /// [alpha24] are equal.
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

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode => Object.hash(dark, darker, base, alpha16, alpha10);
}

/// Colors that remain absolutely constant regardless of the active theme
/// (e.g., absolute black and absolute white). Typically used where extreme
/// contrast must be guaranteed regardless of Light/Dark mode contexts.
class GtPaletteStaticColors {
  /// Absolute black, the same in every theme mode.
  final Color black;

  /// Absolute white, the same in every theme mode.
  final Color white;

  /// The base color for drop shadows.
  final Color shadow;

  /// A fully transparent color.
  final Color transparent;

  /// Creates a [GtPaletteStaticColors].
  const GtPaletteStaticColors({
    required this.black,
    required this.white,
    required this.shadow,
    required this.transparent,
  });

  /// The [black], [white] and [shadow] colors, in that order.
  List<Color> get all => [black, white, shadow];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteStaticColors] are equal when all their colors are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStaticColors) return false;

    return other.black == black &&
        other.white == white &&
        other.shadow == shadow &&
        other.transparent == transparent;
  }

  /// A hash of the same colors that [operator ==] compares.
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

  /// Creates a [GtPaletteCardColors].
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

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteCardColors] are equal when all their colors are equal.
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

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode =>
      Object.hash(classic, business, prime, worldStop1, worldStop2, worldStop3);
}

/// Colors specifically tailored for large cover areas, marketing screens, or
/// specialized background treatments, providing distinct light and dark variants.
class GtPaletteCoverColors {
  /// The light cover color.
  final Color light;

  /// The dark cover color.
  final Color dark;

  /// Creates a [GtPaletteCoverColors].
  const GtPaletteCoverColors({required this.light, required this.dark});

  /// Every color in this group, in declaration order.
  List<Color> get all => [light, dark];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteCoverColors] are equal when all their colors are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteCoverColors) return false;

    return other.light == light && other.dark == dark;
  }

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode => Object.hash(light, dark);
}

/// Semantic backgrounds used to establish visual hierarchy and elevation.
///
/// Naming ranges from [strong] (most prominent) to [weak] (subtlest), allowing
/// surfaces and cards to naturally adapt their depths across Light and Dark modes.
class GtPaletteBgColors {
  /// The most prominent background, used for high-emphasis surfaces.
  final Color strong;

  /// A dark, high-emphasis surface just below [strong].
  final Color surface;

  /// A mid-emphasis background.
  final Color sub;

  /// A soft background, lighter than [sub].
  final Color soft;

  /// A weak background, used for subtle surfaces.
  final Color weak;

  /// The subtlest tinted background, lighter than [weak].
  final Color weaker;

  /// The plain white background for the active theme mode.
  final Color white;

  /// A warm-tinted background.
  final Color warm;

  /// The warm neutral 50 background.
  final Color neutralWarm50;

  /// A sky-tinted background, used in gradients.
  final Color sky;

  /// Creates a [GtPaletteBgColors].
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

  /// Returns a copy of these backgrounds with the given colors replaced.
  GtPaletteBgColors copyWith({
    Color? strong,
    Color? surface,
    Color? sub,
    Color? soft,
    Color? weak,
    Color? weaker,
    Color? white,
    Color? warm,
    Color? neutralWarm50,
    Color? sky,
  }) {
    return GtPaletteBgColors(
      strong: strong ?? this.strong,
      surface: surface ?? this.surface,
      sub: sub ?? this.sub,
      soft: soft ?? this.soft,
      weak: weak ?? this.weak,
      weaker: weaker ?? this.weaker,
      white: white ?? this.white,
      warm: warm ?? this.warm,
      neutralWarm50: neutralWarm50 ?? this.neutralWarm50,
      sky: sky ?? this.sky,
    );
  }

  /// Every background color in this group.
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

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteBgColors] are equal when all their colors except [weaker]
  /// are equal.
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

  /// A hash of every color in this group except [warm] and [sky].
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
  /// The most prominent content color, used for primary text and icons.
  final Color strong;

  /// A secondary content color, used for supporting text and icons.
  final Color sub;

  /// A soft content color, used for tertiary text and icons.
  final Color soft;

  /// The content color for disabled elements.
  final Color disabled;

  /// The white content color, used on dark or brand backgrounds.
  final Color white;

  /// Creates a [GtPaletteContentColors].
  const GtPaletteContentColors({
    required this.strong,
    required this.sub,
    required this.soft,
    required this.disabled,
    required this.white,
  });

  /// Every color in this group, in declaration order.
  List<Color> get all => [strong, sub, soft, disabled, white];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteContentColors] are equal when all their colors are equal.
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

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode => Object.hash(strong, sub, soft, disabled, white);
}

/// Colors applied to text.
///
/// Adds [darkerSub], a deeper secondary text color, to the
/// [GtPaletteContentColors] set.
class GtPaletteTextColors extends GtPaletteContentColors {
  /// A secondary text color, darker than [sub].
  final Color darkerSub;

  /// Creates a [GtPaletteTextColors].
  const GtPaletteTextColors({
    required super.strong,
    required super.sub,
    required super.soft,
    required super.disabled,
    required super.white,
    required this.darkerSub,
  });

  /// Every text color, with [darkerSub] after the inherited ones.
  @override
  List<Color> get all => [...super.all, darkerSub];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteTextColors] are equal when all their colors are equal.
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

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode =>
      Object.hash(strong, sub, soft, disabled, white, darkerSub);
}

/// Colors used for boundaries, such as borders, dividers, and outlines.
///
/// Helps delineate structural areas without visually overwhelming the core content.
class GtPaletteStrokeColors {
  /// The most prominent stroke, used for high-emphasis borders.
  final Color strong;

  /// A mid-emphasis stroke, used for standard borders and dividers.
  final Color sub;

  /// A soft stroke, used for subtle borders and dividers.
  final Color soft;

  /// The white stroke, used on dark or brand backgrounds.
  final Color white;

  /// Creates a [GtPaletteStrokeColors].
  const GtPaletteStrokeColors({
    required this.strong,
    required this.sub,
    required this.soft,
    required this.white,
  });

  /// Every color in this group, in declaration order.
  List<Color> get all => [strong, sub, soft, white];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteStrokeColors] are equal when all their colors are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteStrokeColors) return false;

    return other.strong == strong &&
        other.sub == sub &&
        other.soft == soft &&
        other.white == white;
  }

  /// A hash of the same colors that [operator ==] compares.
  @override
  int get hashCode => Object.hash(strong, sub, soft, white);
}

/// Colors representing semantic UI states and structural feedback.
///
/// Includes various shades (dark to lighter) to support different component
/// architectures, such as subtle backgrounds for alerts or strong fills for badges.
class GtPaletteStateColors {
  /// A deep shade of the state color, used for text and icons.
  final Color darker;

  /// A dark shade of the state color.
  final Color dark;

  /// The main state color, used for strong fills, text and icons.
  final Color base;

  /// A light shade of the state color, used for borders and soft fills.
  final Color light;

  /// The lightest shade of the state color, used for subtle backgrounds.
  final Color lighter;

  /// Creates a [GtPaletteStateColors].
  const GtPaletteStateColors({
    required this.darker,
    required this.dark,
    required this.base,
    required this.light,
    required this.lighter,
  });

  /// Every color in this group, in declaration order.
  List<Color> get all => [darker, dark, base, light, lighter];

  /// Linearly interpolates between [a] and [b] by [t].
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

  /// Two [GtPaletteStateColors] are equal when all their colors are equal.
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

  /// A hash of the same colors that [operator ==] compares.
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
  /// Whether tokens resolve to their dark mode variants.
  final bool isDark;

  /// Creates a [GtPaletteRawColors] that resolves for dark mode when [isDark]
  /// is true.
  const GtPaletteRawColors({this.isDark = false});

  /// Creates a [GtPaletteRawColors] that resolves tokens for light mode.
  const GtPaletteRawColors.light() : isDark = false;

  /// Creates a [GtPaletteRawColors] that resolves tokens for dark mode.
  const GtPaletteRawColors.dark() : isDark = true;

  /// Returns the dark or light variant of [color], depending on [isDark].
  Color _resolve(GtColors color) => isDark ? color.dark : color.value;

  /// Resolves the given [GtColors] enum token according to the active theme mode.
  Color call(GtColors color) => _resolve(color);

  /// Resolves the given [GtColors] enum token according to the active theme mode.
  Color operator [](GtColors color) => _resolve(color);

  // ---------------------------------------------------------------------------
  // PRIMITIVE COLORSETS
  // ---------------------------------------------------------------------------
  /// The ash color, resolved for this palette's mode.
  Color get ash => _resolve(GtColors.ash);

  /// The night color, resolved for this palette's mode.
  Color get night => _resolve(GtColors.night);

  /// The white color, resolved for this palette's mode.
  Color get white => _resolve(GtColors.white);

  /// The cream color, resolved for this palette's mode.
  Color get cream => _resolve(GtColors.cream);

  /// The black color, resolved for this palette's mode.
  Color get black => _resolve(GtColors.black);

  /// The tertiary text color, resolved for this palette's mode.
  Color get tertiaryText => _resolve(GtColors.tertiaryText);

  /// The transparent color, resolved for this palette's mode.
  Color get transparent => _resolve(GtColors.transparent);

  // ---------------------------------------------------------------------------
  // NEUTRAL / TEXT
  // ---------------------------------------------------------------------------
  /// The neutral 950 tone, resolved for this palette's mode.
  Color get neutral950 => _resolve(GtColors.neutral950);

  /// The neutral 800 tone, resolved for this palette's mode.
  Color get neutral800 => _resolve(GtColors.neutral800);

  /// The neutral 700 tone, resolved for this palette's mode.
  Color get neutral700 => _resolve(GtColors.neutral700);

  /// The neutral 600 tone, resolved for this palette's mode.
  Color get neutral600 => _resolve(GtColors.neutral600);

  /// The neutral 500 tone, resolved for this palette's mode.
  Color get neutral500 => _resolve(GtColors.neutral500);

  /// The neutral 400 tone, resolved for this palette's mode.
  Color get neutral400 => _resolve(GtColors.neutral400);

  /// The neutral 300 tone, resolved for this palette's mode.
  Color get neutral300 => _resolve(GtColors.neutral300);

  /// The neutral 200 tone, resolved for this palette's mode.
  Color get neutral200 => _resolve(GtColors.neutral200);

  /// The neutral 100 tone, resolved for this palette's mode.
  Color get neutral100 => _resolve(GtColors.neutral100);

  /// The neutral 50 tone, resolved for this palette's mode.
  Color get neutral50 => _resolve(GtColors.neutral50);

  /// The neutral 25 tone, resolved for this palette's mode.
  Color get neutral25 => _resolve(GtColors.neutral25);

  /// The neutral 12 tone, resolved for this palette's mode.
  Color get neutral12 => _resolve(GtColors.neutral12);

  /// The neutral 0 tone, resolved for this palette's mode.
  Color get neutral0 => _resolve(GtColors.neutral0);

  // ---------------------------------------------------------------------------
  // NEUTRAL / GRAY
  // ---------------------------------------------------------------------------
  /// The neutral gray 950 tone, resolved for this palette's mode.
  Color get neutralGray950 => _resolve(GtColors.neutralGray950);

  /// The neutral gray 900 tone, resolved for this palette's mode.
  Color get neutralGray900 => _resolve(GtColors.neutralGray900);

  /// The neutral gray 800 tone, resolved for this palette's mode.
  Color get neutralGray800 => _resolve(GtColors.neutralGray800);

  /// The neutral gray 700 tone, resolved for this palette's mode.
  Color get neutralGray700 => _resolve(GtColors.neutralGray700);

  /// The neutral gray 600 tone, resolved for this palette's mode.
  Color get neutralGray600 => _resolve(GtColors.neutralGray600);

  /// The neutral gray 500 tone, resolved for this palette's mode.
  Color get neutralGray500 => _resolve(GtColors.neutralGray500);

  /// The neutral gray 400 tone, resolved for this palette's mode.
  Color get neutralGray400 => _resolve(GtColors.neutralGray400);

  /// The neutral gray 300 tone, resolved for this palette's mode.
  Color get neutralGray300 => _resolve(GtColors.neutralGray300);

  /// The neutral gray 200 tone, resolved for this palette's mode.
  Color get neutralGray200 => _resolve(GtColors.neutralGray200);

  /// The neutral gray 100 tone, resolved for this palette's mode.
  Color get neutralGray100 => _resolve(GtColors.neutralGray100);

  /// The neutral gray 50 tone, resolved for this palette's mode.
  Color get neutralGray50 => _resolve(GtColors.neutralGray50);

  /// The neutral warm 50 tone, resolved for this palette's mode.
  Color get neutralWarm50 => _resolve(GtColors.neutralWarm50);

  /// The neutral gray 0 tone, resolved for this palette's mode.
  Color get neutralGray0 => _resolve(GtColors.neutralGray0);

  // ---------------------------------------------------------------------------
  // VIBRANTS - BLUE
  // ---------------------------------------------------------------------------
  /// The blue 950 tone, resolved for this palette's mode.
  Color get blue950 => _resolve(GtColors.blue950);

  /// The blue 900 tone, resolved for this palette's mode.
  Color get blue900 => _resolve(GtColors.blue900);

  /// The blue 800 tone, resolved for this palette's mode.
  Color get blue800 => _resolve(GtColors.blue800);

  /// The blue 700 tone, resolved for this palette's mode.
  Color get blue700 => _resolve(GtColors.blue700);

  /// The blue 600 tone, resolved for this palette's mode.
  Color get blue600 => _resolve(GtColors.blue600);

  /// The blue 500 tone, resolved for this palette's mode.
  Color get blue500 => _resolve(GtColors.blue500);

  /// The blue 400 tone, resolved for this palette's mode.
  Color get blue400 => _resolve(GtColors.blue400);

  /// The blue 300 tone, resolved for this palette's mode.
  Color get blue300 => _resolve(GtColors.blue300);

  /// The blue 200 tone, resolved for this palette's mode.
  Color get blue200 => _resolve(GtColors.blue200);

  /// The blue 100 tone, resolved for this palette's mode.
  Color get blue100 => _resolve(GtColors.blue100);

  /// The blue 50 tone, resolved for this palette's mode.
  Color get blue50 => _resolve(GtColors.blue50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - ORANGE
  // ---------------------------------------------------------------------------
  /// The orange 950 tone, resolved for this palette's mode.
  Color get orange950 => _resolve(GtColors.orange950);

  /// The orange 900 tone, resolved for this palette's mode.
  Color get orange900 => _resolve(GtColors.orange900);

  /// The orange 800 tone, resolved for this palette's mode.
  Color get orange800 => _resolve(GtColors.orange800);

  /// The orange 700 tone, resolved for this palette's mode.
  Color get orange700 => _resolve(GtColors.orange700);

  /// The orange 600 tone, resolved for this palette's mode.
  Color get orange600 => _resolve(GtColors.orange600);

  /// The orange 500 tone, resolved for this palette's mode.
  Color get orange500 => _resolve(GtColors.orange500);

  /// The orange 400 tone, resolved for this palette's mode.
  Color get orange400 => _resolve(GtColors.orange400);

  /// The orange 300 tone, resolved for this palette's mode.
  Color get orange300 => _resolve(GtColors.orange300);

  /// The orange 200 tone, resolved for this palette's mode.
  Color get orange200 => _resolve(GtColors.orange200);

  /// The orange 100 tone, resolved for this palette's mode.
  Color get orange100 => _resolve(GtColors.orange100);

  /// The orange 50 tone, resolved for this palette's mode.
  Color get orange50 => _resolve(GtColors.orange50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - RED
  // ---------------------------------------------------------------------------
  /// The red 950 tone, resolved for this palette's mode.
  Color get red950 => _resolve(GtColors.red950);

  /// The red 900 tone, resolved for this palette's mode.
  Color get red900 => _resolve(GtColors.red900);

  /// The red 800 tone, resolved for this palette's mode.
  Color get red800 => _resolve(GtColors.red800);

  /// The red 700 tone, resolved for this palette's mode.
  Color get red700 => _resolve(GtColors.red700);

  /// The red 600 tone, resolved for this palette's mode.
  Color get red600 => _resolve(GtColors.red600);

  /// The red 500 tone, resolved for this palette's mode.
  Color get red500 => _resolve(GtColors.red500);

  /// The red 400 tone, resolved for this palette's mode.
  Color get red400 => _resolve(GtColors.red400);

  /// The red 300 tone, resolved for this palette's mode.
  Color get red300 => _resolve(GtColors.red300);

  /// The red 200 tone, resolved for this palette's mode.
  Color get red200 => _resolve(GtColors.red200);

  /// The red 100 tone, resolved for this palette's mode.
  Color get red100 => _resolve(GtColors.red100);

  /// The red 50 tone, resolved for this palette's mode.
  Color get red50 => _resolve(GtColors.red50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - GREEN
  // ---------------------------------------------------------------------------
  /// The green 950 tone, resolved for this palette's mode.
  Color get green950 => _resolve(GtColors.green950);

  /// The green 925 tone, resolved for this palette's mode.
  Color get green925 => _resolve(GtColors.green925);

  /// The green 900 tone, resolved for this palette's mode.
  Color get green900 => _resolve(GtColors.green900);

  /// The green 800 tone, resolved for this palette's mode.
  Color get green800 => _resolve(GtColors.green800);

  /// The green 750 tone, resolved for this palette's mode.
  Color get green750 => _resolve(GtColors.green750);

  /// The green 700 tone, resolved for this palette's mode.
  Color get green700 => _resolve(GtColors.green700);

  /// The green 600 tone, resolved for this palette's mode.
  Color get green600 => _resolve(GtColors.green600);

  /// The green 500 tone, resolved for this palette's mode.
  Color get green500 => _resolve(GtColors.green500);

  /// The green 400 tone, resolved for this palette's mode.
  Color get green400 => _resolve(GtColors.green400);

  /// The green 300 tone, resolved for this palette's mode.
  Color get green300 => _resolve(GtColors.green300);

  /// The green 200 tone, resolved for this palette's mode.
  Color get green200 => _resolve(GtColors.green200);

  /// The green 100 tone, resolved for this palette's mode.
  Color get green100 => _resolve(GtColors.green100);

  /// The green 50 tone, resolved for this palette's mode.
  Color get green50 => _resolve(GtColors.green50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - YELLOW
  // ---------------------------------------------------------------------------
  /// The yellow 950 tone, resolved for this palette's mode.
  Color get yellow950 => _resolve(GtColors.yellow950);

  /// The yellow 900 tone, resolved for this palette's mode.
  Color get yellow900 => _resolve(GtColors.yellow900);

  /// The yellow 800 tone, resolved for this palette's mode.
  Color get yellow800 => _resolve(GtColors.yellow800);

  /// The yellow 700 tone, resolved for this palette's mode.
  Color get yellow700 => _resolve(GtColors.yellow700);

  /// The yellow 600 tone, resolved for this palette's mode.
  Color get yellow600 => _resolve(GtColors.yellow600);

  /// The yellow 500 tone, resolved for this palette's mode.
  Color get yellow500 => _resolve(GtColors.yellow500);

  /// The yellow 400 tone, resolved for this palette's mode.
  Color get yellow400 => _resolve(GtColors.yellow400);

  /// The yellow 300 tone, resolved for this palette's mode.
  Color get yellow300 => _resolve(GtColors.yellow300);

  /// The yellow 200 tone, resolved for this palette's mode.
  Color get yellow200 => _resolve(GtColors.yellow200);

  /// The yellow 100 tone, resolved for this palette's mode.
  Color get yellow100 => _resolve(GtColors.yellow100);

  /// The yellow 50 tone, resolved for this palette's mode.
  Color get yellow50 => _resolve(GtColors.yellow50);

  /// The yellow 25 tone, resolved for this palette's mode.
  Color get yellow25 => _resolve(GtColors.yellow25);

  // ---------------------------------------------------------------------------
  // VIBRANTS - PURPLE
  // ---------------------------------------------------------------------------
  /// The purple 950 tone, resolved for this palette's mode.
  Color get purple950 => _resolve(GtColors.purple950);

  /// The purple 900 tone, resolved for this palette's mode.
  Color get purple900 => _resolve(GtColors.purple900);

  /// The purple 800 tone, resolved for this palette's mode.
  Color get purple800 => _resolve(GtColors.purple800);

  /// The purple 700 tone, resolved for this palette's mode.
  Color get purple700 => _resolve(GtColors.purple700);

  /// The purple 600 tone, resolved for this palette's mode.
  Color get purple600 => _resolve(GtColors.purple600);

  /// The purple 500 tone, resolved for this palette's mode.
  Color get purple500 => _resolve(GtColors.purple500);

  /// The purple 400 tone, resolved for this palette's mode.
  Color get purple400 => _resolve(GtColors.purple400);

  /// The purple 300 tone, resolved for this palette's mode.
  Color get purple300 => _resolve(GtColors.purple300);

  /// The purple 200 tone, resolved for this palette's mode.
  Color get purple200 => _resolve(GtColors.purple200);

  /// The purple 100 tone, resolved for this palette's mode.
  Color get purple100 => _resolve(GtColors.purple100);

  /// The purple 50 tone, resolved for this palette's mode.
  Color get purple50 => _resolve(GtColors.purple50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - PINK
  // ---------------------------------------------------------------------------
  /// The pink 950 tone, resolved for this palette's mode.
  Color get pink950 => _resolve(GtColors.pink950);

  /// The pink 900 tone, resolved for this palette's mode.
  Color get pink900 => _resolve(GtColors.pink900);

  /// The pink 800 tone, resolved for this palette's mode.
  Color get pink800 => _resolve(GtColors.pink800);

  /// The pink 700 tone, resolved for this palette's mode.
  Color get pink700 => _resolve(GtColors.pink700);

  /// The pink 600 tone, resolved for this palette's mode.
  Color get pink600 => _resolve(GtColors.pink600);

  /// The pink 500 tone, resolved for this palette's mode.
  Color get pink500 => _resolve(GtColors.pink500);

  /// The pink 400 tone, resolved for this palette's mode.
  Color get pink400 => _resolve(GtColors.pink400);

  /// The pink 300 tone, resolved for this palette's mode.
  Color get pink300 => _resolve(GtColors.pink300);

  /// The pink 200 tone, resolved for this palette's mode.
  Color get pink200 => _resolve(GtColors.pink200);

  /// The pink 100 tone, resolved for this palette's mode.
  Color get pink100 => _resolve(GtColors.pink100);

  /// The pink 50 tone, resolved for this palette's mode.
  Color get pink50 => _resolve(GtColors.pink50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL
  // ---------------------------------------------------------------------------
  /// The teal 950 tone, resolved for this palette's mode.
  Color get teal950 => _resolve(GtColors.teal950);

  /// The teal 900 tone, resolved for this palette's mode.
  Color get teal900 => _resolve(GtColors.teal900);

  /// The teal 850 tone, resolved for this palette's mode.
  Color get teal850 => _resolve(GtColors.teal850);

  /// The teal 800 tone, resolved for this palette's mode.
  Color get teal800 => _resolve(GtColors.teal800);

  /// The teal 750 tone, resolved for this palette's mode.
  Color get teal750 => _resolve(GtColors.teal750);

  /// The teal 700 tone, resolved for this palette's mode.
  Color get teal700 => _resolve(GtColors.teal700);

  /// The teal 600 tone, resolved for this palette's mode.
  Color get teal600 => _resolve(GtColors.teal600);

  /// The teal 500 tone, resolved for this palette's mode.
  Color get teal500 => _resolve(GtColors.teal500);

  /// The teal 400 tone, resolved for this palette's mode.
  Color get teal400 => _resolve(GtColors.teal400);

  /// The teal 300 tone, resolved for this palette's mode.
  Color get teal300 => _resolve(GtColors.teal300);

  /// The teal 200 tone, resolved for this palette's mode.
  Color get teal200 => _resolve(GtColors.teal200);

  /// The teal 100 tone, resolved for this palette's mode.
  Color get teal100 => _resolve(GtColors.teal100);

  /// The teal 50 tone, resolved for this palette's mode.
  Color get teal50 => _resolve(GtColors.teal50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL BLUE
  // ---------------------------------------------------------------------------
  /// The teal blue 800 tone, resolved for this palette's mode.
  Color get tealBlue800 => _resolve(GtColors.tealBlue800);

  /// The teal blue 750 tone, resolved for this palette's mode.
  Color get tealBlue750 => _resolve(GtColors.tealBlue750);

  /// The teal blue 725 tone, resolved for this palette's mode.
  Color get tealBlue725 => _resolve(GtColors.tealBlue725);

  /// The teal blue 700 tone, resolved for this palette's mode.
  Color get tealBlue700 => _resolve(GtColors.tealBlue700);

  /// The teal blue 600 tone, resolved for this palette's mode.
  Color get tealBlue600 => _resolve(GtColors.tealBlue600);

  // ---------------------------------------------------------------------------
  // VIBRANTS - SKY
  // ---------------------------------------------------------------------------
  /// The sky 950 tone, resolved for this palette's mode.
  Color get sky950 => _resolve(GtColors.sky950);

  /// The sky 900 tone, resolved for this palette's mode.
  Color get sky900 => _resolve(GtColors.sky900);

  /// The sky 800 tone, resolved for this palette's mode.
  Color get sky800 => _resolve(GtColors.sky800);

  /// The sky 700 tone, resolved for this palette's mode.
  Color get sky700 => _resolve(GtColors.sky700);

  /// The sky 600 tone, resolved for this palette's mode.
  Color get sky600 => _resolve(GtColors.sky600);

  /// The sky 500 tone, resolved for this palette's mode.
  Color get sky500 => _resolve(GtColors.sky500);

  /// The sky 400 tone, resolved for this palette's mode.
  Color get sky400 => _resolve(GtColors.sky400);

  /// The sky 300 tone, resolved for this palette's mode.
  Color get sky300 => _resolve(GtColors.sky300);

  /// The sky 200 tone, resolved for this palette's mode.
  Color get sky200 => _resolve(GtColors.sky200);

  /// The sky 100 tone, resolved for this palette's mode.
  Color get sky100 => _resolve(GtColors.sky100);

  /// The sky 50 tone, resolved for this palette's mode.
  Color get sky50 => _resolve(GtColors.sky50);

  // ---------------------------------------------------------------------------
  // VIBRANTS - MAROON
  // ---------------------------------------------------------------------------
  /// The maroon 800 tone, resolved for this palette's mode.
  Color get maroon800 => _resolve(GtColors.maroon800);

  /// The maroon 700 tone, resolved for this palette's mode.
  Color get maroon700 => _resolve(GtColors.maroon700);

  /// The maroon 600 tone, resolved for this palette's mode.
  Color get maroon600 => _resolve(GtColors.maroon600);

  // ---------------------------------------------------------------------------
  // ALPHA COLORSETS
  // ---------------------------------------------------------------------------
  /// The blue alpha 24 tone, resolved for this palette's mode.
  Color get blueAlpha24 => _resolve(GtColors.blueAlpha24);

  /// The blue alpha 16 tone, resolved for this palette's mode.
  Color get blueAlpha16 => _resolve(GtColors.blueAlpha16);

  /// The blue alpha 15 tone, resolved for this palette's mode.
  Color get blueAlpha15 => _resolve(GtColors.blueAlpha15);

  /// The blue alpha 10 tone, resolved for this palette's mode.
  Color get blueAlpha10 => _resolve(GtColors.blueAlpha10);

  /// The blue alpha 8 tone, resolved for this palette's mode.
  Color get blueAlpha8 => _resolve(GtColors.blueAlpha8);

  /// The blue alpha 3 tone, resolved for this palette's mode.
  Color get blueAlpha3 => _resolve(GtColors.blueAlpha3);

  /// The navy alpha 24 tone, resolved for this palette's mode.
  Color get navyAlpha24 => _resolve(GtColors.navyAlpha24);

  /// The navy alpha 16 tone, resolved for this palette's mode.
  Color get navyAlpha16 => _resolve(GtColors.navyAlpha16);

  /// The navy alpha 15 tone, resolved for this palette's mode.
  Color get navyAlpha15 => _resolve(GtColors.navyAlpha15);

  /// The navy alpha 10 tone, resolved for this palette's mode.
  Color get navyAlpha10 => _resolve(GtColors.navyAlpha10);

  /// The navy alpha 8 tone, resolved for this palette's mode.
  Color get navyAlpha8 => _resolve(GtColors.navyAlpha8);

  /// The navy alpha 3 tone, resolved for this palette's mode.
  Color get navyAlpha3 => _resolve(GtColors.navyAlpha3);

  /// The orange alpha 24 tone, resolved for this palette's mode.
  Color get orangeAlpha24 => _resolve(GtColors.orangeAlpha24);

  /// The orange alpha 16 tone, resolved for this palette's mode.
  Color get orangeAlpha16 => _resolve(GtColors.orangeAlpha16);

  /// The orange alpha 15 tone, resolved for this palette's mode.
  Color get orangeAlpha15 => _resolve(GtColors.orangeAlpha15);

  /// The orange alpha 10 tone, resolved for this palette's mode.
  Color get orangeAlpha10 => _resolve(GtColors.orangeAlpha10);

  /// The orange alpha 8 tone, resolved for this palette's mode.
  Color get orangeAlpha8 => _resolve(GtColors.orangeAlpha8);

  /// The orange alpha 3 tone, resolved for this palette's mode.
  Color get orangeAlpha3 => _resolve(GtColors.orangeAlpha3);

  /// The red alpha 24 tone, resolved for this palette's mode.
  Color get redAlpha24 => _resolve(GtColors.redAlpha24);

  /// The red alpha 16 tone, resolved for this palette's mode.
  Color get redAlpha16 => _resolve(GtColors.redAlpha16);

  /// The red alpha 15 tone, resolved for this palette's mode.
  Color get redAlpha15 => _resolve(GtColors.redAlpha15);

  /// The red alpha 10 tone, resolved for this palette's mode.
  Color get redAlpha10 => _resolve(GtColors.redAlpha10);

  /// The red alpha 8 tone, resolved for this palette's mode.
  Color get redAlpha8 => _resolve(GtColors.redAlpha8);

  /// The red alpha 3 tone, resolved for this palette's mode.
  Color get redAlpha3 => _resolve(GtColors.redAlpha3);

  /// The green alpha 24 tone, resolved for this palette's mode.
  Color get greenAlpha24 => _resolve(GtColors.greenAlpha24);

  /// The green alpha 16 tone, resolved for this palette's mode.
  Color get greenAlpha16 => _resolve(GtColors.greenAlpha16);

  /// The green alpha 15 tone, resolved for this palette's mode.
  Color get greenAlpha15 => _resolve(GtColors.greenAlpha15);

  /// The green alpha 10 tone, resolved for this palette's mode.
  Color get greenAlpha10 => _resolve(GtColors.greenAlpha10);

  /// The green alpha 8 tone, resolved for this palette's mode.
  Color get greenAlpha8 => _resolve(GtColors.greenAlpha8);

  /// The green alpha 3 tone, resolved for this palette's mode.
  Color get greenAlpha3 => _resolve(GtColors.greenAlpha3);

  /// The yellow alpha 24 tone, resolved for this palette's mode.
  Color get yellowAlpha24 => _resolve(GtColors.yellowAlpha24);

  /// The yellow alpha 16 tone, resolved for this palette's mode.
  Color get yellowAlpha16 => _resolve(GtColors.yellowAlpha16);

  /// The yellow alpha 15 tone, resolved for this palette's mode.
  Color get yellowAlpha15 => _resolve(GtColors.yellowAlpha15);

  /// The yellow alpha 10 tone, resolved for this palette's mode.
  Color get yellowAlpha10 => _resolve(GtColors.yellowAlpha10);

  /// The yellow alpha 8 tone, resolved for this palette's mode.
  Color get yellowAlpha8 => _resolve(GtColors.yellowAlpha8);

  /// The yellow alpha 3 tone, resolved for this palette's mode.
  Color get yellowAlpha3 => _resolve(GtColors.yellowAlpha3);

  /// The sky alpha 24 tone, resolved for this palette's mode.
  Color get skyAlpha24 => _resolve(GtColors.skyAlpha24);

  /// The sky alpha 16 tone, resolved for this palette's mode.
  Color get skyAlpha16 => _resolve(GtColors.skyAlpha16);

  /// The sky alpha 15 tone, resolved for this palette's mode.
  Color get skyAlpha15 => _resolve(GtColors.skyAlpha15);

  /// The sky alpha 10 tone, resolved for this palette's mode.
  Color get skyAlpha10 => _resolve(GtColors.skyAlpha10);

  /// The sky alpha 8 tone, resolved for this palette's mode.
  Color get skyAlpha8 => _resolve(GtColors.skyAlpha8);

  /// The sky alpha 3 tone, resolved for this palette's mode.
  Color get skyAlpha3 => _resolve(GtColors.skyAlpha3);

  /// The purple alpha 24 tone, resolved for this palette's mode.
  Color get purpleAlpha24 => _resolve(GtColors.purpleAlpha24);

  /// The purple alpha 16 tone, resolved for this palette's mode.
  Color get purpleAlpha16 => _resolve(GtColors.purpleAlpha16);

  /// The purple alpha 15 tone, resolved for this palette's mode.
  Color get purpleAlpha15 => _resolve(GtColors.purpleAlpha15);

  /// The purple alpha 10 tone, resolved for this palette's mode.
  Color get purpleAlpha10 => _resolve(GtColors.purpleAlpha10);

  /// The purple alpha 8 tone, resolved for this palette's mode.
  Color get purpleAlpha8 => _resolve(GtColors.purpleAlpha8);

  /// The purple alpha 3 tone, resolved for this palette's mode.
  Color get purpleAlpha3 => _resolve(GtColors.purpleAlpha3);

  /// The pink alpha 24 tone, resolved for this palette's mode.
  Color get pinkAlpha24 => _resolve(GtColors.pinkAlpha24);

  /// The pink alpha 16 tone, resolved for this palette's mode.
  Color get pinkAlpha16 => _resolve(GtColors.pinkAlpha16);

  /// The pink alpha 15 tone, resolved for this palette's mode.
  Color get pinkAlpha15 => _resolve(GtColors.pinkAlpha15);

  /// The pink alpha 10 tone, resolved for this palette's mode.
  Color get pinkAlpha10 => _resolve(GtColors.pinkAlpha10);

  /// The pink alpha 8 tone, resolved for this palette's mode.
  Color get pinkAlpha8 => _resolve(GtColors.pinkAlpha8);

  /// The pink alpha 3 tone, resolved for this palette's mode.
  Color get pinkAlpha3 => _resolve(GtColors.pinkAlpha3);

  /// The teal alpha 24 tone, resolved for this palette's mode.
  Color get tealAlpha24 => _resolve(GtColors.tealAlpha24);

  /// The teal alpha 16 tone, resolved for this palette's mode.
  Color get tealAlpha16 => _resolve(GtColors.tealAlpha16);

  /// The teal alpha 15 tone, resolved for this palette's mode.
  Color get tealAlpha15 => _resolve(GtColors.tealAlpha15);

  /// The teal alpha 10 tone, resolved for this palette's mode.
  Color get tealAlpha10 => _resolve(GtColors.tealAlpha10);

  /// The teal alpha 8 tone, resolved for this palette's mode.
  Color get tealAlpha8 => _resolve(GtColors.tealAlpha8);

  /// The teal alpha 3 tone, resolved for this palette's mode.
  Color get tealAlpha3 => _resolve(GtColors.tealAlpha3);

  /// The teal blue alpha 24 tone, resolved for this palette's mode.
  Color get tealBlueAlpha24 => _resolve(GtColors.tealBlueAlpha24);

  /// The teal blue alpha 16 tone, resolved for this palette's mode.
  Color get tealBlueAlpha16 => _resolve(GtColors.tealBlueAlpha16);

  /// The teal blue alpha 15 tone, resolved for this palette's mode.
  Color get tealBlueAlpha15 => _resolve(GtColors.tealBlueAlpha15);

  /// The teal blue alpha 10 tone, resolved for this palette's mode.
  Color get tealBlueAlpha10 => _resolve(GtColors.tealBlueAlpha10);

  /// The teal blue alpha 8 tone, resolved for this palette's mode.
  Color get tealBlueAlpha8 => _resolve(GtColors.tealBlueAlpha8);

  /// The teal blue alpha 3 tone, resolved for this palette's mode.
  Color get tealBlueAlpha3 => _resolve(GtColors.tealBlueAlpha3);

  /// The white alpha 24 tone, resolved for this palette's mode.
  Color get whiteAlpha24 => _resolve(GtColors.whiteAlpha24);

  /// The white alpha 16 tone, resolved for this palette's mode.
  Color get whiteAlpha16 => _resolve(GtColors.whiteAlpha16);

  /// The white alpha 15 tone, resolved for this palette's mode.
  Color get whiteAlpha15 => _resolve(GtColors.whiteAlpha15);

  /// The white alpha 10 tone, resolved for this palette's mode.
  Color get whiteAlpha10 => _resolve(GtColors.whiteAlpha10);

  /// The white alpha 8 tone, resolved for this palette's mode.
  Color get whiteAlpha8 => _resolve(GtColors.whiteAlpha8);

  /// The white alpha 3 tone, resolved for this palette's mode.
  Color get whiteAlpha3 => _resolve(GtColors.whiteAlpha3);

  /// The neutral alpha 24 tone, resolved for this palette's mode.
  Color get neutralAlpha24 => _resolve(GtColors.neutralAlpha24);

  /// The neutral alpha 16 tone, resolved for this palette's mode.
  Color get neutralAlpha16 => _resolve(GtColors.neutralAlpha16);

  /// The neutral alpha 15 tone, resolved for this palette's mode.
  Color get neutralAlpha15 => _resolve(GtColors.neutralAlpha15);

  /// The neutral alpha 10 tone, resolved for this palette's mode.
  Color get neutralAlpha10 => _resolve(GtColors.neutralAlpha10);

  /// The neutral alpha 8 tone, resolved for this palette's mode.
  Color get neutralAlpha8 => _resolve(GtColors.neutralAlpha8);

  /// The neutral alpha 3 tone, resolved for this palette's mode.
  Color get neutralAlpha3 => _resolve(GtColors.neutralAlpha3);

  /// The black alpha 24 tone, resolved for this palette's mode.
  Color get blackAlpha24 => _resolve(GtColors.blackAlpha24);

  /// The black alpha 16 tone, resolved for this palette's mode.
  Color get blackAlpha16 => _resolve(GtColors.blackAlpha16);

  /// The black alpha 15 tone, resolved for this palette's mode.
  Color get blackAlpha15 => _resolve(GtColors.blackAlpha15);

  /// The black alpha 10 tone, resolved for this palette's mode.
  Color get blackAlpha10 => _resolve(GtColors.blackAlpha10);

  /// The black alpha 8 tone, resolved for this palette's mode.
  Color get blackAlpha8 => _resolve(GtColors.blackAlpha8);

  /// The black alpha 3 tone, resolved for this palette's mode.
  Color get blackAlpha3 => _resolve(GtColors.blackAlpha3);

  /// The maroon alpha 24 tone, resolved for this palette's mode.
  Color get maroonAlpha24 => _resolve(GtColors.maroonAlpha24);

  /// The maroon alpha 16 tone, resolved for this palette's mode.
  Color get maroonAlpha16 => _resolve(GtColors.maroonAlpha16);

  /// The maroon alpha 15 tone, resolved for this palette's mode.
  Color get maroonAlpha15 => _resolve(GtColors.maroonAlpha15);

  /// The maroon alpha 10 tone, resolved for this palette's mode.
  Color get maroonAlpha10 => _resolve(GtColors.maroonAlpha10);

  /// The maroon alpha 8 tone, resolved for this palette's mode.
  Color get maroonAlpha8 => _resolve(GtColors.maroonAlpha8);

  /// The maroon alpha 3 tone, resolved for this palette's mode.
  Color get maroonAlpha3 => _resolve(GtColors.maroonAlpha3);

  /// The sky alpha 5 tone, resolved for this palette's mode.
  Color get skyAlpha5 => _resolve(GtColors.skyAlpha5);

  /// The dark green color, resolved for this palette's mode.
  Color get darkGreen => _resolve(GtColors.darkGreen);

  /// The lemon color, resolved for this palette's mode.
  Color get lemon => _resolve(GtColors.lemon);

  /// The blue color, resolved for this palette's mode.
  Color get blue => _resolve(GtColors.blue);

  /// The navy color, resolved for this palette's mode.
  Color get navy => _resolve(GtColors.navy);

  /// Every [GtColors] token resolved for this palette's mode, in enum order.
  List<Color> get all => GtColors.values.map(_resolve).toList();

  /// Returns [a] when [t] is below 0.5 and [b] otherwise.
  ///
  /// A missing [a] falls back to the light set and a missing [b] to the dark
  /// set.
  static GtPaletteRawColors lerp(
    GtPaletteRawColors? a,
    GtPaletteRawColors? b,
    double t,
  ) {
    if (t < 0.5) return a ?? const GtPaletteRawColors.light();
    return b ?? const GtPaletteRawColors.dark();
  }

  /// Two [GtPaletteRawColors] are equal when they resolve for the same mode.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtPaletteRawColors) return false;
    return other.isDark == isDark;
  }

  /// A hash of [isDark].
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
  /// The brand colors.
  final GtPaletteBrandColors primary;

  // Cover
  /// The colors for large cover areas and marketing screens.
  final GtPaletteCoverColors coverColors;

  // Static
  /// The colors that stay the same in every theme mode.
  final GtPaletteStaticColors staticColors;

  /// The colors for payment card tiers.
  final GtPaletteCardColors cardColors;

  // Neutral
  /// The background colors for screens and surfaces.
  final GtPaletteBgColors bg;

  /// The fill colors for components such as inputs, chips and buttons.
  final GtPaletteBgColors fill;

  /// The text colors.
  final GtPaletteTextColors text;

  /// The colors for borders, dividers and outlines.
  final GtPaletteStrokeColors stroke;

  /// The icon colors.
  final GtPaletteContentColors icon;

  // States
  /// The colors for faded or neutral states.
  final GtPaletteStateColors faded;

  /// The colors for information states.
  final GtPaletteStateColors information;

  /// The colors for warning states.
  final GtPaletteStateColors warning;

  /// The colors for error states.
  final GtPaletteStateColors error;

  /// The colors for success states.
  final GtPaletteStateColors success;

  /// The colors for away states.
  final GtPaletteStateColors away;

  /// The colors for feature states.
  final GtPaletteStateColors feature;

  /// The colors for verified states.
  final GtPaletteStateColors verified;

  /// The colors for highlighted states.
  final GtPaletteStateColors highlighted;

  /// The colors for stable states.
  final GtPaletteStateColors stable;

  /// The colors for an alternative information state.
  final GtPaletteStateColors infoAlt;

  // Illustrations

  /// Whether illustrations are drawn in their red variants under this palette.
  ///
  /// Red-styled brands, such as Sterling Pro, set this so that
  /// [GtIllustrationExtension.adapt] swaps each illustration for its red
  /// version. Defaults to false.
  final bool usesRedIllustration;

  /// Creates a [GtPalette] from a full set of color groups.
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
    this.usesRedIllustration = false,
  });

  /// Direct access to the raw [GtColors] design tokens resolved for this palette's mode.
  GtPaletteRawColors get raw => const GtPaletteRawColors.light();

  /// Every color in this palette's groups except [fill], followed by the [raw]
  /// tokens.
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

  /// Linearly interpolates between this palette and [other] by [t].
  ///
  /// Returns this palette unchanged when [other] is not a [GtPalette].
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
      usesRedIllustration: t < .5
          ? usesRedIllustration
          : other.usesRedIllustration,
    );
  }

  /// Returns this palette unchanged.
  @override
  ThemeExtension<GtPalette> copyWith() {
    return this;
  }

  /// Two [GtPalette]s are equal when all their color groups and
  /// [usesRedIllustration] are equal.
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
        other.stable == stable &&
        other.usesRedIllustration == usesRedIllustration;
  }

  /// Light mode primary ink color
  Color get opPrimaryInk => primary.darker;

  /// A hash of the same values that [operator ==] compares, except
  /// [cardColors].
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
    usesRedIllustration,
  );
}

// -----------------------------------------------------------------------------
// BASE LIGHT & DARK PALETTES
// -----------------------------------------------------------------------------

/// Base class for Light mode palettes providing standard default color definitions.
base class GtLightPalette extends GtPalette {
  /// Creates a [GtLightPalette] from [primary] and [coverColors].
  ///
  /// Every other group not given falls back to the standard light mode colors.
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
    super.usesRedIllustration,
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
  /// The standard dark mode backgrounds, used for [bg] when none is given.
  ///
  /// A palette that changes only a few of them can start from these with
  /// [GtPaletteBgColors.copyWith].
  static final defaultBg = GtPaletteBgColors(
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
  );

  /// Creates a [GtDarkPalette] from [primary] and [coverColors].
  ///
  /// Every other group not given falls back to the standard dark mode colors.
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
    super.usesRedIllustration,
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
         bg: bg ?? defaultBg,
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

  /// The raw [GtColors] tokens resolved for dark mode.
  @override
  GtPaletteRawColors get raw => const GtPaletteRawColors.dark();

  /// Dark mode primary ink color
  @override
  Color get opPrimaryInk => primary.base;
}
