/// A utility class that holds the paths to general vector assets (SVGs) used in the application.
///
/// This class centralizes asset paths for core vector assets, such as logos, to prevent
/// typos and make them easily accessible throughout the app.
class GtVectors {
  static const _basePath = "packages/gt_mobile_ui/assets/images/vector";

  /// Path to the logo SVG.
  static const logo = "$_basePath/logo.svg";

  /// Path to the oneBankProLogo SVG.
  static const oneBankProLogo = "$_basePath/one_bank_pro_logo.svg";

  /// Path to the oneBankProWordMark SVG.
  static const oneBankProWordMark =
      "$_basePath/white_one_bank_pro_word_mark.svg";

  /// Path to the whiteLogo SVG.
  static const whiteLogo = "$_basePath/logo_white.svg";

  /// Path to the clock SVG.
  static const clock = "$_basePath/clock.svg";

  /// Path to the coin SVG.
  static const coin = "$_basePath/coin.svg";

  /// Path to the tap right SVG.
  static const tapRight = "$_basePath/tap_right.svg";

  /// Path to the tap left SVG.
  static const tapLeft = "$_basePath/tap_left.svg";

  /// Path to the sterling SVG.
  static const sterling = "$_basePath/sterling.svg";

  /// Path to the sterling debit card SVG.
  static const sterlingCard = "$_basePath/sterling_card.svg";

  /// Path to the trend down SVG.
  static const trendDown = "$_basePath/trend_down.svg";

  /// Path to the trend down SVG.
  static const caution = "$_basePath/caution.svg";

  /// Path to the trend down SVG.
  static const masterCard = "$_basePath/master_card.svg";

  /// Path to the trend down SVG.
  static const chip = "$_basePath/chip.svg";

  /// A list containing all available core vector asset paths.
  static List<({String label, String value})> get all => [
    (label: 'logo', value: logo),
    (label: 'clock', value: clock),
    (label: 'coin', value: coin),
    (label: 'caution', value: caution),
    (label: 'tapRight', value: tapRight),
    (label: 'tapLeft', value: tapLeft),
    (label: 'sterling', value: sterling),
    (label: 'oneBankProLogo', value: oneBankProLogo),
    (label: 'oneBankProWordMark', value: oneBankProWordMark),
    (label: 'trendDown', value: trendDown),
    (label: 'masterCard', value: masterCard),
    (label: 'whiteLogo', value: whiteLogo),
    (label: 'sterlingCard', value: sterlingCard),
    (label: 'chip', value: chip),
  ];
}
