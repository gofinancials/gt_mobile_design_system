import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  Future<void> pump(WidgetTester tester, {required bool obscureBalance}) {
    return tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: GtGoalProgressListTile(
              currentAmount: 120000,
              goalAmount: 500000,
              obscureBalance: obscureBalance,
            ),
          ),
        ),
      ),
    );
  }

  double progressValue(WidgetTester tester) {
    return tester
        .widget<GtAnimatedProgress>(find.byType(GtAnimatedProgress))
        .value;
  }

  testWidgets('shows the amount and percentage by default', (tester) async {
    await pump(tester, obscureBalance: false);

    expect(find.textContaining('120,000'), findsOneWidget);
    expect(find.textContaining('24%'), findsOneWidget);
  });

  testWidgets('masks the amount and percentage when obscured', (tester) async {
    await pump(tester, obscureBalance: true);

    expect(find.textContaining('*****'), findsOneWidget);
    expect(find.textContaining('120,000'), findsNothing);
    expect(find.textContaining('24%'), findsNothing);
    expect(find.textContaining('500,000'), findsOneWidget);
  });

  testWidgets('draws the real fraction when obscured', (tester) async {
    await pump(tester, obscureBalance: true);

    expect(progressValue(tester), closeTo(.24, .001));
  });
}
