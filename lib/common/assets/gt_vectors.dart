/// A utility class that holds the paths to general vector assets (SVGs) used in the application.
///
/// This class centralizes asset paths for core vector assets, such as logos, to prevent
/// typos and make them easily accessible throughout the app.
class GtVectors {
  static const _basePath = "packages/gt_mobile_ui/assets/images/vector";

  // region ILLUSTRATIONS

  /// Path to the logo SVG.
  static const logo = "$_basePath/logo.svg";
  static const clock = "$_basePath/clock.svg";
  static const coin = "$_basePath/coin.svg";

  /// A list containing all available general vector SVG paths.
  static List<String> get all => [logo, clock, coin];
}
