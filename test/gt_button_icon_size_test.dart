import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  double dp(WidgetTester tester, double value) {
    return tester.element(find.byType(Scaffold)).dp(value.px);
  }

  Rect iconRect(WidgetTester tester, IconData icon) {
    return tester.getRect(find.byIcon(icon));
  }

  Rect buttonRect(WidgetTester tester) {
    return tester.getRect(find.byType(ElevatedButton));
  }

  Rect labelRect(WidgetTester tester) {
    return tester.getRect(find.byType(Text));
  }

  group('GtHelpButton', () {
    testWidgets('matches the header nav pill by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(GtHelpButton(onPressed: () {})));

      final spark = iconRect(tester, GtIcons.spark);
      final label = labelRect(tester);
      final button = buttonRect(tester);

      expect(spark.width, moreOrLessEquals(dp(tester, 20)));
      expect(spark.height, moreOrLessEquals(dp(tester, 20)));
      expect(spark.left - button.left, moreOrLessEquals(dp(tester, 6)));
      expect(label.left - spark.right, moreOrLessEquals(dp(tester, 6)));
      expect(button.right - label.right, moreOrLessEquals(dp(tester, 10)));
    });

    testWidgets('lets callers override the icon size, spacing and padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtHelpButton(
            onPressed: () {},
            iconSize: 24,
            iconSpacing: 10,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      );

      final spark = iconRect(tester, GtIcons.spark);
      final label = labelRect(tester);
      final button = buttonRect(tester);

      expect(spark.size, const Size.square(24));
      expect(spark.left - button.left, moreOrLessEquals(12));
      expect(label.left - spark.right, moreOrLessEquals(10));
      expect(button.right - label.right, moreOrLessEquals(12));
    });
  });

  group('text buttons', () {
    testWidgets('GtRaisedButton keeps its size-based icon layout by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtRaisedButton(
            text: 'Next',
            size: .small,
            leading: GtIcons.spark,
            onPressed: () {},
          ),
        ),
      );

      final spark = iconRect(tester, GtIcons.spark);

      expect(spark.size, const Size.square(18));
      expect(
        labelRect(tester).left - spark.right,
        moreOrLessEquals(dp(tester, 8)),
      );
    });

    testWidgets('GtOutlineButton and GtTextButton keep their size-based icon '
        'size by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtOutlineButton(
            text: 'Next',
            leading: GtIcons.spark,
            onPressed: () {},
          ),
        ),
      );

      expect(iconRect(tester, GtIcons.spark).size, const Size.square(20));

      await tester.pumpWidget(
        buildTestWidget(
          GtTextButton(text: 'Next', leading: GtIcons.spark, onPressed: () {}),
        ),
      );

      expect(iconRect(tester, GtIcons.spark).size, const Size.square(20));
    });

    testWidgets('GtRaisedButton applies a custom iconSize and iconSpacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtRaisedButton(
            text: 'Next',
            size: .small,
            iconSize: 22,
            iconSpacing: 12,
            leading: GtIcons.spark,
            trailing: GtIcons.chevronLeft,
            onPressed: () {},
          ),
        ),
      );

      final leading = iconRect(tester, GtIcons.spark);
      final trailing = iconRect(tester, GtIcons.chevronLeft);
      final label = labelRect(tester);

      expect(leading.size, const Size.square(22));
      expect(trailing.size, const Size.square(22));
      expect(label.left - leading.right, moreOrLessEquals(12));
      expect(trailing.left - label.right, moreOrLessEquals(12));
    });

    testWidgets('GtOutlineButton applies a custom iconSize and iconSpacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtOutlineButton(
            text: 'Next',
            iconSize: 22,
            iconSpacing: 12,
            leading: GtIcons.spark,
            trailing: GtIcons.chevronLeft,
            onPressed: () {},
          ),
        ),
      );

      final leading = iconRect(tester, GtIcons.spark);
      final trailing = iconRect(tester, GtIcons.chevronLeft);
      final label = labelRect(tester);

      expect(leading.size, const Size.square(22));
      expect(trailing.size, const Size.square(22));
      expect(label.left - leading.right, moreOrLessEquals(12));
      expect(trailing.left - label.right, moreOrLessEquals(12));
    });

    testWidgets('GtTextButton applies a custom iconSize and iconSpacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtTextButton(
            text: 'Next',
            iconSize: 22,
            iconSpacing: 12,
            leading: GtIcons.spark,
            trailing: GtIcons.chevronLeft,
            onPressed: () {},
          ),
        ),
      );

      final leading = iconRect(tester, GtIcons.spark);
      final trailing = iconRect(tester, GtIcons.chevronLeft);
      final label = labelRect(tester);

      expect(leading.size, const Size.square(22));
      expect(trailing.size, const Size.square(22));
      expect(label.left - leading.right, moreOrLessEquals(12));
      expect(trailing.left - label.right, moreOrLessEquals(12));
    });
  });

  group('GtIconButton', () {
    testWidgets('keeps its size-based icon size by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(GtIconButton(icon: GtIcons.spark, onPressed: () {})),
      );

      expect(iconRect(tester, GtIcons.spark).size, const Size.square(24));
    });

    testWidgets('draws its icon at a custom iconSize', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtIconButton(icon: GtIcons.spark, iconSize: 30, onPressed: () {}),
        ),
      );

      expect(iconRect(tester, GtIcons.spark).size, const Size.square(30));
    });
  });
}
