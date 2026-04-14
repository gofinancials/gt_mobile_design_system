import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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

enum GtGapType { square, vertical, horizontal }

class GtGap extends StatelessWidget {
  final _GtGapSize _size;
  final GtGapType _type;

  const GtGap.sXs({super.key})
      : _size = _GtGapSize.xs,
        _type = GtGapType.square;
  const GtGap.sSm({super.key})
      : _size = _GtGapSize.sm,
        _type = GtGapType.square;
  const GtGap.sBase({super.key})
      : _size = _GtGapSize.base,
        _type = GtGapType.square;
  const GtGap.sMd({super.key})
      : _size = _GtGapSize.md,
        _type = GtGapType.square;
  const GtGap.sLg({super.key})
      : _size = _GtGapSize.lg,
        _type = GtGapType.square;
  const GtGap.sXl({super.key})
      : _size = _GtGapSize.xl,
        _type = GtGapType.square;
  const GtGap.sSectionSm({super.key})
      : _size = _GtGapSize.sectionSm,
        _type = GtGapType.square;
  const GtGap.sSectionMd({super.key})
      : _size = _GtGapSize.sectionMd,
        _type = GtGapType.square;
  const GtGap.sSectionLg({super.key})
      : _size = _GtGapSize.sectionLg,
        _type = GtGapType.square;
  const GtGap.sSectionXl({super.key})
      : _size = _GtGapSize.sectionXl,
        _type = GtGapType.square;
  const GtGap.sSection2xl({super.key})
      : _size = _GtGapSize.section2xl,
        _type = GtGapType.square;
  const GtGap.sSection3xl({super.key})
      : _size = _GtGapSize.section3xl,
        _type = GtGapType.square;
  const GtGap.sSection4xl({super.key})
      : _size = _GtGapSize.section4xl,
        _type = GtGapType.square;

  const GtGap.yXs({super.key})
      : _size = _GtGapSize.xs,
        _type = GtGapType.vertical;
  const GtGap.ySm({super.key})
      : _size = _GtGapSize.sm,
        _type = GtGapType.vertical;
  const GtGap.yBase({super.key})
      : _size = _GtGapSize.base,
        _type = GtGapType.vertical;
  const GtGap.yMd({super.key})
      : _size = _GtGapSize.md,
        _type = GtGapType.vertical;
  const GtGap.yLg({super.key})
      : _size = _GtGapSize.lg,
        _type = GtGapType.vertical;
  const GtGap.yXl({super.key})
      : _size = _GtGapSize.xl,
        _type = GtGapType.vertical;
  const GtGap.ySectionSm({super.key})
      : _size = _GtGapSize.sectionSm,
        _type = GtGapType.vertical;
  const GtGap.ySectionMd({super.key})
      : _size = _GtGapSize.sectionMd,
        _type = GtGapType.vertical;
  const GtGap.ySectionLg({super.key})
      : _size = _GtGapSize.sectionLg,
        _type = GtGapType.vertical;
  const GtGap.ySectionXl({super.key})
      : _size = _GtGapSize.sectionXl,
        _type = GtGapType.vertical;
  const GtGap.ySection2xl({super.key})
      : _size = _GtGapSize.section2xl,
        _type = GtGapType.vertical;
  const GtGap.ySection3xl({super.key})
      : _size = _GtGapSize.section3xl,
        _type = GtGapType.vertical;
  const GtGap.ySection4xl({super.key})
      : _size = _GtGapSize.section4xl,
        _type = GtGapType.vertical;

  const GtGap.hXs({super.key})
      : _size = _GtGapSize.xs,
        _type = GtGapType.horizontal;
  const GtGap.hSm({super.key})
      : _size = _GtGapSize.sm,
        _type = GtGapType.horizontal;
  const GtGap.hBase({super.key})
      : _size = _GtGapSize.base,
        _type = GtGapType.horizontal;
  const GtGap.hMd({super.key})
      : _size = _GtGapSize.md,
        _type = GtGapType.horizontal;
  const GtGap.hLg({super.key})
      : _size = _GtGapSize.lg,
        _type = GtGapType.horizontal;
  const GtGap.hXl({super.key})
      : _size = _GtGapSize.xl,
        _type = GtGapType.horizontal;
  const GtGap.hSectionSm({super.key})
      : _size = _GtGapSize.sectionSm,
        _type = GtGapType.horizontal;
  const GtGap.hSectionMd({super.key})
      : _size = _GtGapSize.sectionMd,
        _type = GtGapType.horizontal;
  const GtGap.hSectionLg({super.key})
      : _size = _GtGapSize.sectionLg,
        _type = GtGapType.horizontal;
  const GtGap.hSectionXl({super.key})
      : _size = _GtGapSize.sectionXl,
        _type = GtGapType.horizontal;
  const GtGap.hSection2xl({super.key})
      : _size = _GtGapSize.section2xl,
        _type = GtGapType.horizontal;
  const GtGap.hSection3xl({super.key})
      : _size = _GtGapSize.section3xl,
        _type = GtGapType.horizontal;
  const GtGap.hSection4xl({super.key})
      : _size = _GtGapSize.section4xl,
        _type = GtGapType.horizontal;

  double _computedGap(BuildContext context) {
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
    final computedGap = _computedGap(context);
    final gap = context.dp(computedGap.px);

    return switch (_type) {
      GtGapType.square => SizedBox.square(dimension: gap),
      GtGapType.horizontal => SizedBox(width: gap),
      GtGapType.vertical => SizedBox(height: gap),
    };
  }
}
