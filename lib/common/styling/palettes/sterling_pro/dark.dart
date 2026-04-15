import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class SterlingProDarkPalette extends GtPalette {
  SterlingProDarkPalette()
      : super(
          primary: GtPaletteBrandColors(
            darker: GtColors.tealOrange800.value,
            dark: GtColors.tealOrange700.value,
            base: GtColors.tealOrange600.value,
            alpha24: GtColors.tealOrangeAlpha24.value,
            alpha16: GtColors.tealOrangeAlpha16.value,
            alpha10: GtColors.tealOrangeAlpha10.value,
          ),
          // sterling: GtPaletteBrandColors(
          //   darker: GtColors.purple800.value,
          //   dark: GtColors.purple700.value,
          //   base: GtColors.purple600.value,
          //   alpha24: GtColors.purpleAlpha24.value,
          //   alpha16: GtColors.purpleAlpha16.value,
          //   alpha10: GtColors.purpleAlpha10.value,
          // ),
          coverColors: GtPaletteCoverColors(
            dark: GtColors.purple950.dark,
            light: GtColors.purple200.dark,
          ),
          staticColors: GtPaletteStaticColors(
            black: GtColors.neutral950.value,
            white: GtColors.neutral0.value,
            shadow: GtColors.neutralGray700.dark,
          ),
          bg: GtPaletteBgColors(
            strong: GtColors.neutral950.dark,
            surface: GtColors.neutral800.dark,
            sub: GtColors.neutral300.dark,
            soft: GtColors.neutral200.dark,
            weak: GtColors.neutral50.dark,
            white: GtColors.neutral0.dark,
          ),
          text: GtPaletteContentColors(
            strong: GtColors.neutral950.dark,
            sub: GtColors.neutral600.dark,
            soft: GtColors.neutral400.dark,
            disabled: GtColors.neutral300.dark,
            white: GtColors.neutral0.dark,
          ),
          icon: GtPaletteContentColors(
            strong: GtColors.neutral950.dark,
            sub: GtColors.neutral600.dark,
            soft: GtColors.neutral400.dark,
            disabled: GtColors.neutral300.dark,
            white: GtColors.neutral0.dark,
          ),
          stroke: GtPaletteStrokeColors(
            strong: GtColors.neutral950.dark,
            sub: GtColors.neutral300.dark,
            soft: GtColors.neutral200.dark,
            white: GtColors.neutral0.dark,
          ),
          faded: GtPaletteStateColors(
            dark: GtColors.neutral300.value,
            base: GtColors.neutral500.value,
            light: GtColors.neutralAlpha24.value,
            lighter: GtColors.neutralAlpha16.value,
          ),
          information: GtPaletteStateColors(
            dark: GtColors.blue400.value,
            base: GtColors.blue500.value,
            light: GtColors.blueAlpha24.value,
            lighter: GtColors.blueAlpha16.value,
          ),
          warning: GtPaletteStateColors(
            dark: GtColors.orange400.value,
            base: GtColors.orange600.value,
            light: GtColors.orangeAlpha24.value,
            lighter: GtColors.orangeAlpha16.value,
          ),
          error: GtPaletteStateColors(
            dark: GtColors.red400.value,
            base: GtColors.red600.value,
            light: GtColors.redAlpha24.value,
            lighter: GtColors.redAlpha16.value,
          ),
          success: GtPaletteStateColors(
            dark: GtColors.green400.value,
            base: GtColors.green600.value,
            light: GtColors.greenAlpha24.value,
            lighter: GtColors.greenAlpha16.value,
          ),
          away: GtPaletteStateColors(
            dark: GtColors.yellow400.value,
            base: GtColors.yellow600.value,
            light: GtColors.yellowAlpha24.value,
            lighter: GtColors.yellowAlpha16.value,
          ),
          feature: GtPaletteStateColors(
            dark: GtColors.purple400.value,
            base: GtColors.purple500.value,
            light: GtColors.purpleAlpha24.value,
            lighter: GtColors.purpleAlpha16.value,
          ),
          verified: GtPaletteStateColors(
            dark: GtColors.sky400.value,
            base: GtColors.sky600.value,
            light: GtColors.skyAlpha24.value,
            lighter: GtColors.skyAlpha16.value,
          ),
          highlighted: GtPaletteStateColors(
            dark: GtColors.pink400.value,
            base: GtColors.pink600.value,
            light: GtColors.pinkAlpha24.value,
            lighter: GtColors.pinkAlpha16.value,
          ),
          stable: GtPaletteStateColors(
            dark: GtColors.teal400.value,
            base: GtColors.teal600.value,
            light: GtColors.tealAlpha24.value,
            lighter: GtColors.tealAlpha16.value,
          ),
        );
}
