import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The dark mode palette for the Sterling Pro brand.
///
/// Built on maroon brand colors, it draws illustrations in their red
/// variants.
///
/// The maroons have no dark variants, so each brand tone sits one step brighter
/// than in light mode: [GtPaletteBrandColors.darker] is maroon 700,
/// [GtPaletteBrandColors.dark] is maroon 600 and [GtPaletteBrandColors.base]
/// is red 700. Light mode's maroon 800 reads as a dull brown on the dark
/// surface, and a selected tab drawn in maroon 600 on the navigation pill falls
/// short of 3:1.
///
/// [GtPaletteBgColors.warm] is the plain dark surface rather than the standard
/// warm tint, so the dashboard's maroon wash settles into black instead of
/// blending into a brown band.
final class SterlingProDarkPalette extends GtDarkPalette {
  /// Creates a [SterlingProDarkPalette].
  SterlingProDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.maroon700.value,
          dark: GtColors.maroon600.value,
          base: GtColors.red700.value,
          alpha24: GtColors.maroonAlpha24.value,
          alpha16: GtColors.maroonAlpha16.value,
          alpha10: GtColors.maroonAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.maroon800.dark,
          light: GtColors.neutral0.value,
        ),
        bg: GtDarkPalette.defaultBg.copyWith(warm: GtColors.neutral0.dark),
        usesRedIllustration: true,
      );
}
