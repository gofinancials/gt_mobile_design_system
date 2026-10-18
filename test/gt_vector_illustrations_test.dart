import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _packagePrefix = 'packages/gt_mobile_ui/';
const _redPath =
    'packages/gt_mobile_ui/assets/images/vector/illustrations/red/empty.svg';

/// Pumps a tree themed with [palette] and returns a context inside it.
Future<BuildContext> _contextFor(WidgetTester tester, GtPalette palette) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [palette]),
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured;
}

void main() {
  group('GtIllustrationExtension.adapt', () {
    testWidgets('keeps the original illustration for other palettes', (
      tester,
    ) async {
      final context = await _contextFor(tester, PersonalLightPalette());
      expect(
        GtVectorIllustrations.empty.adapt(context),
        GtVectorIllustrations.empty,
      );
    });

    testWidgets('swaps in the red variant for red palettes', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      expect(GtVectorIllustrations.empty.adapt(context), _redPath);
    });

    testWidgets('keeps illustrations without a red variant', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      expect(GtVectorIllustrations.fx.adapt(context), GtVectorIllustrations.fx);
    });

    testWidgets('keeps paths that are not illustrations', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      const url = 'https://example.com/flag.svg';
      expect(url.adapt(context), url);
      expect(GtVectors.logo.adapt(context), GtVectors.logo);
    });

    testWidgets('every red variant exists on disk', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      for (final (:label, :value) in GtVectorIllustrations.all) {
        final adapted = value.adapt(context);
        final file = File(adapted.replaceFirst(_packagePrefix, ''));
        expect(file.existsSync(), isTrue, reason: '$label -> $adapted');
      }
    });
  });

  group('GtIllustrationImageExtension.adapt', () {
    testWidgets('adapts an illustration path and keeps the metadata', (
      tester,
    ) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      const image = AppImageData(GtVectorIllustrations.empty, name: 'Empty');

      final adapted = image.adapt(context);
      expect(adapted.imageData, _redPath);
      expect(adapted.name, 'Empty');
    });

    testWidgets('returns the same image when nothing changes', (tester) async {
      final context = await _contextFor(tester, PersonalLightPalette());
      const image = AppImageData(GtVectorIllustrations.empty);
      const icon = AppImageData.icon(Icons.add);

      expect(image.adapt(context), same(image));
      expect(icon.adapt(context), same(icon));
    });
  });
}
