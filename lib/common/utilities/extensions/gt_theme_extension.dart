import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An extension on [GtTheme] providing static utilities for accessing
/// predefined themes within the application.
extension GtThemeExtension on GtTheme {
  /// A comprehensive list of all available themes in the design system.
  ///
  /// This list includes predefined themes such as [kPersonalTheme] and [kKidsTheme].
  static List<GtTheme> allThemes = [kPersonalTheme, kKidsTheme];

   /// Retrieves the default theme, which is the first theme in the list of all themes.
   /// This can be used as a fallback or default selection when no specific theme is chosen.
  static GtTheme get defaultTheme => allThemes.first;
}
