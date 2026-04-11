/// Represents the spacing system from the Gt design guide.
///
/// Uses semantic naming to build flexible and consistent layouts.
/// The default values match the standard design system scale.
class GtSpacing {
  // Category: Spacing between elements inside components
  /// Very tight, fine-detail spacing. Default: 2.0
  final double xs;

  /// Tight, small gap. Default: 4.0
  final double sm;

  /// The base layout unit. Often the 'default' gap. Default: 8.0
  final double base;

  /// A relaxed component-level gap. Default: 12.0
  final double md;

  /// A loose, clear component-level gap. Default: 16.0
  final double lg;

  /// The largest gap for internal component structure. Default: 20.0
  final double xl;

  // Category: Spacing between sections
  /// Small gap between distinct sections. Default: 24.0
  final double sectionSm;

  /// Medium, clear gap between sections. Default: 32.0
  final double sectionMd;

  /// Large, defined gap between sections. Default: 40.0
  final double sectionLg;

  /// Extra-large separation between major structural areas. Default: 48.0
  final double sectionXl;

  /// Significant separation. Default: 56.0
  final double section2xl;

  /// Very large separation. Default: 64.0
  final double section3xl;

  /// Maximum separation defined in the system. Default: 80.0
  final double section4xl;

  const GtSpacing({
    this.xs = 2.0,
    this.sm = 4.0,
    this.base = 8.0,
    this.md = 12.0,
    this.lg = 16.0,
    this.xl = 20.0,
    this.sectionSm = 24.0,
    this.sectionMd = 32.0,
    this.sectionLg = 40.0,
    this.sectionXl = 48.0,
    this.section2xl = 56.0,
    this.section3xl = 64.0,
    this.section4xl = 80.0,
  });
}
