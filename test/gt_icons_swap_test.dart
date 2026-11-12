import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Loads the real icon font, so glyphs draw as they do in the app rather than
/// as the test font's boxes.
Future<void> _loadIconFont() async {
  final loader = FontLoader('packages/gt_mobile_ui/${GtFonts.icon}');
  final bytes = File('assets/fonts/GtIconFont.otf').readAsBytesSync();
  loader.addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}

void main() {
  const boundaryKey = Key('icon');

  /// Draws [icon] at 24 dp through an [IconTheme] in [color], and hands back
  /// the colour and coverage of every pixel it painted.
  Future<List<Color>> paint(
    WidgetTester tester,
    IconData icon,
    Color color,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: IconTheme(
              data: IconThemeData(color: color, size: 24),
              child: Icon(icon),
            ),
          ),
        ),
      ),
    );

    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(boundaryKey),
    );
    final pixels = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 4);
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return data!;
    });

    return [
      for (var i = 0; i < pixels!.lengthInBytes; i += 4)
        if (pixels.getUint8(i + 3) > 0)
          Color.fromARGB(
            pixels.getUint8(i + 3),
            pixels.getUint8(i),
            pixels.getUint8(i + 1),
            pixels.getUint8(i + 2),
          ),
    ];
  }

  testWidgets('swap is a 24 dp glyph of its own in the icon font', (
    tester,
  ) async {
    await tester.runAsync(_loadIconFont);

    expect(GtIcons.swap.fontFamily, GtFonts.icon);
    expect(GtIcons.all.map((e) => e.value), contains(GtIcons.swap));

    final swap = await paint(tester, GtIcons.swap, Colors.black);
    final transfer = await paint(tester, GtIcons.transfer, Colors.black);
    expect(swap, isNotEmpty);
    expect(swap.length, isNot(transfer.length));
    expect(tester.getSize(find.byType(Icon)), const Size.square(24));
  });

  testWidgets('swap takes the colour it is drawn in', (tester) async {
    await tester.runAsync(_loadIconFont);

    for (final color in [
      const Color(0xFFE53935),
      const Color(0xFF1E88E5),
      Colors.white,
    ]) {
      final painted = await paint(tester, GtIcons.swap, color);
      final solid = painted.where((pixel) => pixel.a == 1).toList();

      expect(solid, isNotEmpty);
      // Every fully covered pixel is the icon colour itself; nothing is baked
      // into the glyph.
      expect(solid.toSet(), {color});
    }
  });
}
