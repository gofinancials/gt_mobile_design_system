import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Decodes [png] and returns its size and RGBA pixels.
Future<(int, int, ByteData)> _decode(Uint8List png) async {
  final image = await decodeImageFromList(png);
  final pixels = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final result = (image.width, image.height, pixels!);
  image.dispose();
  return result;
}

/// The RGBA value of the pixel at ([x], [y]) in an image [width] wide.
int _pixel(ByteData pixels, int width, int x, int y) {
  return pixels.getUint32((y * width + x) * 4);
}

/// Draws a horizontal stroke from (40, 50) to (140, 50) on [controller].
void _drawLine(GtSignaturePadController controller) {
  controller.beginStroke(const Offset(40, 50));
  controller.appendPoint(const Offset(90, 50));
  controller.appendPoint(const Offset(140, 50));
  controller.endStroke();
}

class _SignaturePadTestApp extends GtStatelessWidget {
  final GtSignaturePadController controller;
  final bool isDark;
  final OnChanged<Uint8List?>? onChanged;
  final OnPressed onSecondaryAction;
  final OnPressed? onClear;

  const _SignaturePadTestApp({
    required this.controller,
    required this.onSecondaryAction,
    this.isDark = false,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: isDark
            ? kPersonalTheme.materialDark
            : kPersonalTheme.materialLight,
        home: Scaffold(
          body: Center(
            child: GtSignaturePad(
              controller: controller,
              title: 'Tap to draw your signature',
              subtitle: 'Use your finger or a stylus to sign here',
              onChanged: onChanged,
              onSecondaryAction: onSecondaryAction,
              secondaryActionSemanticLabel: 'Upload a signature instead',
              semanticsLabel: 'Signature drawing area',
              semanticsHint:
                  'Draw with a finger or stylus, or use the upload signature action.',
              undoSemanticLabel: 'Undo signature stroke',
              redoSemanticLabel: 'Redo signature stroke',
              clearSemanticLabel: 'Clear signature',
              onClear: onClear,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GtSignaturePadController', () {
    test('propagates strokes and maintains undo/redo history', () {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.beginStroke(const Offset(10, 12));
      controller.appendPoint(const Offset(18, 20));
      controller.endStroke();

      expect(controller.hasSignature, isTrue);
      expect(controller.canUndo, isTrue);
      expect(controller.canRedo, isFalse);
      expect(controller.value.strokes.single.points, hasLength(2));

      controller.undo();
      expect(controller.hasSignature, isFalse);
      expect(controller.canUndo, isFalse);
      expect(controller.canRedo, isTrue);

      controller.redo();
      expect(controller.hasSignature, isTrue);
      expect(controller.value.strokes.single.points.last, const Offset(18, 20));
      expect(notifications, greaterThan(0));
    });

    test('starting a new stroke discards redo history', () {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);

      controller.beginStroke(const Offset(1, 1));
      controller.endStroke();
      controller.undo();
      expect(controller.canRedo, isTrue);

      controller.beginStroke(const Offset(2, 2));

      expect(controller.canRedo, isFalse);
      expect(controller.value.strokes.single.points.single, const Offset(2, 2));
    });

    test('clear removes visible strokes and history', () {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);

      controller.beginStroke(const Offset(1, 1));
      controller.endStroke();
      controller.undo();
      controller.clear();

      expect(controller.hasSignature, isFalse);
      expect(controller.canUndo, isFalse);
      expect(controller.canRedo, isFalse);
      expect(controller.bytes, isNull);
      expect(controller.base64, isNull);
    });

    test('setImage imports image bytes and exposes base64 and bytes', () async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      final rawBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      controller.setImage(rawBytes);

      expect(controller.hasSignature, isTrue);
      expect(controller.isImage, isTrue);
      expect(controller.bytes, equals(rawBytes));
      expect(controller.base64, equals(base64Encode(rawBytes)));

      final freshBytes = await controller.toUint8List();
      expect(freshBytes, equals(rawBytes));
      final freshBase64 = await controller.toBase64();
      expect(freshBase64, equals(base64Encode(rawBytes)));

      controller.clear();
      expect(controller.hasSignature, isFalse);
      expect(controller.isImage, isFalse);
      expect(controller.bytes, isNull);
      expect(controller.base64, isNull);
    });

    test('exports black ink on white, cropped to the strokes', () async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      _drawLine(controller);

      final png = await controller.toUint8List(pixelRatio: 1);
      final (width, height, pixels) = await _decode(png!);

      const inset =
          GtSignaturePad.defaultStrokeWidth / 2 +
          GtSignatureExportOptions.defaultMargin;
      expect(width, (100 + 2 * inset).ceil());
      expect(height, (2 * inset).ceil());
      expect(_pixel(pixels, width, 0, 0), 0xFFFFFFFF);
      expect(_pixel(pixels, width, width ~/ 2, height ~/ 2), 0x000000FF);
      expect(controller.bytes, png);
    });

    test('fills every edge pixel at a fractional pixel ratio', () async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      controller.beginStroke(const Offset(40.3, 50.7));
      controller.appendPoint(const Offset(140.9, 61.2));
      controller.endStroke();

      final png = await controller.toUint8List(pixelRatio: 1.5);
      final (width, height, pixels) = await _decode(png!);

      expect(_pixel(pixels, width, width - 1, height - 1), 0xFFFFFFFF);
      expect(_pixel(pixels, width, width - 1, 0), 0xFFFFFFFF);
      expect(_pixel(pixels, width, 0, height - 1), 0xFFFFFFFF);
    });

    test('exports onto a transparent background when asked', () async {
      final controller = GtSignaturePadController(
        exportOptions: const GtSignatureExportOptions(backgroundColor: null),
      );
      addTearDown(controller.dispose);
      _drawLine(controller);

      final png = await controller.toUint8List(pixelRatio: 1);
      final (width, height, pixels) = await _decode(png!);

      expect(_pixel(pixels, width, 0, 0) & 0xFF, 0);
      expect(_pixel(pixels, width, width ~/ 2, height ~/ 2), 0x000000FF);
    });

    test('exports a single dot', () async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      controller.beginStroke(const Offset(10, 10));
      controller.endStroke();

      final png = await controller.toUint8List(pixelRatio: 1);
      final (width, height, pixels) = await _decode(png!);

      expect(width, greaterThan(0));
      // A 2px dot at 1x is anti-aliased, so it is grey rather than black.
      expect(
        _pixel(pixels, width, width ~/ 2, height ~/ 2) >> 24,
        lessThan(0x80),
      );
    });
  });

  group('GtSignaturePad', () {
    testWidgets('renders the mapped empty state and accessible upload action', (
      tester,
    ) async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      var uploadCalls = 0;
      final semantics = tester.ensureSemantics();

      try {
        await tester.pumpWidget(
          _SignaturePadTestApp(
            controller: controller,
            onSecondaryAction: () => uploadCalls++,
          ),
        );

        expect(find.text('Tap to draw your signature'), findsOneWidget);
        expect(
          find.text('Use your finger or a stylus to sign here'),
          findsOneWidget,
        );
        expect(find.byIcon(GtIcons.uploadFolder), findsOneWidget);
        expect(find.bySemanticsLabel('Signature drawing area'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Upload a signature instead'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Upload a signature instead'));
        await tester.pump();
        expect(uploadCalls, 1);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets(
      'exports a drawn signature in black on white whatever the theme',
      (tester) async {
        final controller = GtSignaturePadController();
        addTearDown(controller.dispose);
        final changes = <Uint8List?>[];

        await tester.pumpWidget(
          _SignaturePadTestApp(
            controller: controller,
            isDark: true,
            onChanged: changes.add,
            onSecondaryAction: () {},
          ),
        );

        final canvas = find.descendant(
          of: find.byType(GtSignaturePad),
          matching: find.byType(CustomPaint),
        );
        final rect = tester.getRect(canvas);
        final gesture = await tester.startGesture(
          Offset(rect.left + 60, rect.center.dy),
        );
        await gesture.moveBy(const Offset(50, 0));
        await gesture.moveBy(const Offset(50, 0));
        await gesture.up();
        await tester.pump();

        expect(controller.hasSignature, isTrue);
        expect(find.text('Tap to draw your signature'), findsNothing);

        final png = await tester.runAsync(
          () => controller.toUint8List(pixelRatio: 1),
        );
        expect(controller.bytes, png);
        expect(base64Decode(controller.base64!), png);
        expect(changes.whereType<Uint8List>(), isNotEmpty);

        final (width, height, pixels) = (await tester.runAsync(
          () => _decode(png!),
        ))!;
        expect(width, lessThan(rect.width));
        expect(_pixel(pixels, width, 0, 0), 0xFFFFFFFF);
        expect(_pixel(pixels, width, width ~/ 2, height ~/ 2), 0x000000FF);
      },
    );

    testWidgets('exports the whole pad when cropping is off', (tester) async {
      final controller = GtSignaturePadController(
        exportOptions: const GtSignatureExportOptions(cropToSignature: false),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _SignaturePadTestApp(controller: controller, onSecondaryAction: () {}),
      );
      _drawLine(controller);
      await tester.pump();

      final png = await tester.runAsync(
        () => controller.toUint8List(pixelRatio: 1),
      );
      final (width, height, _) = (await tester.runAsync(() => _decode(png!)))!;
      final pad = tester.getSize(
        find
            .descendant(
              of: find.byType(GtSignaturePad),
              matching: find.byType(RepaintBoundary),
            )
            .first,
      );
      expect(width, pad.width.ceil());
      expect(height, pad.height.ceil());
    });

    testWidgets('exposes built-in undo, redo, and clear actions', (
      tester,
    ) async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      var clearCalls = 0;

      await tester.pumpWidget(
        _SignaturePadTestApp(
          controller: controller,
          onSecondaryAction: () {},
          onClear: () => clearCalls++,
        ),
      );

      controller.beginStroke(const Offset(20, 20));
      controller.appendPoint(const Offset(80, 60));
      controller.endStroke();
      await tester.pump();

      expect(find.bySemanticsLabel('Undo signature stroke'), findsOneWidget);
      expect(find.bySemanticsLabel('Redo signature stroke'), findsOneWidget);
      expect(find.bySemanticsLabel('Clear signature'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Undo signature stroke'));
      await tester.pump();
      expect(controller.hasSignature, isFalse);
      expect(controller.canRedo, isTrue);

      await tester.tap(find.bySemanticsLabel('Redo signature stroke'));
      await tester.pump();
      expect(controller.hasSignature, isTrue);

      await tester.tap(find.bySemanticsLabel('Clear signature'));
      await tester.pump();
      expect(controller.hasSignature, isFalse);
      expect(controller.canRedo, isFalse);
      expect(clearCalls, 1);
    });

    testWidgets('renders imported image preview and allows clearing it', (
      tester,
    ) async {
      final controller = GtSignaturePadController();
      addTearDown(controller.dispose);
      final rawBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      );

      await tester.pumpWidget(
        _SignaturePadTestApp(controller: controller, onSecondaryAction: () {}),
      );

      expect(find.text('Tap to draw your signature'), findsOneWidget);
      expect(find.byType(GtImage), findsNothing);

      controller.setImage(rawBytes);
      await tester.pump();

      expect(find.text('Tap to draw your signature'), findsNothing);
      expect(find.byType(GtImage), findsOneWidget);
      expect(find.bySemanticsLabel('Clear signature'), findsOneWidget);

      final pad = tester.getSize(find.byType(GtSignaturePad));
      final image = tester.getSize(find.byType(Image));
      final inset = 2 * tester.element(find.byType(Image)).dp(12.px);
      expect(image.width, closeTo(pad.width - inset, .01));
      expect(image.height, closeTo(pad.height - inset, .01));

      await tester.tap(find.bySemanticsLabel('Clear signature'));
      await tester.pump();

      expect(controller.hasSignature, isFalse);
      expect(find.byType(GtImage), findsNothing);
      expect(find.text('Tap to draw your signature'), findsOneWidget);
    });
  });
}
