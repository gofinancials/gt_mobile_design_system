import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The light mode palette for the GoTech brand.
///
/// Built on teal brand colors, with teal tints for its alpha tones.
final class GotechLightPalette extends GtLightPalette {
  /// Creates a [GotechLightPalette].
  GotechLightPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.teal950.value,
          dark: GtColors.teal800.value,
          base: GtColors.teal700.value,
          alpha24: GtColors.tealAlpha24.value,
          alpha16: GtColors.tealAlpha16.value,
          alpha10: GtColors.tealAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.teal950.value,
          light: GtColors.teal500.value,
        ),
      );
}
