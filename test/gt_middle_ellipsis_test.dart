import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

// The test font draws every glyph, `…` included, as a square one font size
// wide, so at size 10 a box 55 wide holds five glyphs.
const _style = TextStyle(fontSize: 10, height: 1, letterSpacing: 0);

void main() {
  setUpAll(registerTestAppConfig);

  Widget buildTestWidget(Widget child, {double textScale = 1}) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(textScaler: .linear(textScale)),
            child: Align(alignment: .topLeft, child: child),
          ),
        ),
      ),
    );
  }

  GtTextFit fitOf(WidgetTester tester, {int? maxLines = 1}) {
    final context = tester.element(find.byType(Align));
    return GtTextFit.of(context, style: _style, maxLines: maxLines);
  }

  group('GtTextFit', () {
    testWidgets('fits within the width and line cap', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      expect(fit.fits('ABCDE', 50), isTrue);
      expect(fit.fits('ABCDEF', 50), isFalse);
    });

    testWidgets('a word may break across lines unless wholeWords is set', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester, maxLines: 2);
      addTearDown(fit.dispose);

      expect(fit.fits('ABCDEFGH', 50), isTrue);
      expect(fit.fits('ABCDEFGH', 50, wholeWords: true), isFalse);
      expect(fit.fits('ABCD EFGH', 50, wholeWords: true), isTrue);
    });

    testWidgets('middleEllipsis keeps the head and tail', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      expect(fit.middleEllipsis('ABCDE', 55), 'ABCDE');
      expect(fit.middleEllipsis('ABCDEFGHIJ', 55), 'AB…IJ');
      expect(fit.middleEllipsis('ABCDEFGHIJ', 45), 'AB…J');
      expect(fit.middleEllipsis('ABCDEFGHIJ', 5), '…');
    });

    testWidgets('middleEllipsis trims the spaces beside the cut', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      expect(fit.middleEllipsis('AB CDEFG HI', 55), 'AB…HI');
    });

    testWidgets('middleEllipsis never splits a grapheme cluster', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      const family = '\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}';
      const text = '${family}ABCDEFGH$family';
      final whole = text.characters.toSet();

      for (final width in [25.0, 35.0, 55.0, 75.0]) {
        final shown = fit.middleEllipsis(text, width);
        expect(shown, contains('…'));
        // A split family would leave a lone person, a cluster of its own.
        final kept = shown.characters.where((c) => c != '…');
        expect(kept, everyElement(isIn(whole)));
      }
    });

    testWidgets('middleEllipsis keeps the most that fits, however uneven', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox()));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      // Wide emoji among narrow letters, so a guess from the average width
      // lands off the mark and the search has to gallop and bisect.
      const text =
          'Ab\u{1F600}\u{1F600}cdefghij\u{1F600}klmnop\u{1F600}\u{1F600}qr';
      final characters = text.characters.toList();
      String keep(int kept) {
        final head = characters.take((kept + 1) ~/ 2).join().trimRight();
        final tail = characters.skip(characters.length - kept ~/ 2).join();
        return '$head…${tail.trimLeft()}';
      }

      for (double width = 5; width <= 400; width += 7) {
        String expected = text;
        if (!fit.fits(text, width)) {
          expected = '…';
          for (int kept = characters.length - 1; kept > 0; kept--) {
            if (fit.fits(keep(kept), width)) {
              expected = keep(kept);
              break;
            }
          }
        }
        expect(fit.middleEllipsis(text, width), expected, reason: '$width');
      }
    });

    testWidgets('of follows the ambient text scale', (tester) async {
      await tester.pumpWidget(buildTestWidget(const SizedBox(), textScale: 2));
      final fit = fitOf(tester);
      addTearDown(fit.dispose);

      expect(fit.middleEllipsis('ABCDEFGHIJ', 55), 'A…');
    });
  });

  group('GtText.middleEllipsis', () {
    testWidgets('cuts the middle of text too wide for its box', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtText('ABCDEFGHIJ', style: _style, middleEllipsis: true),
          ),
        ),
      );

      expect(find.text('AB…IJ'), findsOneWidget);
    });

    testWidgets('leaves text that fits untouched', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtText('ABCDE', style: _style, middleEllipsis: true),
          ),
        ),
      );

      expect(find.text('ABCDE'), findsOneWidget);
    });

    testWidgets('announces the whole text when cut', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtText('ABCDEFGHIJ', style: _style, middleEllipsis: true),
          ),
        ),
      );

      expect(find.bySemanticsLabel('ABCDEFGHIJ'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('cuts within maxLines lines', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtText(
              'ABCDEFGHIJKLMNOPQRST',
              style: _style,
              maxLines: 2,
              middleEllipsis: true,
            ),
          ),
        ),
      );

      expect(find.text('ABCDE…QRST'), findsOneWidget);
    });

    testWidgets('re-cuts when the box narrows', (tester) async {
      Widget at(double width) {
        return buildTestWidget(
          SizedBox(
            width: width,
            child: const GtText(
              'ABCDEFGHIJ',
              style: _style,
              middleEllipsis: true,
            ),
          ),
        );
      }

      await tester.pumpWidget(at(105));
      expect(find.text('ABCDEFGHIJ'), findsOneWidget);

      await tester.pumpWidget(at(55));
      expect(find.text('AB…IJ'), findsOneWidget);
    });

    testWidgets('is never cut in an unbounded width', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SingleChildScrollView(
            scrollDirection: .horizontal,
            child: GtText('ABCDEFGHIJ', style: _style, middleEllipsis: true),
          ),
        ),
      );

      expect(find.text('ABCDEFGHIJ'), findsOneWidget);
    });

    testWidgets('lays out under IntrinsicHeight and IntrinsicWidth', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GtText(
                      'ABCDEFGHIJ',
                      style: _style,
                      middleEllipsis: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('AB…IJ'), findsOneWidget);
      expect(tester.getSize(find.byType(Row)).height, 10);

      await tester.pumpWidget(
        buildTestWidget(
          const IntrinsicWidth(
            child: GtText('ABCDEFGHIJ', style: _style, middleEllipsis: true),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(IntrinsicWidth)).width, 100);
    });

    testWidgets('follows the ambient text scale', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtText('ABCDEFGHIJ', style: _style, middleEllipsis: true),
          ),
          textScale: 2,
        ),
      );

      expect(find.text('A…'), findsOneWidget);
    });
  });

  group('middle ellipsis consumers', () {
    testWidgets('a summary row keeps the end of its value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 240,
            child: GtSummaryTile(
              GtSummaryTileData(
                label: 'From',
                value: 'Domiciliary Account • 0123456789',
                middleEllipsis: true,
              ),
            ),
          ),
        ),
      );

      final value = tester.widget<Text>(find.textContaining('…'));
      expect(value.data, endsWith('6789'));
      expect(value.data, startsWith('D'));
    });

    testWidgets('a skeleton still bones each line', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 55,
            child: GtSkeleton(
              child: GtText(
                'ABCDEFGHIJKLMNOPQRST',
                style: _style,
                maxLines: 2,
                middleEllipsis: true,
              ),
            ),
          ),
        ),
      );

      final bone = tester.renderObject(find.byType(GtBone));
      expect(bone, paintsExactlyCountTimes(#drawRRect, 2));
    });
  });

  group('GtActionButtonBar', () {
    GtActionButton button(String label) {
      return GtActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        icon: Icons.send,
        label: label,
        labelStyle: _style,
      );
    }

    testWidgets('spreads captions that fit their slots', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 300,
            child: GtActionButtonBar(
              buttons: [button('Send'), button('Top up'), button('Pay')],
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('scrolls when a caption would break a word', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 300,
            child: GtActionButtonBar(
              buttons: [
                button('Send'),
                button('Internationally'),
                button('Pay'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
