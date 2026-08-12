import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class GotechLightPalette extends GtLightPalette {
  GotechLightPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.teal950.value,
          dark: GtColors.teal800.value,
          base: GtColors.teal700.value,
          alpha24: GtColors.greenAlpha24.value,
          alpha16: GtColors.greenAlpha16.value,
          alpha10: GtColors.greenAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.teal950.value,
          light: GtColors.teal500.value,
        ),
      );
}
