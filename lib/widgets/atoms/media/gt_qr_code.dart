import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A scannable QR code painted from a string of [data].
///
/// Encodes [data] with the same `barcode` package and settings the PDF
/// documents use, so a screen and a [GtPdfReceiptFooter.qrData] fed the same
/// string show the same code.
///
/// The code is painted dark on light by default, whatever the theme. Many
/// scanners cannot read an inverted code, and in a dark theme the surface
/// behind this widget is dark, so the light [backgroundColor] is painted
/// across the whole square, [quietZone] included, to give a scanner the
/// border it locks onto.
///
/// [data] must fit in a QR code. The `barcode` package throws a
/// `BarcodeException` from [build] when it does not, as it does from the PDF
/// builders.
///
/// Inside an enabled [GtSkeleton] it is painted as a [GtBone] block.
///
/// Example usage:
/// ```dart
/// GtQrCode(
///   "TRX24072983910527NGN",
///   size: 36,
///   semanticsLabel: "Receipt QR code",
/// )
/// ```
class GtQrCode extends GtStatelessWidget {
  /// The payload encoded into the code.
  final String data;

  /// The side length of the square, quiet zone included. Defaults to 36dp.
  final double? size;

  /// The color of the dark modules. Defaults to the palette's static black.
  final Color? foregroundColor;

  /// The color of the light modules and the quiet zone. Defaults to the
  /// palette's static white.
  final Color? backgroundColor;

  /// The width of the light border around the code, in modules.
  ///
  /// The QR specification asks for four. The default of two keeps the code
  /// legible at the small sizes it is usually drawn at.
  final int quietZone;

  /// A description of what this code links to, for screen readers.
  ///
  /// When both this and [isDecorative] are omitted the code is excluded from
  /// the semantics tree.
  final String? semanticsLabel;

  /// Whether this code is purely decorative.
  ///
  /// Decorative codes are excluded from the semantics tree.
  final bool isDecorative;

  /// Creates a [GtQrCode] that encodes [data].
  const GtQrCode(
    this.data, {
    super.key,
    this.size,
    this.foregroundColor,
    this.backgroundColor,
    this.quietZone = 2,
    this.semanticsLabel,
    this.isDecorative = false,
  }) : assert(quietZone >= 0, 'quietZone must not be negative');

  @override
  Widget build(BuildContext context) {
    final side = size ?? context.dp(36.px);

    // Encoded here rather than in paint, so a payload that does not fit throws
    // once from build, and repaints such as a skeleton's shimmer do not encode
    // it again on every frame. Laid out in a unit square, so a bar's height is
    // one module.
    final bars = Barcode.qrCode()
        .make(data, width: 1, height: 1)
        .whereType<BarcodeBar>()
        .toList();

    Widget code = CustomPaint(
      size: Size.square(side),
      painter: _QrPainter(
        data: data,
        bars: bars,
        quietZone: quietZone,
        foregroundColor: foregroundColor ?? context.palette.staticColors.black,
        backgroundColor: backgroundColor ?? context.palette.staticColors.white,
      ),
    );
    if (context.inSkeleton) {
      code = GtBone(child: code);
    }

    if (isDecorative || semanticsLabel == null) {
      return ExcludeSemantics(child: code);
    }
    return Semantics(image: true, label: semanticsLabel, child: code);
  }
}

/// Paints the modules of a QR code over a light square.
class _QrPainter extends CustomPainter {
  /// The payload encoded into the code, compared to decide on a repaint.
  final String data;

  /// The rows of [data]'s modules, laid out in a unit square.
  final List<BarcodeBar> bars;

  /// The width of the light border around the code, in modules.
  final int quietZone;

  /// The color of the dark modules.
  final Color foregroundColor;

  /// The color of the light modules and the quiet zone.
  final Color backgroundColor;

  /// Creates a [_QrPainter].
  _QrPainter({
    required this.data,
    required this.bars,
    required this.quietZone,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);
    if (bars.isEmpty) return;

    // A bar is one module tall in a unit square, so the code's width in
    // modules is the reciprocal of its height.
    final modules = 1 / bars.first.height;
    final side = size.shortestSide;
    final module = side / (modules + quietZone * 2);
    final scale = module * modules;
    final origin = Offset((size.width - scale) / 2, (size.height - scale) / 2);

    // One path filled without anti-aliasing, so neighbouring modules meet
    // without the hairline seams that blending their edges would leave.
    final path = Path();
    for (final bar in bars) {
      if (!bar.black) continue;
      path.addRect(
        Rect.fromLTWH(
          origin.dx + bar.left * scale,
          origin.dy + bar.top * scale,
          bar.width * scale,
          bar.height * scale,
        ),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = foregroundColor
        ..isAntiAlias = false,
    );
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.quietZone != quietZone ||
      oldDelegate.foregroundColor != foregroundColor ||
      oldDelegate.backgroundColor != backgroundColor;
}
