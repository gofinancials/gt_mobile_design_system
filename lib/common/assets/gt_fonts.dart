/// A configuration class for typography font families within the design system.
///
/// This class provides static constants for the available font families
/// and instance properties to map semantic text categories (like title, body,
/// and display) to specific fonts.
class GtFonts {
  /// The font family for our icons.
  static const String icon = 'GtIconFont';

  /// The 'Youth' font family.
  static const String _youth = 'Youth';

  /// The 'Open Runde' font family.
  static const String _runde = 'Runde';

  /// The font family used for title text.
  final String title;

  /// The font family used for regular body text.
  final String body;

  /// Creates a new [GtFonts] configuration.
  ///
  /// Defaults to [readex] for titles, [youth] for displays, and [inter] for body text.
  const GtFonts({this.title = _youth, this.body = _runde});

  /// A list containing all available font families.
  static List<({String label, String value})> get all => [
    (label: 'icon', value: icon),
    (label: 'youth', value: _youth),
    (label: 'open-runde', value: _runde),
  ];
}
