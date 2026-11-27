import 'package:flutter/material.dart';
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

  testWidgets('draws an overdrawn balance with the sign before the symbol', (
    tester,
  ) async {
    const balance = GtBalanceText(amount: -22096.06);
    expect(balance.amtDisplay, '22,096.06');
    expect(balance.semanticLabel, contains('-22,096.06'));

    await tester.pumpWidget(buildTestWidget(balance));
    expect(find.text('-${AppStrings.naira} '), findsOneWidget);

    // Masked, the line does not reveal that the account is overdrawn.
    expect(
      const GtBalanceText(amount: -22096.06, hidden: true).semanticLabel,
      isNot(contains('-')),
    );
  });

  group('GtBalanceText visibility icon', () {
    testWidgets('shows the icon and toggles on tap by default', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtBalanceText(amount: 12, onVisibilityIconTap: () => taps++),
        ),
      );

      expect(find.byIcon(GtIcons.eyeClosed), findsOneWidget);
      expect(find.byType(GtInkWell), findsOneWidget);

      await tester.tap(find.byType(GtBalanceText));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('omits the icon and the tap target when hidden', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtBalanceText(
            amount: 12,
            showVisibilityIcon: false,
            onVisibilityIconTap: () => taps++,
          ),
        ),
      );

      expect(find.byIcon(GtIcons.eyeClosed), findsNothing);
      expect(find.byIcon(GtIcons.eyeOpen), findsNothing);
      expect(find.byType(GtInkWell), findsNothing);
      expect(find.byType(GtTapTarget), findsNothing);

      await tester.tap(find.byType(GtBalanceText));
      await tester.pumpAndSettle();

      expect(taps, 0);
    });

    testWidgets('still masks the amount without the icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtBalanceText(
            amount: 12,
            hidden: true,
            showVisibilityIcon: false,
          ),
        ),
      );

      final text = tester.widget<Text>(
        find
            .descendant(
              of: find.byType(GtBalanceText),
              matching: find.byType(Text),
            )
            .first,
      );
      expect(text.textSpan?.toPlainText(), contains('********'));
      expect(find.byIcon(GtIcons.eyeOpen), findsNothing);
    });

    testWidgets('omits the icon from animated amounts', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtBalanceText(
            amount: 12,
            animateChanges: true,
            showVisibilityIcon: false,
          ),
        ),
      );

      expect(find.byType(GtAnimatedCounter), findsOneWidget);
      expect(find.byIcon(GtIcons.eyeClosed), findsNothing);
    });
  });
}
