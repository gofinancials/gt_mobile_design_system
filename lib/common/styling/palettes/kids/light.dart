import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class KidsLightPalette extends GtLightPalette {
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
      );
}
