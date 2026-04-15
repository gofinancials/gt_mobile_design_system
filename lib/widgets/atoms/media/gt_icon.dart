import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtIcon extends GtStatelessWidget {
  final IconData icon;
  final double? size;
  final List<Shadow>? shadows;
  final AlignmentGeometry? alignment;
  final String? semanticsLabel;
  final GtIconVariant _variant;
  final Color? _color;

  const GtIcon(
    this.icon, {
    super.key,
    this.size,
    this.shadows,
    this.alignment,
    GtIconVariant variant = GtIconVariant.strong,
    this.semanticsLabel,
  }) : _color = null,
       _variant = variant;

  const GtIcon.withColor(
    this.icon, {
    super.key,
    this.size,
    this.shadows,
    this.alignment,
    Color? color,
    this.semanticsLabel,
  }) : _variant = GtIconVariant.strong,
       _color = color;

  @override
  Widget build(BuildContext context) {
    Color? iconColor = _color ?? _variant.getIconColor(context);
    final iconSize = context.dp(20.px);

    Widget child = Icon(
      icon,
      size: iconSize,
      color: iconColor,
      semanticLabel: semanticsLabel,
      shadows: shadows,
    );
    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }
    return child;
  }
}
