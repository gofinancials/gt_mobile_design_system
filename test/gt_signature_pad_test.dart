import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _FakeScreenShotService extends ScreenShotService {
  final Uint8List image = Uint8List.fromList(<int>[
    137,
    80,
    78,
    71,
    13,
    10,
    26,
    10,
    1,
    2,
    3,
  ]);

  @override
  Future<Uint8List?> captureScreen(
    BuildContext context, {
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    return Uint8List.fromList(image);
  }
}

class _SignaturePadTestApp extends GtStatelessWidget {
  final GtSignaturePadController controller;
  final OnChanged<Uint8List?>? onChanged;
  final OnPressed onSecondaryAction;
  final OnPressed? onClear;

  const _SignaturePadTestApp({
    required this.controller,
    required this.onSecondaryAction,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
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
      'draws and exposes a PNG through sync and async controller APIs',
      (tester) async {
        final controller = GtSignaturePadController(
          screenShotService: _FakeScreenShotService(),
        );
        addTearDown(controller.dispose);
        final changes = <Uint8List?>[];

        await tester.pumpWidget(
          _SignaturePadTestApp(
            controller: controller,
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
        await gesture.moveBy(const Offset(100, 24));
        await gesture.up();
        await tester.pump();
        await tester.pump();

        expect(controller.hasSignature, isTrue);
        expect(find.text('Tap to draw your signature'), findsNothing);
        expect(controller.bytes, isNotNull);
        expect(controller.base64, isNotNull);
        expect(base64Decode(controller.base64!), controller.bytes);
        expect(
          controller.bytes!.take(8),
          orderedEquals(<int>[137, 80, 78, 71, 13, 10, 26, 10]),
        );
        expect(changes.whereType<Uint8List>(), isNotEmpty);

        final freshBytes = await controller.toUint8List(pixelRatio: 1);
        expect(freshBytes, isNotNull);
      },
    );

    testWidgets('exposes built-in undo, redo, and clear actions', (
      tester,
    ) async {
      final controller = GtSignaturePadController(
        screenShotService: _FakeScreenShotService(),
      );
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
        _SignaturePadTestApp(
          controller: controller,
          onSecondaryAction: () {},
        ),
      );

      expect(find.text('Tap to draw your signature'), findsOneWidget);
      expect(find.byType(GtImage), findsNothing);

      controller.setImage(rawBytes);
      await tester.pump();

      expect(find.text('Tap to draw your signature'), findsNothing);
      expect(find.byType(GtImage), findsOneWidget);
      expect(find.bySemanticsLabel('Clear signature'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Clear signature'));
      await tester.pump();

      expect(controller.hasSignature, isFalse);
      expect(find.byType(GtImage), findsNothing);
      expect(find.text('Tap to draw your signature'), findsOneWidget);
    });
  });
}
