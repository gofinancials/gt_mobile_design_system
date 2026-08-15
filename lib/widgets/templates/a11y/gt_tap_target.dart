import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Expands the touch-responsive area of [child] without changing layout.
///
/// Both iOS and Android ask for a minimum touch target of roughly 44 to 48
/// logical pixels, but several design-system controls are deliberately drawn
/// smaller than that (a checkbox is 20dp, a pill button is 24dp tall). Growing
/// them visually would reshape every screen that uses them, so this widget
/// instead keeps the painted size untouched and widens only the region that
/// responds to touch.
///
/// The child keeps its own size for layout and painting; hits landing in the
/// surrounding slop are forwarded to the child's centre.
///
/// ## Limitation
///
/// Hit testing can only reach this widget for positions its **parent** also
/// considers a hit. Expanding a 20dp checkbox to 44dp therefore has no effect
/// if the checkbox is wrapped in a box that is itself exactly 20dp — the
/// parent rejects the pointer before this widget is consulted. Place
/// [GtTapTarget] where the surrounding layout has room to give, such as inside
/// a padded list row. This is inherent to non-layout-affecting hit slop; the
/// alternative is [MaterialTapTargetSize.padded], which does reflow the
/// surrounding layout.
///
/// Adjacent expanded targets can also overlap, in which case the first one
/// visited during hit testing wins. Keep spacing between small controls at or
/// above [minSize] where taps must stay unambiguous.
class GtTapTarget extends SingleChildRenderObjectWidget {
  /// The platform-recommended minimum interactive dimension.
  static const Size defaultMinSize = Size(44, 44);

  /// The minimum size of the touch-responsive region.
  ///
  /// Defaults to [defaultMinSize]. The child is never made smaller than it
  /// already is; this only ever grows the responsive area.
  final Size minSize;

  /// Creates a [GtTapTarget] around [child].
  const GtTapTarget({
    required Widget super.child,
    this.minSize = defaultMinSize,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GtRenderTapTarget(minSize: minSize);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant GtRenderTapTarget renderObject,
  ) {
    renderObject.minSize = minSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
  }
}

/// The render object backing [GtTapTarget].
///
/// This is a proxy box: it reports the child's own size to the layout system
/// and only overrides hit testing.
class GtRenderTapTarget extends RenderProxyBox {
  Size _minSize;

  /// Creates a [GtRenderTapTarget].
  GtRenderTapTarget({required Size minSize, RenderBox? child})
    : _minSize = minSize,
      super(child);

  /// The minimum size of the touch-responsive region.
  Size get minSize => _minSize;

  set minSize(Size value) {
    if (_minSize == value) return;
    _minSize = value;
  }

  /// The region that responds to touch, centred on the painted bounds.
  Rect get hitRect {
    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: math.max(size.width, _minSize.width),
      height: math.max(size.height, _minSize.height),
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Positions inside the painted bounds take the ordinary path so that the
    // child's own hit-test geometry (custom borders, circular shapes) still
    // decides the outcome.
    if (super.hitTest(result, position: position)) return true;

    final child = this.child;
    if (child == null || !hitRect.contains(position)) return false;

    // The pointer landed in the slop. Forward it to the child's centre, which
    // is guaranteed to be inside whatever shape the child hit-tests against.
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == center);
        return child.hitTest(result, position: center);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('minSize', minSize));
  }
}
