import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Internal enumeration of predefined gap sizes.
enum _GtGapSize {
  xs,
  sm,
  base,
  md,
  lg,
  xl,
  sectionSm,
  sectionMd,
  sectionLg,
  sectionXl,
  section2xl,
  section3xl,
  section4xl,
}

/// Defines the dimensional behavior of a [GtGap].
enum GtGapType {
  /// Applies the gap size to both width and height equally.
  square,

  /// Applies the gap size to height only.
  vertical,

  /// Applies the gap size to width only.
  horizontal,
}

/// A widget that provides standardized spacing based on the design system scale.
///
/// [GtGap] uses a [SizedBox] internally to apply precise spacing. It provides
/// convenient named constructors for square (`s`), vertical (`y`), and
/// horizontal (`h`) gaps across all standard spacing sizes.
class GtGap extends StatelessWidget {
  /// The predefined size category for the gap.
  final _GtGapSize _size;

  /// The dimensional type of the gap (square, horizontal, or vertical).
  final GtGapType _type;

  /// Creates a square gap with extra small spacing.
  const GtGap.sXs({super.key})
    : _size = _GtGapSize.xs,
      _type = GtGapType.square;

  /// Creates a square gap with small spacing.
  const GtGap.sSm({super.key})
    : _size = _GtGapSize.sm,
      _type = GtGapType.square;

  /// Creates a square gap with base spacing.
  const GtGap.sBase({super.key})
    : _size = _GtGapSize.base,
      _type = GtGapType.square;

  /// Creates a square gap with medium spacing.
  const GtGap.sMd({super.key})
    : _size = _GtGapSize.md,
      _type = GtGapType.square;

  /// Creates a square gap with large spacing.
  const GtGap.sLg({super.key})
    : _size = _GtGapSize.lg,
      _type = GtGapType.square;

  /// Creates a square gap with extra large spacing.
  const GtGap.sXl({super.key})
    : _size = _GtGapSize.xl,
      _type = GtGapType.square;

  /// Creates a square gap with small section spacing.
  const GtGap.sSectionSm({super.key})
    : _size = _GtGapSize.sectionSm,
      _type = GtGapType.square;

  /// Creates a square gap with medium section spacing.
  const GtGap.sSectionMd({super.key})
    : _size = _GtGapSize.sectionMd,
      _type = GtGapType.square;

  /// Creates a square gap with large section spacing.
  const GtGap.sSectionLg({super.key})
    : _size = _GtGapSize.sectionLg,
      _type = GtGapType.square;

  /// Creates a square gap with extra large section spacing.
  const GtGap.sSectionXl({super.key})
    : _size = _GtGapSize.sectionXl,
      _type = GtGapType.square;

  /// Creates a square gap with 2x extra large section spacing.
  const GtGap.sSection2xl({super.key})
    : _size = _GtGapSize.section2xl,
      _type = GtGapType.square;

  /// Creates a square gap with 3x extra large section spacing.
  const GtGap.sSection3xl({super.key})
    : _size = _GtGapSize.section3xl,
      _type = GtGapType.square;

  /// Creates a square gap with 4x extra large section spacing.
  const GtGap.sSection4xl({super.key})
    : _size = _GtGapSize.section4xl,
      _type = GtGapType.square;

  /// Creates a vertical gap with extra small spacing.
  const GtGap.yXs({super.key})
    : _size = _GtGapSize.xs,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with small spacing.
  const GtGap.ySm({super.key})
    : _size = _GtGapSize.sm,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with base spacing.
  const GtGap.yBase({super.key})
    : _size = _GtGapSize.base,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with medium spacing.
  const GtGap.yMd({super.key})
    : _size = _GtGapSize.md,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with large spacing.
  const GtGap.yLg({super.key})
    : _size = _GtGapSize.lg,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with extra large spacing.
  const GtGap.yXl({super.key})
    : _size = _GtGapSize.xl,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with small section spacing.
  const GtGap.ySectionSm({super.key})
    : _size = _GtGapSize.sectionSm,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with medium section spacing.
  const GtGap.ySectionMd({super.key})
    : _size = _GtGapSize.sectionMd,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with large section spacing.
  const GtGap.ySectionLg({super.key})
    : _size = _GtGapSize.sectionLg,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with extra large section spacing.
  const GtGap.ySectionXl({super.key})
    : _size = _GtGapSize.sectionXl,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with 2x extra large section spacing.
  const GtGap.ySection2xl({super.key})
    : _size = _GtGapSize.section2xl,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with 3x extra large section spacing.
  const GtGap.ySection3xl({super.key})
    : _size = _GtGapSize.section3xl,
      _type = GtGapType.vertical;

  /// Creates a vertical gap with 4x extra large section spacing.
  const GtGap.ySection4xl({super.key})
    : _size = _GtGapSize.section4xl,
      _type = GtGapType.vertical;

  /// Creates a horizontal gap with extra small spacing.
  const GtGap.hXs({super.key})
    : _size = _GtGapSize.xs,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with small spacing.
  const GtGap.hSm({super.key})
    : _size = _GtGapSize.sm,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with base spacing.
  const GtGap.hBase({super.key})
    : _size = _GtGapSize.base,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with medium spacing.
  const GtGap.hMd({super.key})
    : _size = _GtGapSize.md,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with large spacing.
  const GtGap.hLg({super.key})
    : _size = _GtGapSize.lg,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with extra large spacing.
  const GtGap.hXl({super.key})
    : _size = _GtGapSize.xl,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with small section spacing.
  const GtGap.hSectionSm({super.key})
    : _size = _GtGapSize.sectionSm,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with medium section spacing.
  const GtGap.hSectionMd({super.key})
    : _size = _GtGapSize.sectionMd,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with large section spacing.
  const GtGap.hSectionLg({super.key})
    : _size = _GtGapSize.sectionLg,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with extra large section spacing.
  const GtGap.hSectionXl({super.key})
    : _size = _GtGapSize.sectionXl,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with 2x extra large section spacing.
  const GtGap.hSection2xl({super.key})
    : _size = _GtGapSize.section2xl,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with 3x extra large section spacing.
  const GtGap.hSection3xl({super.key})
    : _size = _GtGapSize.section3xl,
      _type = GtGapType.horizontal;

  /// Creates a horizontal gap with 4x extra large section spacing.
  const GtGap.hSection4xl({super.key})
    : _size = _GtGapSize.section4xl,
      _type = GtGapType.horizontal;

  /// Resolves the raw logical pixel value for the gap based on the
  /// selected [_size] and the current [context]'s spacing theme.
  double getGap(BuildContext context) {
    return switch (_size) {
      _GtGapSize.xs => context.spacing.xs,
      _GtGapSize.sm => context.spacing.sm,
      _GtGapSize.base => context.spacing.base,
      _GtGapSize.md => context.spacing.md,
      _GtGapSize.lg => context.spacing.lg,
      _GtGapSize.xl => context.spacing.xl,
      _GtGapSize.sectionSm => context.spacing.sectionSm,
      _GtGapSize.sectionMd => context.spacing.sectionMd,
      _GtGapSize.sectionLg => context.spacing.sectionLg,
      _GtGapSize.sectionXl => context.spacing.sectionXl,
      _GtGapSize.section2xl => context.spacing.section2xl,
      _GtGapSize.section3xl => context.spacing.section3xl,
      _GtGapSize.section4xl => context.spacing.section4xl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final computedGap = getGap(context);
    final gap = context.dp(computedGap.px);

    return switch (_type) {
      GtGapType.square => SizedBox.square(dimension: gap),
      GtGapType.horizontal => SizedBox(width: gap),
      GtGapType.vertical => SizedBox(height: gap),
    };
  }
}
