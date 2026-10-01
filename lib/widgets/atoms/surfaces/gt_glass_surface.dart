import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A raised-glass surface: a frosted backdrop clipped to [shape], with a light
/// rim along the upper-left and lower-right edges.
///
/// Approximates Figma's Liquid Glass effect at a light angle of -45°. The
/// surface draws no fill of its own, so [child] supplies the tint; the rim is
/// painted over [child] by [GtGlassRimPainter] so an opaque fill can't hide it.
class GtGlassSurface extends GtStatelessWidget {
  /// The outline that clips the frost and carries the rim.
  final ShapeBorder shape;

  /// The content painted on the glass, typically a filled button.
  final Widget child;

  /// Creates a [GtGlassSurface].
  const GtGlassSurface({required this.shape, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context);

    return ClipPath(
      clipper: ShapeBorderClipper(shape: shape, textDirection: textDirection),
      child: BackdropFilter(
        filter: context.backdropFilters.glassFrost(),
        child: CustomPaint(
          foregroundPainter: GtGlassRimPainter(
            shape: shape,
            color: context.palette.staticColors.white,
            strokeWidth: context.dp(1.px),
            textDirection: textDirection,
          ),
          child: child,
        ),
      ),
    );
  }
}
