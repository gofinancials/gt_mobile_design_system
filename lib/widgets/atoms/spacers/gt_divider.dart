import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the predefined vertical spacing sizes for a [GtDivider].
enum GtDividerSize {
  /// No vertical spacing.
  none,

  /// Extra small vertical spacing.
  xs,

  /// Small vertical spacing.
  sm,

  /// Base vertical spacing.
  base,

  /// Medium vertical spacing.
  md,

  /// Large vertical spacing.
  lg,

  /// Extra large vertical spacing.
  xl,

  /// Small section vertical spacing.
  sectionSm,

  /// Medium section vertical spacing.
  sectionMd,

  /// Large section vertical spacing.
  sectionLg,

  /// Extra large section vertical spacing.
  sectionXl,

  /// 2x extra large section vertical spacing.
  section2Xl,

  /// 3x extra large section vertical spacing.
  section3Xl,

  /// 4x extra large section vertical spacing.
  section4Xl,
}

/// A horizontal divider line with standardized vertical spacing.
///
/// This widget creates a standard Flutter [Divider] but ensures its total height
/// (vertical bounds) conforms to the design system's predefined spacing scale.
class GtDivider extends StatelessWidget {
  /// The predefined size category that dictates the divider's total height.
  final GtDividerSize _size;

  /// The color of the divider line.
  ///
  /// If null, it defaults to the [ThemeData.dividerColor] of the current context.
  final Color? color;

  /// Creates a [GtDivider] with no vertical spacing.
  const GtDivider.none({this.color, super.key}) : _size = GtDividerSize.none;

  /// Creates a [GtDivider] with extra small vertical spacing.
  const GtDivider.xs({this.color, super.key}) : _size = GtDividerSize.xs;

  /// Creates a [GtDivider] with small vertical spacing.
  const GtDivider.sm({this.color, super.key}) : _size = GtDividerSize.sm;

  /// Creates a [GtDivider] with base vertical spacing.
  const GtDivider.base({this.color, super.key}) : _size = GtDividerSize.base;

  /// Creates a [GtDivider] with medium vertical spacing.
  const GtDivider.md({this.color, super.key}) : _size = GtDividerSize.md;

  /// Creates a [GtDivider] with large vertical spacing.
  const GtDivider.lg({this.color, super.key}) : _size = GtDividerSize.lg;

  /// Creates a [GtDivider] with extra large vertical spacing.
  const GtDivider.xl({this.color, super.key}) : _size = GtDividerSize.xl;

  /// Creates a [GtDivider] with small section vertical spacing.
  const GtDivider.sectionSm({this.color, super.key})
    : _size = GtDividerSize.sectionSm;

  /// Creates a [GtDivider] with medium section vertical spacing.
  const GtDivider.sectionMd({this.color, super.key})
    : _size = GtDividerSize.sectionMd;

  /// Creates a [GtDivider] with large section vertical spacing.
  const GtDivider.sectionLg({this.color, super.key})
    : _size = GtDividerSize.sectionLg;

  /// Creates a [GtDivider] with extra large section vertical spacing.
  const GtDivider.sectionXl({this.color, super.key})
    : _size = GtDividerSize.sectionXl;

  /// Creates a [GtDivider] with 2x extra large section vertical spacing.
  const GtDivider.section2Xl({this.color, super.key})
    : _size = GtDividerSize.section2Xl;

  /// Creates a [GtDivider] with 3x extra large section vertical spacing.
  const GtDivider.section3Xl({this.color, super.key})
    : _size = GtDividerSize.section3Xl;

  /// Creates a [GtDivider] with 4x extra large section vertical spacing.
  const GtDivider.section4Xl({this.color, super.key})
    : _size = GtDividerSize.section4Xl;

  /// Resolves the raw logical pixel height for the divider based on the
  /// selected [_size] and the current [context]'s spacing theme.
  double getDividerSize(BuildContext context) {
    return switch (_size) {
      GtDividerSize.none => 0,
      GtDividerSize.xs => context.spacing.xs,
      GtDividerSize.sm => context.spacing.sm,
      GtDividerSize.base => context.spacing.base,
      GtDividerSize.md => context.spacing.md,
      GtDividerSize.lg => context.spacing.lg,
      GtDividerSize.xl => context.spacing.xl,
      GtDividerSize.sectionSm => context.spacing.sectionSm,
      GtDividerSize.sectionMd => context.spacing.sectionMd,
      GtDividerSize.sectionLg => context.spacing.sectionLg,
      GtDividerSize.sectionXl => context.spacing.sectionXl,
      GtDividerSize.section2Xl => context.spacing.section2xl,
      GtDividerSize.section3Xl => context.spacing.section3xl,
      GtDividerSize.section4Xl => context.spacing.section4xl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = getDividerSize(context);
    return Divider(
      height: context.dp(size.px),
      thickness: 1,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}
