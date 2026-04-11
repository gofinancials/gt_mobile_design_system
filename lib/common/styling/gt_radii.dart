/// Represents the corner radius system from the design guide.
///
/// Uses abstract, size-based semantic naming (T-shirt sizing) instead of
/// hardcoded pixel values to allow for easier theming and mental mapping.
class GtRadii {
  /// Sharp corner. Default: 0.0
  final double none;

  /// Extra extra small radius. Default: 2.0
  final double xxs;

  /// Extra small radius. Default: 4.0
  final double xs;

  /// Small radius. Default: 6.0
  final double sm;

  /// Medium radius (often the default for cards/buttons). Default: 8.0
  final double md;

  /// Large radius. Default: 10.0
  final double lg;

  /// Extra large radius. Default: 12.0
  final double xl;

  /// 2x Extra large radius. Default: 16.0
  final double xxl;

  /// 3x Extra large radius. Default: 20.0
  final double xxxl;

  /// 4x Extra large radius. Default: 24.0
  final double xxxxl;

  /// 5x Extra large radius. Default: 28.0
  final double xxxxxl;

  /// Fully rounded corner (pill shape). Default: 999.0
  final double full;

  const GtRadii({
    this.none = 0.0,
    this.xxs = 2.0,
    this.xs = 4.0,
    this.sm = 6.0,
    this.md = 8.0,
    this.lg = 10.0,
    this.xl = 12.0,
    this.xxl = 16.0,
    this.xxxl = 20.0,
    this.xxxxl = 24.0,
    this.xxxxxl = 28.0,
    this.full = 999.0,
  });
}
