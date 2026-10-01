import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
