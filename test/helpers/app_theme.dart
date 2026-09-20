import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A [GtTheme] subclass standing in for a theme an app defines to override
/// parts of a stock theme.
///
/// It copies the palettes and name of [base], so it only differs from [base]
/// by its runtime type.
class AppTheme extends GtTheme {
  AppTheme(GtTheme base)
    : super(
        lightPalette: base.lightPalette,
        darkPalette: base.darkPalette,
        name: base.name,
      );
}
