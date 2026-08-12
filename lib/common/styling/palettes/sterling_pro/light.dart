import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class SterlingProLightPalette extends GtLightPalette {
  SterlingProLightPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.maroon800.value,
          dark: GtColors.maroon700.value,
          base: GtColors.maroon600.value,
          alpha24: GtColors.maroonAlpha24.value,
          alpha16: GtColors.maroonAlpha16.value,
          alpha10: GtColors.maroonAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.maroon800.value,
          light: GtColors.neutral0.value,
        ),
      );
}
