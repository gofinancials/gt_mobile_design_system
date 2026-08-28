import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  group('GtPaletteBrandColors', () {
    const brand = GtPaletteBrandColors(
      dark: Color(0xFF111111),
      darker: Color(0xFF000000),
      base: Color(0xFF222222),
      alpha24: Color(0x3D222222),
      alpha16: Color(0x29222222),
      alpha10: Color(0x1A222222),
    );

    test('exposes all configured colors', () {
      expect(brand.dark, const Color(0xFF111111));
      expect(brand.darker, const Color(0xFF000000));
      expect(brand.base, const Color(0xFF222222));
      expect(brand.alpha24, const Color(0x3D222222));
      expect(brand.alpha16, const Color(0x29222222));
      expect(brand.alpha10, const Color(0x1A222222));
      expect(brand.all, hasLength(6));
    });

    test('supports value equality and hashCode', () {
      const sameBrand = GtPaletteBrandColors(
        dark: Color(0xFF111111),
        darker: Color(0xFF000000),
        base: Color(0xFF222222),
        alpha24: Color(0x3D222222),
        alpha16: Color(0x29222222),
        alpha10: Color(0x1A222222),
      );
      expect(brand, equals(sameBrand));
      expect(brand.hashCode, equals(sameBrand.hashCode));
    });

    test('lerps smoothly between two brand color sets', () {
      const other = GtPaletteBrandColors(
        dark: Color(0xFF333333),
        darker: Color(0xFF222222),
        base: Color(0xFF444444),
        alpha24: Color(0x3D444444),
        alpha16: Color(0x29444444),
        alpha10: Color(0x1A444444),
      );
      final lerped = GtPaletteBrandColors.lerp(brand, other, 0.5);
      expect(lerped.base, Color.lerp(brand.base, other.base, 0.5));
      expect(lerped.dark, Color.lerp(brand.dark, other.dark, 0.5));
    });
  });

  group('GtPaletteStaticColors', () {
    const statics = GtPaletteStaticColors(
      black: Color(0xFF000000),
      white: Color(0xFFFFFFFF),
      shadow: Color(0x1F000000),
      transparent: Color(0x00000000),
    );

    test('exposes all static colors', () {
      expect(statics.black, const Color(0xFF000000));
      expect(statics.white, const Color(0xFFFFFFFF));
      expect(statics.shadow, const Color(0x1F000000));
      expect(statics.transparent, const Color(0x00000000));
      expect(statics.all, hasLength(3));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteStaticColors(
        black: Color(0xFF000000),
        white: Color(0xFFFFFFFF),
        shadow: Color(0x1F000000),
        transparent: Color(0x00000000),
      );
      expect(statics, equals(same));
      expect(statics.hashCode, equals(same.hashCode));

      final lerped = GtPaletteStaticColors.lerp(statics, same, 0.5);
      expect(lerped.black, statics.black);
    });
  });

  group('GtPaletteCardColors', () {
    const cards = GtPaletteCardColors(
      classic: Color(0xFF9C191C),
      business: Color(0xFF155653),
      prime: Color(0xFFDCDDDE),
      worldStop1: Color(0xFF4D4D4D),
      worldStop2: Color(0xFF262626),
      worldStop3: Color(0xFF1A1A1A),
    );

    test('creates world gradient from stops', () {
      expect(cards.classic, const Color(0xFF9C191C));
      expect(cards.business, const Color(0xFF155653));
      expect(cards.prime, const Color(0xFFDCDDDE));
      expect(cards.worldGradient.colors, [
        const Color(0xFF4D4D4D),
        const Color(0xFF262626),
        const Color(0xFF1A1A1A),
      ]);
      expect(cards.all, hasLength(6));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteCardColors(
        classic: Color(0xFF9C191C),
        business: Color(0xFF155653),
        prime: Color(0xFFDCDDDE),
        worldStop1: Color(0xFF4D4D4D),
        worldStop2: Color(0xFF262626),
        worldStop3: Color(0xFF1A1A1A),
      );
      expect(cards, equals(same));
      expect(cards.hashCode, equals(same.hashCode));
      final lerped = GtPaletteCardColors.lerp(cards, same, 0.5);
      expect(lerped.classic, cards.classic);
    });
  });

  group('GtPaletteCoverColors', () {
    const cover = GtPaletteCoverColors(
      dark: Color(0xFF0C3B48),
      light: Color(0xFFFFFFFF),
    );

    test('exposes properties and supports lerp/equality', () {
      expect(cover.dark, const Color(0xFF0C3B48));
      expect(cover.light, const Color(0xFFFFFFFF));
      expect(cover.all, hasLength(2));

      const same = GtPaletteCoverColors(
        dark: Color(0xFF0C3B48),
        light: Color(0xFFFFFFFF),
      );
      expect(cover, equals(same));
      expect(cover.hashCode, equals(same.hashCode));
      expect(GtPaletteCoverColors.lerp(cover, same, 0.5).dark, cover.dark);
    });
  });

  group('GtPaletteBgColors', () {
    const bg = GtPaletteBgColors(
      strong: Color(0xFF111111),
      surface: Color(0xFF262626),
      sub: Color(0xFFD1D1D1),
      soft: Color(0xFFEBEBEB),
      weak: Color(0xFFF7F7F7),
      white: Color(0xFFFFFFFF),
      warm: Color(0xFFFBFAF5),
      neutralWarm50: Color(0xFFF7F5F1),
      weaker: Color(0xFFF8F8F8),
      sky: Color(0x1AB8CDD9),
    );

    test('exposes all background tokens', () {
      expect(bg.strong, const Color(0xFF111111));
      expect(bg.surface, const Color(0xFF262626));
      expect(bg.sub, const Color(0xFFD1D1D1));
      expect(bg.soft, const Color(0xFFEBEBEB));
      expect(bg.weak, const Color(0xFFF7F7F7));
      expect(bg.white, const Color(0xFFFFFFFF));
      expect(bg.warm, const Color(0xFFFBFAF5));
      expect(bg.neutralWarm50, const Color(0xFFF7F5F1));
      expect(bg.weaker, const Color(0xFFF8F8F8));
      expect(bg.sky, const Color(0x1AB8CDD9));
      expect(bg.all, hasLength(10));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteBgColors(
        strong: Color(0xFF111111),
        surface: Color(0xFF262626),
        sub: Color(0xFFD1D1D1),
        soft: Color(0xFFEBEBEB),
        weak: Color(0xFFF7F7F7),
        white: Color(0xFFFFFFFF),
        warm: Color(0xFFFBFAF5),
        neutralWarm50: Color(0xFFF7F5F1),
        weaker: Color(0xFFF8F8F8),
        sky: Color(0x1AB8CDD9),
      );
      expect(bg, equals(same));
      expect(bg.hashCode, equals(same.hashCode));
      expect(GtPaletteBgColors.lerp(bg, same, 0.5).surface, bg.surface);
    });
  });

  group('GtPaletteContentColors & GtPaletteTextColors', () {
    const text = GtPaletteTextColors(
      strong: Color(0xFF111111),
      sub: Color(0xFF7B7B7B),
      darkerSub: Color(0xFF5C5C5C),
      soft: Color(0xFFA3A3A3),
      disabled: Color(0xFFD1D1D1),
      white: Color(0xFFFFFFFF),
    );

    test('exposes all text and content tokens', () {
      expect(text.strong, const Color(0xFF111111));
      expect(text.sub, const Color(0xFF7B7B7B));
      expect(text.darkerSub, const Color(0xFF5C5C5C));
      expect(text.soft, const Color(0xFFA3A3A3));
      expect(text.disabled, const Color(0xFFD1D1D1));
      expect(text.white, const Color(0xFFFFFFFF));
      expect(text.all, hasLength(6));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteTextColors(
        strong: Color(0xFF111111),
        sub: Color(0xFF7B7B7B),
        darkerSub: Color(0xFF5C5C5C),
        soft: Color(0xFFA3A3A3),
        disabled: Color(0xFFD1D1D1),
        white: Color(0xFFFFFFFF),
      );
      expect(text, equals(same));
      expect(text.hashCode, equals(same.hashCode));
      expect(
        GtPaletteTextColors.lerp(text, same, 0.5).darkerSub,
        text.darkerSub,
      );
    });
  });

  group('GtPaletteStrokeColors', () {
    const stroke = GtPaletteStrokeColors(
      strong: Color(0xFF111111),
      sub: Color(0xFFD1D1D1),
      soft: Color(0xFFEBEBEB),
      white: Color(0xFFFFFFFF),
    );

    test('exposes all stroke tokens', () {
      expect(stroke.strong, const Color(0xFF111111));
      expect(stroke.sub, const Color(0xFFD1D1D1));
      expect(stroke.soft, const Color(0xFFEBEBEB));
      expect(stroke.white, const Color(0xFFFFFFFF));
      expect(stroke.all, hasLength(4));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteStrokeColors(
        strong: Color(0xFF111111),
        sub: Color(0xFFD1D1D1),
        soft: Color(0xFFEBEBEB),
        white: Color(0xFFFFFFFF),
      );
      expect(stroke, equals(same));
      expect(stroke.hashCode, equals(same.hashCode));
      expect(GtPaletteStrokeColors.lerp(stroke, same, 0.5).soft, stroke.soft);
    });
  });

  group('GtPaletteStateColors', () {
    const state = GtPaletteStateColors(
      darker: Color(0xFF0B4627),
      dark: Color(0xFF16643B),
      base: Color(0xFF1FC16B),
      light: Color(0xFFC2F5DA),
      lighter: Color(0xFFE0FAEC),
    );

    test('exposes all state tokens', () {
      expect(state.darker, const Color(0xFF0B4627));
      expect(state.dark, const Color(0xFF16643B));
      expect(state.base, const Color(0xFF1FC16B));
      expect(state.light, const Color(0xFFC2F5DA));
      expect(state.lighter, const Color(0xFFE0FAEC));
      expect(state.all, hasLength(5));
    });

    test('supports equality and lerp', () {
      const same = GtPaletteStateColors(
        darker: Color(0xFF0B4627),
        dark: Color(0xFF16643B),
        base: Color(0xFF1FC16B),
        light: Color(0xFFC2F5DA),
        lighter: Color(0xFFE0FAEC),
      );
      expect(state, equals(same));
      expect(state.hashCode, equals(same.hashCode));
      expect(GtPaletteStateColors.lerp(state, same, 0.5).base, state.base);
    });
  });

  group('GtPaletteRawColors', () {
    test('resolves light values when isDark is false', () {
      const rawLight = GtPaletteRawColors.light();
      expect(rawLight.isDark, isFalse);

      // Primitive & Neutrals
      expect(rawLight.ash, GtColors.ash.value);
      expect(rawLight.night, GtColors.night.value);
      expect(rawLight.white, GtColors.white.value);
      expect(rawLight.black, GtColors.black.value);
      expect(rawLight.neutral950, GtColors.neutral950.value);
      expect(rawLight.neutral0, GtColors.neutral0.value);
      expect(rawLight.neutralWarm50, GtColors.neutralWarm50.value);

      // Vibrants
      expect(rawLight.blue500, GtColors.blue500.value);
      expect(rawLight.orange500, GtColors.orange500.value);
      expect(rawLight.red500, GtColors.red500.value);
      expect(rawLight.green500, GtColors.green500.value);
      expect(rawLight.yellow500, GtColors.yellow500.value);
      expect(rawLight.purple500, GtColors.purple500.value);
      expect(rawLight.pink500, GtColors.pink500.value);
      expect(rawLight.teal500, GtColors.teal500.value);
      expect(rawLight.tealBlue600, GtColors.tealBlue600.value);
      expect(rawLight.sky500, GtColors.sky500.value);
      expect(rawLight.maroon600, GtColors.maroon600.value);
      expect(rawLight.navy, GtColors.navy.value);

      // Alphas
      expect(rawLight.blueAlpha24, GtColors.blueAlpha24.value);
      expect(rawLight.blueAlpha15, GtColors.blueAlpha15.value);
      expect(rawLight.blueAlpha3, GtColors.blueAlpha3.value);
      expect(rawLight.navyAlpha24, GtColors.navyAlpha24.value);
      expect(rawLight.navyAlpha15, GtColors.navyAlpha15.value);
      expect(rawLight.navyAlpha3, GtColors.navyAlpha3.value);
      expect(rawLight.whiteAlpha24, GtColors.whiteAlpha24.value);
      expect(rawLight.blackAlpha24, GtColors.blackAlpha24.value);

      // List and invocation operators
      expect(rawLight.all, hasLength(GtColors.values.length));
      expect(rawLight(GtColors.blue500), GtColors.blue500.value);
      expect(rawLight[GtColors.blue500], GtColors.blue500.value);
      expect(rawLight[GtColors.navy], GtColors.navy.value);
    });

    test('resolves dark values when isDark is true', () {
      const rawDark = GtPaletteRawColors.dark();
      expect(rawDark.isDark, isTrue);

      // In dark mode, neutral950 resolves to dark variant
      expect(rawDark.neutral950, GtColors.neutral950.dark);
      expect(rawDark.neutral0, GtColors.neutral0.dark);
      expect(rawDark.neutralWarm50, GtColors.neutralWarm50.dark);

      // Single-variant colors resolve to their dark/value
      expect(rawDark.blue500, GtColors.blue500.dark);
      expect(rawDark.green500, GtColors.green500.dark);

      // Index and callable operator
      expect(rawDark(GtColors.neutral950), GtColors.neutral950.dark);
      expect(rawDark[GtColors.neutral950], GtColors.neutral950.dark);
    });

    test('supports equality, hashCode, and lerp', () {
      const light1 = GtPaletteRawColors.light();
      const light2 = GtPaletteRawColors(isDark: false);
      const dark = GtPaletteRawColors.dark();

      expect(light1, equals(light2));
      expect(light1.hashCode, equals(light2.hashCode));
      expect(light1, isNot(equals(dark)));

      expect(GtPaletteRawColors.lerp(light1, dark, 0.2), equals(light1));
      expect(GtPaletteRawColors.lerp(light1, dark, 0.8), equals(dark));
    });
  });

  group('GtPalette, GtLightPalette, and GtDarkPalette', () {
    test(
      'GtLightPalette provides standard light theme tokens and raw colors',
      () {
        final palette = PersonalLightPalette();

        expect(palette.raw.isDark, isFalse);
        expect(palette.raw.blue500, GtColors.blue500.value);

        // Check default static and background colors
        expect(palette.staticColors.black, GtColors.neutral950.value);
        expect(palette.staticColors.white, GtColors.neutral0.value);
        expect(palette.bg.white, GtColors.neutral0.value);
        expect(palette.bg.strong, GtColors.neutral950.value);
        expect(palette.all, isNotEmpty);
      },
    );

    test(
      'GtDarkPalette provides standard dark theme tokens and raw colors',
      () {
        final palette = PersonalDarkPalette();

        expect(palette.raw.isDark, isTrue);
        expect(palette.raw.neutral950, GtColors.neutral950.dark);

        // Check dark background and text overrides
        expect(palette.bg.strong, GtColors.neutral950.dark);
        expect(palette.text.strong, GtColors.neutral950.dark);
        expect(palette.all, isNotEmpty);
      },
    );

    test('GtPalette supports lerp between light and dark palettes', () {
      final light = PersonalLightPalette();
      final dark = PersonalDarkPalette();

      final lerped = light.lerp(dark, 0.5) as GtPalette;
      expect(
        lerped.primary.base,
        Color.lerp(light.primary.base, dark.primary.base, 0.5),
      );
      expect(
        lerped.bg.surface,
        Color.lerp(light.bg.surface, dark.bg.surface, 0.5),
      );
    });

    test('GtPalette copyWith returns identical palette instance', () {
      final palette = PersonalLightPalette();
      expect(palette.copyWith(), same(palette));
    });
  });

  group('App Flavor Palettes', () {
    test('Personal flavor palettes configure correct brand identity', () {
      final light = PersonalLightPalette();
      final dark = PersonalDarkPalette();

      expect(light.primary.darker, GtColors.tealBlue800.value);
      expect(light.primary.base, GtColors.tealBlue600.value);
      expect(dark.primary.base, GtColors.tealBlue600.value);
      expect(light.raw.isDark, isFalse);
      expect(dark.raw.isDark, isTrue);
    });

    test('Kids flavor palettes configure correct brand identity', () {
      final light = KidsLightPalette();
      final dark = KidsDarkPalette();

      expect(light.primary.base, GtColors.purple600.value);
      expect(dark.primary.base, GtColors.purple600.value);
      expect(light.raw.isDark, isFalse);
      expect(dark.raw.isDark, isTrue);
    });

    test('Flex flavor palettes configure correct brand identity', () {
      final light = FlexLightPalette();
      final dark = FlexDarkPalette();

      expect(light.primary.base, GtColors.green600.value);
      expect(dark.primary.base, GtColors.green600.value);
      expect(light.raw.isDark, isFalse);
      expect(dark.raw.isDark, isTrue);
    });

    test('GoTech flavor palettes configure correct brand identity', () {
      final light = GotechLightPalette();
      final dark = GotechDarkPalette();

      expect(light.primary.base, GtColors.teal700.value);
      expect(dark.primary.base, GtColors.teal700.value);
      expect(light.raw.isDark, isFalse);
      expect(dark.raw.isDark, isTrue);
    });

    test('SterlingPro flavor palettes configure correct brand identity', () {
      final light = SterlingProLightPalette();
      final dark = SterlingProDarkPalette();

      expect(light.primary.base, GtColors.maroon600.value);
      expect(dark.primary.base, GtColors.maroon600.value);
      expect(light.raw.isDark, isFalse);
      expect(dark.raw.isDark, isTrue);
    });
  });

  group('Theme Integration (BuildContext.palette)', () {
    testWidgets(
      'provides access to active GtPalette and raw colors via context',
      (tester) async {
        late GtPalette resolvedPalette;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [PersonalLightPalette()]),
            home: Builder(
              builder: (context) {
                resolvedPalette = context.palette;
                return Container(
                  color: context.palette.primary.base,
                  child: Text(
                    'Test',
                    style: TextStyle(color: context.palette.raw.blue500),
                  ),
                );
              },
            ),
          ),
        );

        expect(resolvedPalette, isA<PersonalLightPalette>());
        expect(resolvedPalette.raw.blue500, GtColors.blue500.value);
        expect(resolvedPalette.raw.isDark, isFalse);
      },
    );
  });
}
