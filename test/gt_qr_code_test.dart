import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  const data = 'TRX24072983910527NGN';
  const quietZone = 2;
  const pixelsPerModule = 4;

  Widget buildTestWidget(Widget child, {ThemeMode themeMode = .light}) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: kPersonalTheme.materialLight,
        darkTheme: kPersonalTheme.materialDark,
        themeMode: themeMode,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  /// The dark modules of [data] as the PDF builders encode it, indexed
  /// `[row][column]`.
  List<List<bool>> expectedModules(String data) {
    final bars = Barcode.qrCode()
        .make(data, width: 1, height: 1)
        .whereType<BarcodeBar>()
        .toList();
    final modules = (1 / bars.first.height).round();
    final grid = List.generate(modules, (_) => List.filled(modules, false));
    for (final bar in bars.where((bar) => bar.black)) {
      final row = (bar.top * modules).round();
      final start = (bar.left * modules).round();
      final end = ((bar.left + bar.width) * modules).round();
      for (var column = start; column < end; column++) {
        grid[row][column] = true;
      }
    }
    return grid;
  }

  /// Renders the [GtQrCode] under [key] and returns its RGBA pixels.
  Future<(ByteData, int)> capture(WidgetTester tester, Key key) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(key),
    );
    final image = (await tester.runAsync(boundary.toImage))!;
    final bytes = (await tester.runAsync(
      () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
    ))!;
    return (bytes, image.width);
  }

  /// The luminance, from 0 to 255, of the pixel at ([x], [y]).
  int luminanceAt(ByteData bytes, int width, int x, int y) {
    final offset = (y * width + x) * 4;
    final r = bytes.getUint8(offset);
    final g = bytes.getUint8(offset + 1);
    final b = bytes.getUint8(offset + 2);
    return (r + g + b) ~/ 3;
  }

  for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets(
      'paints the same modules the PDF encodes, dark on light, in ${themeMode.name} mode',
      (tester) async {
        final grid = expectedModules(data);
        final side = (grid.length + quietZone * 2) * pixelsPerModule;
        const key = Key('qr-boundary');

        await tester.pumpWidget(
          buildTestWidget(
            RepaintBoundary(
              key: key,
              child: GtQrCode(
                data,
                size: side.toDouble(),
                quietZone: quietZone,
                isDecorative: true,
              ),
            ),
            themeMode: themeMode,
          ),
        );

        final (bytes, width) = await capture(tester, key);
        // The test view renders at a device pixel ratio, so modules span more
        // than one physical pixel each.
        final ratio = width / side;

        int sample(int column, int row) => luminanceAt(
          bytes,
          width,
          ((column + 0.5) * pixelsPerModule * ratio).floor(),
          ((row + 0.5) * pixelsPerModule * ratio).floor(),
        );

        // The quiet zone stays light whatever surface sits behind it.
        expect(sample(0, 0), greaterThan(200));
        expect(
          sample(quietZone - 1, grid.length + quietZone),
          greaterThan(200),
        );

        for (var row = 0; row < grid.length; row++) {
          for (var column = 0; column < grid.length; column++) {
            final luminance = sample(column + quietZone, row + quietZone);
            expect(
              grid[row][column] ? luminance < 55 : luminance > 200,
              isTrue,
              reason:
                  'module ($column, $row) should be '
                  '${grid[row][column] ? 'dark' : 'light'}, was $luminance',
            );
          }
        }
      },
    );
  }

  testWidgets('labels the code for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      buildTestWidget(const GtQrCode(data, semanticsLabel: 'Receipt QR code')),
    );

    expect(
      tester.getSemantics(find.byType(GtQrCode)),
      matchesSemantics(label: 'Receipt QR code', isImage: true),
    );
    handle.dispose();
  });

  testWidgets('keeps a decorative code out of the semantics tree', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      buildTestWidget(const GtQrCode(data, isDecorative: true)),
    );

    expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
    handle.dispose();
  });

  testWidgets('is painted as a bone inside a skeleton', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        const GtSkeleton(child: GtQrCode(data, isDecorative: true)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(
      find.ancestor(
        of: find.byType(CustomPaint),
        matching: find.byType(GtBone),
      ),
      findsWidgets,
    );
  });
}
