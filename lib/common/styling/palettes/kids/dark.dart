import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The dark mode palette for the Kids brand.
///
/// The purples have no dark variants, so each brand tone sits one step brighter
/// than in light mode: [GtPaletteBrandColors.darker] is purple 700,
/// [GtPaletteBrandColors.dark] is purple 600 and [GtPaletteBrandColors.base] is
/// purple 500. Light mode's purple 800 turns grey on the dark surface, and a
/// selected tab drawn in purple 600 on the navigation pill falls short of 3:1.
///
/// [GtPaletteBgColors.warm] is the plain dark surface rather than the standard
/// warm tint, so the dashboard's purple wash settles into black instead of
/// blending into a brown band.
final class KidsDarkPalette extends GtDarkPalette {
  /// Creates a [KidsDarkPalette].
  KidsDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.purple700.value,
          dark: GtColors.purple600.value,
          base: GtColors.purple500.value,
          alpha24: GtColors.purpleAlpha24.value,
          alpha16: GtColors.purpleAlpha16.value,
          alpha10: GtColors.purpleAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.purple950.dark,
          light: GtColors.purple200.dark,
        ),
        bg: GtDarkPalette.defaultBg.copyWith(warm: GtColors.neutral0.dark),
      );
}
