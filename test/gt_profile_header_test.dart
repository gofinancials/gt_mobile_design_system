import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  GtText textOf(WidgetTester tester, String data) =>
      tester.widget<GtText>(find.widgetWithText(GtText, data));

  group('GtProfileHeader', () {
    testWidgets('lays out the title, subtitle and initials to spec', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtProfileHeader(
            title: 'Foluke Collins',
            subtitle: 'foluke.c@gmail.com • Active',
          ),
        ),
      );
      final context = tester.element(find.byType(GtProfileHeader));
      final palette = context.palette;

      expect(
        textOf(tester, 'FOLUKE COLLINS').style,
        context.textStyles.h5(heightPx: 24, color: palette.text.strong),
      );
      expect(
        textOf(tester, 'foluke.c@gmail.com • Active').style,
        context.textStyles.bodyXs(weight: .w500, color: palette.text.sub),
      );

      final avatar = tester.widget<GtAvatar>(find.byType(GtAvatar));
      expect(avatar.initials, 'FC');
      expect(avatar.size, context.dp(48.px));
      expect(
        avatar.initialsStyle,
        context.textStyles.h5(color: palette.primary.darker),
      );
      expect(find.byType(GtPill), findsNothing);
    });

    testWidgets('prefers explicit initials over the title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtProfileHeader(title: 'Foluke Collins', initials: 'FO'),
        ),
      );

      expect(tester.widget<GtAvatar>(find.byType(GtAvatar)).initials, 'FO');
    });

    testWidgets('draws the tag in an uppercased pill below the row', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtProfileHeader(title: 'Foluke Collins', tag: 'Account owner'),
        ),
      );
      final context = tester.element(find.byType(GtProfileHeader));

      final pill = tester.widget<GtPill>(find.byType(GtPill));
      expect(pill.text, 'ACCOUNT OWNER');
      expect(pill.bgColor, context.palette.primary.alpha10);
      expect(pill.textColor, context.palette.text.strong);
      expect(
        tester.getTopLeft(find.byType(GtPill)).dy,
        greaterThan(tester.getBottomLeft(find.text('FOLUKE COLLINS')).dy),
      );
    });

    testWidgets('only makes the avatar tappable with a callback', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        buildTestWidget(
          GtProfileHeader(title: 'Foluke Collins', onClickAvatar: () => taps++),
        ),
      );

      await tester.tap(find.byType(GtAvatar));
      expect(taps, 1);
    });
  });

  group('GtProfileHeroHeader', () {
    testWidgets('draws the user glyph avatar and uppercased name', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const GtProfileHeroHeader(name: 'Alex Lobaloba')),
      );
      final context = tester.element(find.byType(GtProfileHeroHeader));

      final avatar = tester.widget<GtSquareAvatar>(find.byType(GtSquareAvatar));
      expect(avatar.isUserAvatar, isTrue);
      expect(avatar.size, context.dp(64.px));
      expect(avatar.bgColor, context.palette.bg.soft);
      expect(
        textOf(tester, 'ALEX LOBALOBA').style,
        context.textStyles.d4(heightPx: 32),
      );
      expect(find.byType(GtPill), findsNothing);
    });

    testWidgets('shows a plain account pill without a switch callback', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtProfileHeroHeader(
            name: 'Alex Lobaloba',
            accountName: 'Funmilola Consulting Ltd',
          ),
        ),
      );

      final pill = tester.widget<GtPill>(find.byType(GtPill));
      expect(pill.text, 'FUNMILOLA CONSULTING LTD');
      expect(pill.trailing, isNull);
      expect(
        tester
            .widget<GtAvatar>(
              find.descendant(
                of: find.byType(GtPill),
                matching: find.byType(GtAvatar),
              ),
            )
            .initials,
        'Funmilola Consulting Ltd'.initials,
      );
      expect(find.byType(GtTapTarget), findsNothing);
    });

    testWidgets('prefers explicit account initials over the account name', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtProfileHeroHeader(
            name: 'Alex Lobaloba',
            accountName: 'Funmilola Consulting Ltd',
            accountInitials: 'FC',
          ),
        ),
      );

      expect(
        tester
            .widget<GtAvatar>(
              find.descendant(
                of: find.byType(GtPill),
                matching: find.byType(GtAvatar),
              ),
            )
            .initials,
        'FC',
      );
    });

    testWidgets('makes the account pill a switcher button with a callback', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        buildTestWidget(
          GtProfileHeroHeader(
            name: 'Alex Lobaloba',
            accountName: 'Funmilola Consulting Ltd',
            onSwitchAccount: () => taps++,
          ),
        ),
      );

      expect(tester.widget<GtPill>(find.byType(GtPill)).trailing, isNotNull);
      expect(find.byType(GtTapTarget), findsOneWidget);

      await tester.tap(find.byType(GtPill));
      expect(taps, 1);
    });
  });
}
