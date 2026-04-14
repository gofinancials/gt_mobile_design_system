import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtDividerSize {
  none,
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
  section2Xl,
  section3Xl,
  section4Xl
}

class GtDivider extends StatelessWidget {
  final GtDividerSize _size;
  final Color? color;

  const GtDivider.none({this.color, super.key}) : _size = GtDividerSize.none;
  const GtDivider.xs({this.color, super.key}) : _size = GtDividerSize.xs;
  const GtDivider.sm({this.color, super.key}) : _size = GtDividerSize.sm;
  const GtDivider.base({this.color, super.key}) : _size = GtDividerSize.base;
  const GtDivider.md({this.color, super.key}) : _size = GtDividerSize.md;
  const GtDivider.lg({this.color, super.key}) : _size = GtDividerSize.lg;
  const GtDivider.xl({this.color, super.key}) : _size = GtDividerSize.xl;
  const GtDivider.sectionSm({this.color, super.key})
      : _size = GtDividerSize.sectionSm;
  const GtDivider.sectionMd({this.color, super.key})
      : _size = GtDividerSize.sectionMd;
  const GtDivider.sectionLg({this.color, super.key})
      : _size = GtDividerSize.sectionLg;
  const GtDivider.sectionXl({this.color, super.key})
      : _size = GtDividerSize.sectionXl;
  const GtDivider.section2Xl({this.color, super.key})
      : _size = GtDividerSize.section2Xl;
  const GtDivider.section3Xl({this.color, super.key})
      : _size = GtDividerSize.section3Xl;
  const GtDivider.section4Xl({this.color, super.key})
      : _size = GtDividerSize.section4Xl;

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
