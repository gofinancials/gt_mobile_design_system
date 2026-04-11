import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class PrivateDarkPalette extends GtPalette {
  PrivateDarkPalette()
      : super(
          primary: GtPaletteBrandColors(
            darker: GtColors.teal900.value,
            dark: GtColors.teal800.value,
            base: GtColors.blue700.value,
            alpha16: GtColors.blueAlpha16.value,
            alpha10: GtColors.blueAlpha10.value,
          ),
          sterling: GtPaletteBrandColors(
            darker: GtColors.teal900.value,
            dark: GtColors.teal800.value,
            base: GtColors.blue700.value,
            alpha16: GtColors.blueAlpha16.value,
            alpha10: GtColors.blueAlpha10.value,
          ),
          staticColors: GtPaletteStaticColors(
            black: GtColors.neutralGray950.value,
            white: GtColors.neutralGray0.value,
            shadow: GtColors.neutralGray700.dark,
          ),
          bg: GtPaletteBgColors(
            strong: GtColors.neutralGray0.value,
            surface: GtColors.neutralGray950.value,
            sub: GtColors.neutralGray900.value,
            soft: GtColors.neutralGray800.value,
            weak: GtColors.neutralGray700.value,
            white: GtColors.neutralGray950.value,
          ),
          text: GtPaletteContentColors(
            strong: GtColors.neutralGray0.value,
            sub: GtColors.neutralGray400.value,
            soft: GtColors.neutralGray500.value,
            disabled: GtColors.neutralGray600.value,
            white: GtColors.neutralGray950.value,
          ),
          icon: GtPaletteContentColors(
            strong: GtColors.neutralGray0.value,
            sub: GtColors.neutralGray400.value,
            soft: GtColors.neutralGray500.value,
            disabled: GtColors.neutralGray600.value,
            white: GtColors.neutralGray950.value,
          ),
          stroke: GtPaletteStrokeColors(
            strong: GtColors.neutralGray0.value,
            sub: GtColors.neutralGray600.value,
            soft: GtColors.neutralGray700.value,
            white: GtColors.neutralGray950.value,
          ),
          faded: GtPaletteStateColors(
            dark: GtColors.neutralGray500.value,
            base: GtColors.neutralGray500.value,
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
