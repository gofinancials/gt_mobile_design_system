import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The dark mode palette for the Personal brand.
///
/// The teal blues have no dark variants, and light mode's teal blue 600 is too
/// light to carry white text: a primary button label lands near 2:1. Here
/// [GtPaletteBrandColors.base] is teal blue 725, which keeps white labels above
/// 4.5:1 and a selected tab above 3:1 on the navigation pill.
/// [GtPaletteBrandColors.dark] is teal blue 750, which also carries the
/// avatar's white initials, and [GtPaletteBrandColors.darker] is teal blue 700,
/// so the dashboard wash shows on the dark surface; light mode's teal blue 800
/// all but disappears there.
///
/// [GtPaletteBgColors.warm] is the plain dark surface rather than the standard
/// warm tint, so the dashboard's teal wash settles into black instead of
/// blending into a murky band.
final class PersonalDarkPalette extends GtDarkPalette {
  /// Creates a [PersonalDarkPalette].
  PersonalDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.tealBlue700.value,
          dark: GtColors.tealBlue750.value,
          base: GtColors.tealBlue725.value,
          alpha24: GtColors.tealBlueAlpha24.value,
          alpha16: GtColors.tealBlueAlpha16.value,
          alpha10: GtColors.tealBlueAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.tealBlue800.dark,
          light: GtColors.white.value,
        ),
        bg: GtDarkPalette.defaultBg.copyWith(warm: GtColors.neutral0.dark),
      );
}
