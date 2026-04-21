import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class KidsLightPalette extends GtPalette {
  KidsLightPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.purple800.value,
          dark: GtColors.purple700.value,
          base: GtColors.purple600.value,
          alpha24: GtColors.purpleAlpha24.value,
          alpha16: GtColors.purpleAlpha16.value,
          alpha10: GtColors.purpleAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.purple950.value,
          light: GtColors.purple200.value,
        ),
        staticColors: GtPaletteStaticColors(
          black: GtColors.neutral950.value,
          white: GtColors.neutral0.value,
          shadow: GtColors.neutralGray700.value,
        ),
        bg: GtPaletteBgColors(
          strong: GtColors.neutral950.value,
          surface: GtColors.neutral800.value,
          sub: GtColors.neutral300.value,
          soft: GtColors.neutral200.value,
          weak: GtColors.neutral50.value,
          white: GtColors.neutral0.value,
        ),
        text: GtPaletteTextColors(
          strong: GtColors.neutral950.value,
          sub: GtColors.neutral500.value,
          darkerSub: GtColors.neutral600.value,
          soft: GtColors.neutral400.value,
          disabled: GtColors.neutral300.value,
          white: GtColors.neutral0.value,
        ),
        icon: GtPaletteContentColors(
          strong: GtColors.neutral950.value,
          sub: GtColors.neutral600.value,
          soft: GtColors.neutral400.value,
          disabled: GtColors.neutral300.value,
          white: GtColors.neutral0.value,
        ),
        stroke: GtPaletteStrokeColors(
          strong: GtColors.neutral950.value,
          sub: GtColors.neutral300.value,
          soft: GtColors.neutral200.value,
          white: GtColors.neutral0.value,
        ),
        faded: GtPaletteStateColors(
          darker: GtColors.neutral700.value,
          dark: GtColors.neutral800.value,
          base: GtColors.neutral500.value,
          light: GtColors.neutral200.value,
          lighter: GtColors.neutral100.value,
        ),
        information: GtPaletteStateColors(
          darker: GtColors.blue700.value,
          dark: GtColors.blue950.value,
          base: GtColors.blue500.value,
          light: GtColors.blue200.value,
          lighter: GtColors.blue50.value,
        ),
        warning: GtPaletteStateColors(
          darker: GtColors.orange700.value,
          dark: GtColors.orange950.value,
          base: GtColors.orange500.value,
          light: GtColors.orange200.value,
          lighter: GtColors.orange50.value,
        ),
        error: GtPaletteStateColors(
          darker: GtColors.red700.value,
          dark: GtColors.red950.value,
          base: GtColors.red500.value,
          light: GtColors.red200.value,
          lighter: GtColors.red50.value,
        ),
        success: GtPaletteStateColors(
          darker: GtColors.green700.value,
          dark: GtColors.green950.value,
          base: GtColors.green500.value,
          light: GtColors.green200.value,
          lighter: GtColors.green50.value,
        ),
        away: GtPaletteStateColors(
          darker: GtColors.yellow700.value,
          dark: GtColors.yellow950.value,
          base: GtColors.yellow500.value,
          light: GtColors.yellow200.value,
          lighter: GtColors.yellow50.value,
        ),
        feature: GtPaletteStateColors(
          darker: GtColors.purple700.value,
          dark: GtColors.purple950.value,
          base: GtColors.purple500.value,
          light: GtColors.purple200.value,
          lighter: GtColors.purple50.value,
        ),
        verified: GtPaletteStateColors(
          darker: GtColors.sky700.value,
          dark: GtColors.sky950.value,
          base: GtColors.sky500.value,
          light: GtColors.sky200.value,
          lighter: GtColors.sky50.value,
        ),
        highlighted: GtPaletteStateColors(
          darker: GtColors.pink700.value,
          dark: GtColors.pink950.value,
          base: GtColors.pink500.value,
          light: GtColors.pink200.value,
          lighter: GtColors.pink50.value,
        ),
        stable: GtPaletteStateColors(
          darker: GtColors.teal700.value,
          dark: GtColors.teal950.value,
          base: GtColors.teal500.value,
          light: GtColors.teal200.value,
          lighter: GtColors.teal50.value,
        ),
      );
}
