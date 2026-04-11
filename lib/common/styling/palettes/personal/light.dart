import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class PersonalLightPalette extends GtPalette {
  PersonalLightPalette()
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
            shadow: GtColors.neutralGray700.value,
          ),
          bg: GtPaletteBgColors(
            strong: GtColors.neutralGray950.value,
            surface: GtColors.neutralGray0.value,
            sub: GtColors.neutralGray50.value,
            soft: GtColors.neutralGray100.value,
            weak: GtColors.neutralGray200.value,
            white: GtColors.neutralGray0.value,
          ),
          text: GtPaletteContentColors(
            strong: GtColors.neutralGray950.value,
            sub: GtColors.neutralGray600.value,
            soft: GtColors.neutralGray400.value,
            disabled: GtColors.neutralGray300.value,
            white: GtColors.neutralGray0.value,
          ),
          icon: GtPaletteContentColors(
            strong: GtColors.neutralGray950.value,
            sub: GtColors.neutralGray600.value,
            soft: GtColors.neutralGray400.value,
            disabled: GtColors.neutralGray300.value,
            white: GtColors.neutralGray0.value,
          ),
          stroke: GtPaletteStrokeColors(
            strong: GtColors.neutralGray950.value,
            sub: GtColors.neutralGray300.value,
            soft: GtColors.neutralGray200.value,
            white: GtColors.neutralGray0.value,
          ),
          faded: GtPaletteStateColors(
            dark: GtColors.neutralGray800.value,
            base: GtColors.neutralGray500.value,
            light: GtColors.neutralGray200.value,
            lighter: GtColors.neutralGray100.value,
          ),
          information: GtPaletteStateColors(
            dark: GtColors.blue950.value,
            base: GtColors.blue500.value,
            light: GtColors.blue200.value,
            lighter: GtColors.blue50.value,
          ),
          warning: GtPaletteStateColors(
            dark: GtColors.orange950.value,
            base: GtColors.orange500.value,
            light: GtColors.orange200.value,
            lighter: GtColors.orange50.value,
          ),
          error: GtPaletteStateColors(
            dark: GtColors.red950.value,
            base: GtColors.red500.value,
            light: GtColors.red200.value,
            lighter: GtColors.red50.value,
          ),
          success: GtPaletteStateColors(
            dark: GtColors.green950.value,
            base: GtColors.green500.value,
            light: GtColors.green200.value,
            lighter: GtColors.green50.value,
          ),
          away: GtPaletteStateColors(
            dark: GtColors.yellow950.value,
            base: GtColors.yellow500.value,
            light: GtColors.yellow200.value,
            lighter: GtColors.yellow50.value,
          ),
          feature: GtPaletteStateColors(
            dark: GtColors.purple950.value,
            base: GtColors.purple500.value,
            light: GtColors.purple200.value,
            lighter: GtColors.purple50.value,
          ),
          verified: GtPaletteStateColors(
            dark: GtColors.sky950.value,
            base: GtColors.sky500.value,
            light: GtColors.sky200.value,
            lighter: GtColors.sky50.value,
          ),
          highlighted: GtPaletteStateColors(
            dark: GtColors.pink950.value,
            base: GtColors.pink500.value,
            light: GtColors.pink200.value,
            lighter: GtColors.pink50.value,
          ),
          stable: GtPaletteStateColors(
            dark: GtColors.teal950.value,
            base: GtColors.teal500.value,
            light: GtColors.teal200.value,
            lighter: GtColors.teal50.value,
          ),
        );
}
