import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The dark mode palette for the GoTech brand.
///
/// The teals have no dark variants, and light mode's teal 700 leaves a white
/// primary button label just short of 4.5:1. Here [GtPaletteBrandColors.base]
/// is teal 750, which keeps white labels above 4.5:1 and a selected tab above
/// 3:1 on the navigation pill. [GtPaletteBrandColors.dark] is teal 850, which
/// also carries the avatar's white initials, and [GtPaletteBrandColors.darker]
/// is teal 800, so the dashboard wash shows on the dark surface; light mode's
/// teal 950 all but disappears there.
///
/// [GtPaletteBgColors.warm] is the plain dark surface rather than the standard
/// warm tint, so the dashboard's teal wash settles into black instead of
/// blending into a murky band.
///
/// Brand text and icons on the page use [GtPaletteBrandColors.ink], teal 600,
/// which reads at 5.5:1 or better on the weak background; the button tone
/// is too dark to read as text there.
final class GotechDarkPalette extends GtDarkPalette {
  /// Creates a [GotechDarkPalette].
  GotechDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.teal800.value,
          dark: GtColors.teal850.value,
          base: GtColors.teal750.value,
          alpha24: GtColors.tealAlpha24.value,
          alpha16: GtColors.tealAlpha16.value,
          alpha10: GtColors.tealAlpha10.value,
          ink: GtColors.teal600.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.teal950.dark,
          light: GtColors.teal500.dark,
        ),
        bg: GtDarkPalette.defaultBg.copyWith(warm: GtColors.neutral0.dark),
      );
}
