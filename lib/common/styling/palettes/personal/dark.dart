import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class PersonalDarkPalette extends GtDarkPalette {
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
      );
}
