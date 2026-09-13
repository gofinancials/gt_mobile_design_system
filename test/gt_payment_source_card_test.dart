import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/semantics_matchers.dart';
import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  final custom = kPersonalTheme.lightPalette.success.base;
  final other = kPersonalTheme.lightPalette.error.base;
  final customStyle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: other,
  );

  const label = 'Pay from';
  const title = 'SAVINGS • 1020293939';
  const subTitle = 'Balance ₦200,015.00';

  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox(width: 380, child: child)),
        ),
      ),
    );
  }

  GtPaymentSourceCard buildCard({
    String? label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GtPaymentSourceCard(
      label: label,
      title: title,
      subTitle: subTitle,
      leading: const Icon(Icons.account_balance),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Finder chevron() {
    return find.byWidgetPredicate(
      (widget) => widget is GtIcon && widget.icon == GtIcons.chevronDown,
    );
  }

  TextStyle textStyle(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text)).style!;
  }

  group('GtPaymentSourceCard', () {
    testWidgets('shows the label above the title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildCard(label: label)));

      expect(find.text(label), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(subTitle), findsOneWidget);
      expect(
        tester.getBottomLeft(find.text(label)).dy,
        lessThan(tester.getTopLeft(find.text(title)).dy),
      );
    });

    testWidgets('omits the header when the label is missing or empty', (
      tester,
    ) async {
      for (final missing in [null, '']) {
        await tester.pumpWidget(buildTestWidget(buildCard(label: missing)));

        expect(find.text(title), findsOneWidget);
        expect(find.text(subTitle), findsOneWidget);
        expect(find.text(label), findsNothing);
      }
    });

    testWidgets('shows a chevron unless a trailing widget is given', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildCard()));

      expect(chevron(), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(
          buildCard(
            trailing: const Icon(Icons.check, key: ValueKey('trailing')),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('trailing')), findsOneWidget);
      expect(chevron(), findsNothing);
    });

    testWidgets('reports taps and announces itself as a button', (
      tester,
    ) async {
      var taps = 0;

      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(buildCard(label: label, onTap: () => taps++)),
        );

        expectSemantics(
          tester,
          find.byType(GtPaymentSourceCard),
          isButton: true,
          hasTapAction: true,
        );

        await tester.tap(find.byType(GtPaymentSourceCard));
        await tester.pumpAndSettle();

        expect(taps, 1);
      });
    });

    testWidgets('has no tap action without onTap', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(buildTestWidget(buildCard(label: label)));

        expectSemantics(
          tester,
          find.byType(GtPaymentSourceCard),
          hasTapAction: false,
        );
      });
    });

    testWidgets('text overrides reach the label, title and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtPaymentSourceCard(
            label: label,
            title: title,
            subTitle: subTitle,
            leading: const Icon(Icons.account_balance),
            labelStyle: customStyle,
            titleColor: custom,
            titleStyle: customStyle,
            accountDetailColor: custom,
            subtitleStyle: customStyle,
          ),
        ),
      );

      expect(textStyle(tester, label).fontSize, 19);
      expect(textStyle(tester, label).color, custom);
      expect(textStyle(tester, title).fontSize, 19);
      expect(textStyle(tester, title).color, custom);
      expect(textStyle(tester, subTitle), customStyle);
    });

    testWidgets('surface and spacing overrides reach the card and header', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtPaymentSourceCard(
            label: label,
            title: title,
            subTitle: subTitle,
            leading: const Icon(Icons.account_balance),
            backgroundColor: custom,
            padding: EdgeInsets.zero,
            verticalSpacing: 0,
          ),
        ),
      );

      final card = tester.widget<GtCard>(find.byType(GtCard));
      expect(card.color, custom);
      expect(card.padding, EdgeInsets.zero);

      final column = tester.widget<Column>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Column))
            .first,
      );
      expect(column.spacing, 0);
    });
  });
}
