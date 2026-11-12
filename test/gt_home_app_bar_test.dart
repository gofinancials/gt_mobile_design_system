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

  GtHomeAppBar buildAppBar() {
    return GtHomeAppBar(
      userFullName: 'Alex Lobaloba',
      onClickHelp: () {},
      onClickSearch: () {},
      onClickHide: () {},
      onClickNotification: () {},
      onToggleAccounts: () {},
      toggleAccountText: 'All Accounts',
    );
  }

  GtPalette palette(WidgetTester tester) {
    return tester.element(find.byType(Scaffold)).palette;
  }

  group('GtHomeAppBar', () {
    testWidgets('draws every button as raised glass', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildAppBar()));

      expect(find.byType(GtGlassSurface), findsNWidgets(5));
      for (final button in [GtIconButton, GtRaisedButton]) {
        expect(
          find.descendant(
            of: find.byType(button),
            matching: find.byType(GtGlassSurface),
          ),
          findsWidgets,
        );
      }
    });

    testWidgets('fills the buttons with primary alpha-10', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildAppBar()));

      final alpha10 = palette(tester).primary.alpha10;
      final iconButtons = tester.widgetList<IconButton>(
        find.byType(IconButton),
      );
      final toggle = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(iconButtons, hasLength(4));
      for (final button in iconButtons) {
        expect(button.style?.backgroundColor?.resolve({}), alpha10);
      }
      expect(toggle.style?.backgroundColor?.resolve({}), alpha10);
    });

    testWidgets('sizes the buttons to 36 with a full tap target', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(buildAppBar()));

      final iconButtons = find.byType(IconButton);
      for (var i = 0; i < 4; i++) {
        expect(tester.getSize(iconButtons.at(i)), const Size.square(36));
      }
      expect(tester.getSize(find.byType(ElevatedButton)).height, 36);
      expect(find.byType(GtTapTarget), findsNWidgets(5));
      expect(
        tester.getSize(find.byIcon(GtIcons.messages)),
        const Size.square(20),
      );
    });

    testWidgets('sets the switcher label at 12/12, untracked', (tester) async {
      await tester.pumpWidget(buildTestWidget(buildAppBar()));

      final label = tester.widget<Text>(
        find.descendant(
          of: find.byType(GtRaisedButton),
          matching: find.text('All Accounts'),
        ),
      );
      final style = label.style!;

      expect(style.fontSize, 12);
      expect(style.height! * style.fontSize!, moreOrLessEquals(12));
      expect(style.letterSpacing, 0);
      expect(style.fontWeight, FontWeight.w600);
    });
  });

  group('avatar initials', () {
    Widget inMode(ThemeData theme, Widget child) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: theme,
          home: Scaffold(body: child),
        ),
      );
    }

    for (final (mode, theme) in [
      ('light', kPersonalTheme.materialLight),
      ('dark', kPersonalTheme.materialDark),
    ]) {
      testWidgets('the home app bar draws them white in $mode mode', (
        tester,
      ) async {
        await tester.pumpWidget(inMode(theme, buildAppBar()));

        final avatar = tester.widget<GtAvatar>(find.byType(GtAvatar));
        expect(avatar.initialsColor, palette(tester).staticColors.white);
      });

      testWidgets('the Pro app bar draws them white in $mode mode', (
        tester,
      ) async {
        await tester.pumpWidget(
          inMode(
            theme,
            GtProAppBar(
              fullName: 'Alex Lobaloba',
              businessName: 'Lobaloba Ventures',
              onClickStat: () {},
              onClickProfile: () {},
              onClickNotification: () {},
            ),
          ),
        );

        final avatar = tester.widget<GtAvatar>(find.byType(GtAvatar));
        expect(avatar.initialsColor, palette(tester).staticColors.white);
      });
    }

    testWidgets('dark text.white is not white, so it cannot stand in', (
      tester,
    ) async {
      await tester.pumpWidget(
        inMode(kPersonalTheme.materialDark, buildAppBar()),
      );

      // The reason the initials stopped using text.white: in a dark palette
      // it is near-black, meant for fills that invert with it.
      expect(
        palette(tester).text.white,
        isNot(palette(tester).staticColors.white),
      );
    });
  });

  testWidgets('leaves buttons flat unless glass is enabled', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        Row(
          mainAxisSize: .min,
          children: [
            GtIconButton(icon: GtIcons.bell, onPressed: () {}),
            GtRaisedButton(text: 'Continue', onPressed: () {}),
          ],
        ),
      ),
    );

    expect(find.byType(GtGlassSurface), findsNothing);
  });
}
