import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class PersonalDarkPalette extends GtPalette {
  PersonalDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.tealBlue800.value,
          dark: GtColors.tealBlue700.value,
          base: GtColors.tealBlue600.value,
          alpha24: GtColors.tealBlueAlpha24.value,
          alpha16: GtColors.tealBlueAlpha16.value,
          alpha10: GtColors.tealBlueAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.tealBlue800.dark,
          light: GtColors.white.value,
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
        text: GtPaletteTextColors(
          strong: GtColors.neutral950.dark,
          sub: GtColors.neutral500.dark,
          darkerSub: GtColors.neutral600.dark,
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
          darker: GtColors.neutral200.value,
          dark: GtColors.neutral300.value,
          base: GtColors.neutral500.value,
          light: GtColors.neutralAlpha24.value,
          lighter: GtColors.neutralAlpha16.value,
        ),
        information: GtPaletteStateColors(
          darker: GtColors.blue200.value,
          dark: GtColors.blue400.value,
          base: GtColors.blue600.value,
          light: GtColors.blueAlpha24.value,
          lighter: GtColors.blueAlpha16.value,
        ),
        warning: GtPaletteStateColors(
          darker: GtColors.orange200.value,
          dark: GtColors.orange400.value,
          base: GtColors.orange600.value,
          light: GtColors.orangeAlpha16.value,
          lighter: GtColors.orangeAlpha16.value,
        ),
        error: GtPaletteStateColors(
          darker: GtColors.red200.value,
          dark: GtColors.red400.value,
          base: GtColors.red600.value,
          light: GtColors.redAlpha24.value,
          lighter: GtColors.redAlpha16.value,
        ),
        success: GtPaletteStateColors(
          darker: GtColors.green200.value,
          dark: GtColors.green400.value,
          base: GtColors.green600.value,
          light: GtColors.greenAlpha24.value,
          lighter: GtColors.greenAlpha16.value,
        ),
        away: GtPaletteStateColors(
          darker: GtColors.yellow200.value,
          dark: GtColors.yellow400.value,
          base: GtColors.yellow600.value,
          light: GtColors.yellowAlpha24.value,
          lighter: GtColors.yellowAlpha16.value,
        ),
        feature: GtPaletteStateColors(
          darker: GtColors.purple200.value,
          dark: GtColors.purple400.value,
          base: GtColors.purple600.value,
          light: GtColors.purpleAlpha24.value,
          lighter: GtColors.purpleAlpha16.value,
        ),
        verified: GtPaletteStateColors(
          darker: GtColors.sky200.value,
          dark: GtColors.sky400.value,
          base: GtColors.sky600.value,
          light: GtColors.skyAlpha24.value,
          lighter: GtColors.skyAlpha16.value,
        ),
        highlighted: GtPaletteStateColors(
          darker: GtColors.pink200.value,
          dark: GtColors.pink400.value,
          base: GtColors.pink600.value,
          light: GtColors.pinkAlpha24.value,
          lighter: GtColors.pinkAlpha16.value,
        ),
        stable: GtPaletteStateColors(
          darker: GtColors.teal200.value,
          dark: GtColors.teal400.value,
          base: GtColors.teal600.value,
          light: GtColors.tealAlpha24.value,
          lighter: GtColors.tealAlpha16.value,
        ),
      );
}
