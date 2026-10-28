/// A configuration class for typography font families within the design system.
///
/// This class provides static constants for the available font families
/// and instance properties to map semantic text categories (like title, body,
/// and display) to specific fonts.
class GtFonts {
  /// The font family for our icons.
  static const String icon = 'GtIconFont';

  /// The 'Momo' font family.
  ///
  /// The bundled Momo Trust Display carries currency symbols copied in from
  /// GoTech Display, such as ₦, and is scaled to Youth's cap height; see the
  /// note on the font asset in `pubspec.yaml`. Every size set in this family
  /// is scaled down again in [GtTextStyles.buildStyle], where Momo's wider
  /// uppercase and digits take up Youth's width.
  static const String _momo = 'Momo';

  /// The 'Open Runde' font family.
  static const String _runde = 'Runde';

  /// The font family used for title text.
  final String title;

  /// The font family used for regular body text.
  final String body;

  /// Creates a new [GtFonts] configuration.
  ///
  /// Defaults to [momo] for titles and displays, and [runde] for body text.
  const GtFonts({this.title = _momo, this.body = _runde});

  /// A list containing all available font families.
  static List<({String label, String value})> get all => [
    (label: 'icon', value: icon),
    (label: 'youth', value: _momo),
    (label: 'open-runde', value: _runde),
  ];
}
