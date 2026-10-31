import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

// Kept apart from gt_middle_ellipsis_test.dart because loading a font is
// global: every test after it in the same isolate would measure in it.

const _family = 'packages/gt_mobile_ui/Runde';
const _value = 'Domiciliary Account • 3456789012';
const _style = TextStyle(fontFamily: _family, fontSize: 14);

Future<void> _load(String family, List<String> files) async {
  final loader = FontLoader('packages/gt_mobile_ui/$family');
  for (final file in files) {
    final bytes = File('assets/fonts/$file').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<void> _loadRunde() {
  return _load('Runde', [
    'OpenRunde-Regular.otf',
    'OpenRunde-Medium.otf',
    'OpenRunde-Semibold.otf',
    'OpenRunde-Bold.otf',
  ]);
}

void main() {
  setUpAll(registerTestAppConfig);

  testWidgets('re-cuts when a font finishes loading', (tester) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: .topLeft,
              child: SizedBox(
                width: 160,
                child: GtText(_value, style: _style, middleEllipsis: true),
              ),
            ),
          ),
        ),
      ),
    );
    // Cut in the fallback font, as on web before the asset font arrives.
    final before = tester.widget<Text>(find.byType(Text)).data;

    await tester.runAsync(_loadRunde);
    await tester.pump();
    await tester.pump();

    final shown = tester.widget<Text>(find.byType(Text)).data!;
    final fit = GtTextFit.of(
      tester.element(find.byType(GtText)),
      style: _style,
      maxLines: 1,
    );
    addTearDown(fit.dispose);

    expect(shown, isNot(before));
    expect(shown, fit.middleEllipsis(_value, 160));
    final paragraph = tester.renderObject<RenderParagraph>(
      find.byType(RichText),
    );
    expect(paragraph.didExceedMaxLines, isFalse);
  });

  testWidgets('a cut in the real typography never overflows', (tester) async {
    await tester.runAsync(() async {
      await _loadRunde();
      await _load('Momo', ['Momo-Medium.otf', 'Momo-Bold.otf']);
    });

    late List<TextStyle> styles;
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyles = context.textStyles;
              styles = [
                textStyles.bodyXs(weight: .w500),
                textStyles.labelS(weight: .w500),
                textStyles.button(),
                textStyles.h6(),
                textStyles.h5(),
              ];
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    const values = [
      _value,
      'GB29NWBK60161331926819',
      'SEND TO JAMIE SMITH • 0123456789',
      'Wide WWWW mmmm iiii llll ₦160,000.00 😀',
    ];
    for (final style in styles) {
      for (final maxLines in [1, 2]) {
        for (double width = 40; width <= 320; width += 23) {
          for (final value in values) {
            await tester.pumpWidget(
              GtThemeProvider(
                theme: kPersonalTheme,
                child: MaterialApp(
                  home: Scaffold(
                    body: Align(
                      alignment: .topLeft,
                      child: SizedBox(
                        width: width,
                        child: GtText(
                          value,
                          style: style,
                          maxLines: maxLines,
                          middleEllipsis: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );

            final paragraph = tester.renderObject<RenderParagraph>(
              find.byType(RichText),
            );
            final shown = tester.widget<Text>(find.byType(Text)).data;
            expect(
              paragraph.didExceedMaxLines && shown != GtTextFit.ellipsis,
              isFalse,
              reason:
                  '"$shown" at $width, $maxLines lines, ${style.fontFamily}',
            );
          }
        }
      }
    }
  });
}
