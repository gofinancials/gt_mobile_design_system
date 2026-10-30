import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The dark mode palette for the Flex brand.
///
/// The greens have no dark variants, and light mode's green 600 is too light
/// to carry white text: a primary button label lands near 2.9:1. Here
/// [GtPaletteBrandColors.base] is green 750, which keeps white labels above
/// 4.5:1 and a selected tab above 3:1 on the navigation pill.
/// [GtPaletteBrandColors.dark] is green 800, which also carries the avatar's
/// white initials, and [GtPaletteBrandColors.darker] is green 700, so the
/// dashboard wash opens brighter than in light mode.
///
/// [GtPaletteBgColors.warm] is the plain dark surface rather than the standard
/// warm tint, so the dashboard's green wash settles into black instead of
/// blending into a brown band.
final class FlexDarkPalette extends GtDarkPalette {
  /// Creates a [FlexDarkPalette].
  FlexDarkPalette()
    : super(
        primary: GtPaletteBrandColors(
          darker: GtColors.green700.value,
          dark: GtColors.green800.value,
          base: GtColors.green750.value,
          alpha24: GtColors.greenAlpha24.value,
          alpha16: GtColors.greenAlpha16.value,
          alpha10: GtColors.greenAlpha10.value,
        ),
        coverColors: GtPaletteCoverColors(
          dark: GtColors.green950.dark,
          light: GtColors.green200.dark,
        ),
        bg: GtDarkPalette.defaultBg.copyWith(warm: GtColors.neutral0.dark),
      );
}
