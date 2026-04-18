import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

enum CornerStyle { continous, rounded }

enum GtCardVariant {
  normal,
  featured,
  info,
  success,
  warning,
  error,
  highlighted,
  stable,
  verified,
  away,
}

class GtCard extends GtStatelessWidget {
  final Color? color;
  final Widget child;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final CornerStyle cornerStyle;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final BorderSide? border;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final DecorationImage? image;
  final GtCardVariant variant;

  const GtCard({
    this.color,
    this.padding,
    this.margin,
    this.borderRadius,
    this.constraints,
    this.shadows,
    this.image,
    this.cornerStyle = CornerStyle.rounded,
    this.border,
    this.gradient,
    this.variant = GtCardVariant.normal,
    super.key,
    required this.child,
  });

  Color _getVariantColor(GtPalette palette) {
    if (color != null) return color!;
    return switch (variant) {
      .away => palette.away.lighter,
      .error => palette.error.lighter,
      .featured => palette.feature.lighter,
      .highlighted => palette.highlighted.lighter,
      .info => palette.information.lighter,
      .stable => palette.stable.lighter,
      .success => palette.success.lighter,
      .verified => palette.success.lighter,
      .warning => palette.warning.lighter,
      _ => palette.bg.weak,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final computedColor = _getVariantColor(palette);

    final shape = switch (cornerStyle) {
      CornerStyle.continous => ContinuousRectangleBorder(
        borderRadius: borderRadius ?? context.borderRadius2Xl,
      ),
      _ => RoundedRectangleBorder(
        borderRadius: borderRadius ?? context.borderRadius2Xl,
      ),
    };
    return AnimatedContainer(
      constraints: constraints,
      decoration: ShapeDecoration(
        color: gradient == null ? computedColor : null,
        shadows: shadows,
        shape: shape,
        gradient: gradient,
        image: image,
      ),
      width: double.infinity,
      margin: margin,
      padding: padding ?? context.insets.defaultAllInsets,
      duration: 500.milliseconds,
      child: child,
    );
  }
}
