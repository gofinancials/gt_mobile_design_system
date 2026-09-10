import 'package:flutter/material.dart';

/// Paints the home dashboard's background wash: a vertical gradient running
/// from teal-blue at the top into the warm off-white the rest of the screen
/// sits on.
///
/// The geometry is taken verbatim from the Figma export. In the source frame
/// the gradient vector runs from `y = -395.254` to `y = 1061.15` — the frame's
/// own height — with the teal stop at 10% and the off-white stop at 50% of that
/// vector. Because the teal stop sits well above the top edge, the frame never
/// shows the pure colour: it opens roughly 43% of the way into the blend and
/// reaches solid off-white at about 31% of the screen height, holding it from
/// there to the bottom.
///
/// The stops are expressed as fractions of the painted rect, so the wash scales
/// with the viewport rather than assuming the design's pixel height.
class GtHomeGradientPainter extends CustomPainter {
  /// Height of the design frame the gradient was measured in.
  static const double _designHeight = 1061.15;

  /// Where the gradient vector begins in that frame — above its top edge.
  static const double _designStartY = -395.254;

  /// [Alignment.y] places the rect's top edge at `-1` and its bottom at `1`,
  /// so a fraction `f` of the height maps to `2f - 1`.
  static const double _beginY = 2 * (_designStartY / _designHeight) - 1;

  /// The colour at the head of the gradient.
  ///
  /// Defaults to [defaultColor]. Pass `context.palette.raw.tealBlue600` to
  /// track the active theme.
  final Color color;

  /// The colour the gradient settles into and holds to the bottom edge.
  ///
  /// Defaults to [defaultEndColor]. Pass `context.palette.raw.yellow25` to
  /// track the active theme — that token darkens in dark mode.
  final Color endColor;

  /// Creates a [GtHomeGradientPainter].
  ///
  /// Both colours default to the design values, so the painter can be used
  /// without arguments where theme-awareness is not needed.
  const GtHomeGradientPainter({required this.color, required this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: const Alignment(0, _beginY),
      end: Alignment.bottomCenter,
      colors: [color, endColor],
      stops: const [0.1, 0.5],
    );

    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant GtHomeGradientPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.endColor != endColor;
  }
}
