import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const title = "You don't have any item";
  const description = 'Your item will appear here';

  Future<void> pump(WidgetTester tester, Widget card) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kFlexTheme,
        child: MaterialApp(
          theme: kFlexTheme.materialLight,
          home: Scaffold(body: Center(child: card)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  GtText textOf(WidgetTester tester, String text) {
    return tester.widget<GtText>(
      find.byWidgetPredicate(
        (widget) => widget is GtText && widget.data == text,
      ),
    );
  }

  testWidgets('draws the title between the icon and the description', (
    tester,
  ) async {
    await pump(
      tester,
      GtEmptyStateCard(
        icon: GtIcons.clipboardSlash,
        title: title,
        description: description,
        footer: GtRaisedButton(text: 'Add item', onPressed: () {}),
      ),
    );

    final icon = tester.getRect(find.byType(GtIcon));
    final heading = tester.getRect(find.text(title));
    final body = tester.getRect(find.text(description));
    final button = tester.getRect(find.byType(GtRaisedButton));

    expect(heading.top, greaterThan(icon.bottom));
    expect(body.top, greaterThan(heading.bottom));
    expect(button.top, greaterThan(body.bottom));

    final context = tester.element(find.byType(GtEmptyStateCard));
    // The title sits 4dp above the description, closer than the 8dp gap to
    // the icon above it.
    expect(body.top - heading.bottom, context.spacingSm);
    expect(heading.top - icon.bottom, context.spacingBase);
  });

  testWidgets('sets the title in labelS at weight 600 by default', (
    tester,
  ) async {
    await pump(
      tester,
      const GtEmptyStateCard(
        icon: GtIcons.clipboardSlash,
        title: title,
        description: description,
      ),
    );

    final context = tester.element(find.byType(GtEmptyStateCard));
    final expected = context.textStyles.labelS(weight: .w600);
    final style = textOf(tester, title).style!;

    expect(style.fontSize, expected.fontSize);
    expect(style.height, expected.height);
    expect(style.fontWeight, FontWeight.w600);
    expect(style.color, expected.color);
  });

  testWidgets('titleStyle and titleColor override the title', (tester) async {
    const color = Color(0xFF1FC16B);
    await pump(
      tester,
      const GtEmptyStateCard(
        icon: GtIcons.clipboardSlash,
        title: title,
        description: description,
        titleStyle: TextStyle(fontSize: 18),
        titleColor: color,
      ),
    );

    final style = textOf(tester, title).style!;
    expect(style.fontSize, 18);
    expect(style.color, color);
  });

  testWidgets('the image constructor takes a title too', (tester) async {
    await pump(
      tester,
      const GtEmptyStateCard.image(
        image: SizedBox.square(key: Key('image'), dimension: 32),
        title: title,
        description: description,
      ),
    );

    final image = tester.getRect(find.byKey(const Key('image')));
    final heading = tester.getRect(find.text(title));
    expect(heading.top, greaterThan(image.bottom));
    expect(find.text(description), findsOneWidget);
  });

  testWidgets('without a title the card draws no title', (tester) async {
    await pump(
      tester,
      const GtEmptyStateCard(
        icon: GtIcons.clipboardSlash,
        description: description,
      ),
    );

    expect(find.byType(GtText), findsOneWidget);
    final context = tester.element(find.byType(GtEmptyStateCard));
    final icon = tester.getRect(find.byType(GtIcon));
    final body = tester.getRect(find.text(description));
    expect(body.top - icon.bottom, context.spacingBase);
  });

  group('footer spacing', () {
    Future<({double underIcon, double aboveFooter})> gaps(
      WidgetTester tester, {
      double? spacing,
      double? footerSpacing,
    }) async {
      await pump(
        tester,
        GtEmptyStateCard(
          icon: GtIcons.clipboardSlash,
          title: title,
          description: description,
          spacing: spacing,
          footerSpacing: footerSpacing,
          footer: GtRaisedButton(text: 'Add item', onPressed: () {}),
        ),
      );
      final icon = tester.getRect(find.byType(GtIcon));
      final heading = tester.getRect(find.text(title));
      final body = tester.getRect(find.text(description));
      final button = tester.getRect(find.byType(GtRaisedButton));
      return (
        underIcon: heading.top - icon.bottom,
        aboveFooter: button.top - body.bottom,
      );
    }

    testWidgets('defaults to the card spacing', (tester) async {
      final result = await gaps(tester);
      final context = tester.element(find.byType(GtEmptyStateCard));

      expect(result.underIcon, context.spacingBase);
      expect(result.aboveFooter, context.spacingBase);
    });

    testWidgets('follows spacing when only spacing is set', (tester) async {
      final result = await gaps(tester, spacing: 16);

      expect(result.underIcon, 16);
      expect(result.aboveFooter, 16);
    });

    testWidgets('sets the gap above the footer alone, wider or narrower', (
      tester,
    ) async {
      for (final footerSpacing in [12.0, 2.0]) {
        final result = await gaps(tester, footerSpacing: footerSpacing);
        final context = tester.element(find.byType(GtEmptyStateCard));

        expect(result.underIcon, context.spacingBase);
        expect(result.aboveFooter, footerSpacing);
      }
    });
  });
}
