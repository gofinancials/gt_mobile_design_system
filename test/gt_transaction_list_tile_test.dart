import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  Future<TextStyle> pumpStyle(
    WidgetTester tester,
    Finder text, {
    bool isDebit = true,
  }) async {
    await tester.pumpWidget(
      buildTestWidget(
        GtTransactionListTile(
          'Netflix',
          subtitle: 'Card payment',
          amount: 1500,
          isDebit: isDebit,
        ),
      ),
    );
    return tester.widget<Text>(text).style!;
  }

  group('GtTransactionListTile default text styles', () {
    testWidgets('draws the name as Body/M: Medium 14/20 with no tracking', (
      tester,
    ) async {
      final style = await pumpStyle(tester, find.text('Netflix'));

      expect(style.fontSize, 14);
      expect(style.height, 20 / 14);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, 0);
    });

    testWidgets('draws the amount as SemiBold 14/20 with no tracking', (
      tester,
    ) async {
      final style = await pumpStyle(tester, find.textContaining('1,500'));

      expect(style.fontSize, 14);
      expect(style.height, 20 / 14);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0);
    });

    testWidgets('draws the type as Caption/L: Medium 12/16 with no tracking', (
      tester,
    ) async {
      final style = await pumpStyle(tester, find.text('Card payment'));

      expect(style.fontSize, 12);
      expect(style.height, 16 / 12);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, 0);
    });

    testWidgets('colors the type with the sub text color', (tester) async {
      final style = await pumpStyle(tester, find.text('Card payment'));
      final context = tester.element(find.byType(GtTransactionListTile));

      expect(style.color, context.palette.text.sub);
    });

    testWidgets('colors the amount by direction', (tester) async {
      final debit = await pumpStyle(tester, find.textContaining('1,500'));
      final debitContext = tester.element(find.byType(GtTransactionListTile));
      expect(debit.color, debitContext.palette.text.strong);

      final credit = await pumpStyle(
        tester,
        find.textContaining('1,500'),
        isDebit: false,
      );
      final creditContext = tester.element(find.byType(GtTransactionListTile));
      expect(credit.color, creditContext.palette.success.darker);
    });
  });

  testWidgets('a style override still replaces the default', (tester) async {
    const override = TextStyle(fontSize: 19, letterSpacing: 2);

    await tester.pumpWidget(
      buildTestWidget(
        const GtTransactionListTile(
          'Netflix',
          subtitle: 'Card payment',
          amount: 1500,
          isDebit: true,
          nameStyle: override,
          subtitleStyle: override,
          amountStyle: override,
        ),
      ),
    );

    for (final text in [
      find.text('Netflix'),
      find.text('Card payment'),
      find.textContaining('1,500'),
    ]) {
      expect(tester.widget<Text>(text).style, override);
    }
  });

  group('subtitle alignment', () {
    const short = 'Transfer';
    const long = '000001261123185443565532414245 | Overdraft OneBank';

    /// Pumps [tile] on a 375 wide phone with a 16 gutter.
    Future<void> pumpTile(WidgetTester tester, Widget tile) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        buildTestWidget(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: tile,
          ),
        ),
      );
    }

    /// Where the first glyph of [text] is drawn, from the screen's left edge.
    double firstGlyphLeft(WidgetTester tester, String text) {
      final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
      final box = paragraph
          .getBoxesForSelection(
            const TextSelection(baseOffset: 0, extentOffset: 1),
          )
          .first;
      return paragraph.localToGlobal(Offset(box.left, 0)).dx;
    }

    for (final subtitle in [short, long]) {
      testWidgets('GtTransactionListTile starts "$subtitle" under the name', (
        tester,
      ) async {
        await pumpTile(
          tester,
          GtTransactionListTile(
            'Boluwatife Kolawole',
            subtitle: subtitle,
            amount: 20000,
            isDebit: true,
          ),
        );

        expect(
          firstGlyphLeft(tester, subtitle),
          moreOrLessEquals(firstGlyphLeft(tester, 'Boluwatife Kolawole')),
        );
      });

      testWidgets('GtPaymentListTile starts "$subtitle" under the title', (
        tester,
      ) async {
        await pumpTile(
          tester,
          GtPaymentListTile(
            'Boluwatife Kolawole',
            subtitle: subtitle,
            amount: '${AppStrings.naira}20,000.00',
          ),
        );

        expect(
          firstGlyphLeft(tester, subtitle),
          moreOrLessEquals(firstGlyphLeft(tester, 'Boluwatife Kolawole')),
        );
      });
    }
  });

  testWidgets('draws a negative debit by its size, unsigned', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        const GtTransactionListTile(
          'Netflix',
          subtitle: 'Card payment',
          amount: -1500,
          isDebit: true,
        ),
      ),
    );

    expect(find.text('${AppStrings.naira}1,500.00'), findsOneWidget);
    expect(find.textContaining('-'), findsNothing);
  });

  group('GtTransactionLeading tag', () {
    const tagKey = Key('bank-logo');
    const tag = ColoredBox(key: tagKey, color: Colors.red);

    Finder tagBox() => find.descendant(
      of: find.byType(GtTransactionLeading),
      matching: find.byType(GtSquareConstrainedBox),
    );

    testWidgets('draws no tag by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtTransactionLeading('AO', size: 50)),
      );

      expect(tagBox(), findsNothing);
    });

    testWidgets('sizes the tag to 40% of the badge by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtTransactionLeading('AO', size: 50, tag: tag)),
      );

      expect(tester.getSize(tagBox()), const Size.square(20));
    });

    testWidgets('sizes the tag to tagSize when set', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtTransactionLeading('AO', size: 50, tag: tag, tagSize: 16),
        ),
      );

      expect(tester.getSize(tagBox()), const Size.square(16));
    });

    testWidgets('nudges the tag a tenth of its size past the bottom-right', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const GtTransactionLeading('AO', size: 50, tag: tag)),
      );

      final badge = tester.getRect(find.byType(GtTransactionLeading));
      final logo = tester.getRect(find.byKey(tagKey));
      expect(logo.bottomRight, badge.bottomRight + const Offset(2, 2));
    });

    testWidgets('keeps the badge footprint unchanged', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const GtTransactionLeading('AO', size: 50, tag: tag)),
      );

      expect(
        tester.getSize(find.byType(GtTransactionLeading)),
        const Size.square(50),
      );
    });

    testWidgets('announces only the semantics label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          GtTransactionLeading(
            'AO',
            size: 50,
            semanticsLabel: 'Adaeze Okafor, Access Bank',
            tag: Semantics(label: 'Access Bank logo', child: tag),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('Adaeze Okafor, Access Bank'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Access Bank logo'), findsNothing);
      handle.dispose();
    });
  });
}
