/// A utility class that holds the paths to general vector assets (SVGs) used in the application.
///
/// This class centralizes asset paths for core vector assets, such as logos, to prevent
/// typos and make them easily accessible throughout the app.
class GtVectors {
  static const _basePath = "packages/gt_mobile_ui/assets/images/vector";

  /// Path to the logo SVG.
  static const logo = "$_basePath/logo.svg";

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

  /// Path to the trend down SVG.
  static const trendDown = "$_basePath/trend_down.svg";

  /// A list containing all available core vector asset paths.
  static List<String> get all => [
    logo,
    clock,
    coin,
    tapRight,
    tapLeft,
    sterling,
    trendDown,
  ];
}
