import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final class FlexDarkPalette extends GtDarkPalette {
  FlexDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.green800.value,
          dark: GtColors.green700.value,
          base: GtColors.green600.value,
          alpha24: GtColors.greenAlpha24.value,
          alpha16: GtColors.greenAlpha16.value,
          alpha10: GtColors.greenAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.green950.dark,
          light: GtColors.green200.dark,
        ),
      );
}
