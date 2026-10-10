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
    Widget child,
    String text,
  ) async {
    await tester.pumpWidget(buildTestWidget(child));
    return tester.widget<Text>(find.text(text)).style!;
  }

  group('Untracked default typography', () {
    testWidgets('draws a GtIconListTile title as Title/XS', (tester) async {
      final style = await pumpStyle(
        tester,
        const GtIconListTile('Send money', leading: SizedBox.square()),
        'Send money',
      );

      expect(style.fontSize, 14);
      expect(style.height, 20 / 14);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0);
    });

    testWidgets('draws a GtProductInfoCard name as Title/XS', (tester) async {
      final style = await pumpStyle(
        tester,
        const GtProductInfoCard(name: 'Savings', description: 'Earn more'),
        'Savings',
      );

      expect(style.fontSize, 14);
      expect(style.height, 20 / 14);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0);
    });

    testWidgets('draws a GtProductInfoCard description as Body/S', (
      tester,
    ) async {
      final style = await pumpStyle(
        tester,
        const GtProductInfoCard(name: 'Savings', description: 'Earn more'),
        'Earn more',
      );

      expect(style.fontSize, 12);
      expect(style.height, 16 / 12);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, 0);
    });

    testWidgets('keeps a passed titleStyle', (tester) async {
      const override = TextStyle(fontSize: 19, letterSpacing: 2);
      final style = await pumpStyle(
        tester,
        const GtIconListTile(
          'Send money',
          leading: SizedBox.square(),
          titleStyle: override,
        ),
        'Send money',
      );

      expect(style.fontSize, 19);
      expect(style.letterSpacing, 2);
    });
  });
}
