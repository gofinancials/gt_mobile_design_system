import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum _GtDividerSize { none, xs, sm, base, md, lg, xl }

class GtDivider extends StatelessWidget {
  final _GtDividerSize _size;
  final Color? color;

  const GtDivider.none({this.color, super.key}) : _size = _GtDividerSize.none;
  const GtDivider.xs({this.color, super.key}) : _size = _GtDividerSize.xs;
  const GtDivider.sm({this.color, super.key}) : _size = _GtDividerSize.sm;
  const GtDivider.base({this.color, super.key}) : _size = _GtDividerSize.base;
  const GtDivider.md({this.color, super.key}) : _size = _GtDividerSize.md;
  const GtDivider.lg({this.color, super.key}) : _size = _GtDividerSize.lg;
  const GtDivider.xl({this.color, super.key}) : _size = _GtDividerSize.xl;

  double _getDividerSize(BuildContext context) {
    return switch (_size) {
      _GtDividerSize.none => 0,
      _GtDividerSize.xs => context.spacing.xs,
      _GtDividerSize.sm => context.spacing.sm,
      _GtDividerSize.base => context.spacing.base,
      _GtDividerSize.md => context.spacing.md,
      _GtDividerSize.lg => context.spacing.lg,
      _GtDividerSize.xl => context.spacing.xl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = _getDividerSize(context);
    return Divider(
      height: context.dp(size.px),
      thickness: 1,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}
