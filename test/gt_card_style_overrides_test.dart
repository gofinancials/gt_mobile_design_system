import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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
  Widget app(Widget child, {bool dark = false, double scale = 1}) =>
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: dark
              ? kPersonalTheme.materialDark
              : kPersonalTheme.materialLight,
          home: Scaffold(
            body: MediaQuery.withClampedTextScaling(
              minScaleFactor: scale,
              maxScaleFactor: scale,
              child: Center(child: SizedBox(width: 380, child: child)),
            ),
          ),
        ),
      );
  GtCard card(WidgetTester tester) =>
      tester.widget<GtCard>(find.byType(GtCard).first);
  TextStyle textStyle(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text).first).style!;

  test(
    'style replacement and explicit colour precedence preserve other properties',
    () {
      final fallback = TextStyle(fontSize: 12, color: other);
      expect(
        identical(GtTextStyleOverrides.resolve(null, fallback, null), fallback),
        isTrue,
      );
      expect(
        identical(
          GtTextStyleOverrides.resolve(customStyle, fallback, null),
          customStyle,
        ),
        isTrue,
      );
      final resolved = GtTextStyleOverrides.resolve(
        customStyle,
        fallback,
        custom,
      );
      expect(resolved.fontSize, 19);
      expect(resolved.fontWeight, FontWeight.w700);
      expect(resolved.color, custom);
      final painted = GtTextStyleOverrides.resolve(
        TextStyle(foreground: Paint()..color = other),
        fallback,
        custom,
      );
      expect(painted.foreground!.color.toARGB32(), custom.toARGB32());
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      'help defaults preserve variant and error exception, dark=$dark',
      (tester) async {
        for (final variant in GtCardVariant.values) {
          await tester.pumpWidget(
            app(
              GtHelpCard(title: 'Help', subtitle: 'Support', variant: variant),
              dark: dark,
            ),
          );
          final context = tester.element(find.byType(GtHelpCard));
          final palette = context.palette;
          final icon = tester.widget<Icon>(find.byType(Icon));
          expect(
            icon.color,
            variant == GtCardVariant.error
                ? palette.text.strong
                : variant.getIconColor(palette),
          );
          final decoration =
              tester
                      .widget<AnimatedContainer>(
                        find.byType(AnimatedContainer).first,
                      )
                      .decoration!
                  as ShapeDecoration;
          expect(decoration.color, variant.getBgColor(palette));
          expect(
            (decoration.shape as RoundedRectangleBorder).side,
            BorderSide.none,
          );
          expect(textStyle(tester, 'Help'), context.textStyles.bodyM());
          expect(
            textStyle(tester, 'Support'),
            context.textStyles.bodyXs(color: palette.text.soft),
          );
        }
      },
    );
  }

  testWidgets('help overrides are independent and accept zero layout values', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtHelpCard(
          title: 'Help',
          subtitle: 'Support',
          backgroundColor: custom,
          iconColor: other,
          titleStyle: customStyle,
          titleColor: custom,
          subtitleColor: other,
          padding: EdgeInsets.zero,
          horizontalSpacing: 0,
          verticalSpacing: 0,
        ),
      ),
    );
    expect(card(tester).color, custom);
    expect(card(tester).padding, EdgeInsets.zero);
    expect(card(tester).border, isNull);
    expect(textStyle(tester, 'Help').fontSize, 19);
    expect(textStyle(tester, 'Help').color, custom);
    expect(textStyle(tester, 'Support').color, other);
    final tile = tester.widget<GtBaseListTileTemplate>(
      find.byType(GtBaseListTileTemplate),
    );
    expect(tile.spacing, 0);
    expect(tile.spacingToSubTitle, 0);
  });

  testWidgets(
    'inbox separates title, subtitle, count and unread badge styling',
    (tester) async {
      await tester.pumpWidget(
        app(
          GtInboxCard(
            title: 'Inbox',
            subtitle: 'Message',
            ureadCount: 2,
            messageCount: 5,
            backgroundColor: custom,
            titleStyle: customStyle,
            subtitleColor: other,
            messageCountColor: custom,
            unreadBackgroundColor: other,
            unreadTextColor: custom,
            unreadTextStyle: customStyle,
            padding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            horizontalSpacing: 0,
            verticalSpacing: 0,
          ),
        ),
      );
      expect(card(tester).color, custom);
      expect(card(tester).border, isNull);
      expect(textStyle(tester, 'Inbox'), customStyle);
      expect(textStyle(tester, 'Message').color, other);
      expect(textStyle(tester, '5').color, custom);
      expect(textStyle(tester, '2').color, custom);
      final badge = tester.widget<GtCountIndicator>(
        find.byType(GtCountIndicator),
      );
      expect(badge.backgroundColor, other);
      expect(badge.style, customStyle);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('instruction border colour never creates a filled-mode border', (
    tester,
  ) async {
    for (final filled in [false, true]) {
      await tester.pumpWidget(
        app(
          GtInstructionCard(
            icon: const Icon(Icons.add),
            title: 'Upload',
            description: 'Document',
            onPressed: () {},
            isFilled: filled,
            borderColor: custom,
            backgroundColor: other,
            titleStyle: customStyle,
            descriptionColor: custom,
            padding: EdgeInsets.zero,
            verticalSpacing: 0,
            iconSpacing: 0,
          ),
        ),
      );
      expect(card(tester).color, other);
      expect(
        card(tester).border!.style,
        filled ? BorderStyle.none : BorderStyle.solid,
      );
      if (!filled) {
        expect(card(tester).border!.color, custom);
        expect(card(tester).border!.width, 1.5);
      }
      expect(textStyle(tester, 'Document').color, custom);
    }
  });

  testWidgets('selection colour applies only while selected', (tester) async {
    for (final selected in [false, true]) {
      await tester.pumpWidget(
        app(
          GtSelectableCard(
            selected: selected,
            value: 1,
            onSelect: (_) {},
            borderColor: custom,
            padding: EdgeInsets.zero,
            child: const SizedBox(width: 100, height: 50),
          ),
        ),
      );
      expect(
        card(tester).border!.style,
        selected ? BorderStyle.solid : BorderStyle.none,
      );
      if (selected) {
        expect(card(tester).border!.width, 2);
        expect(card(tester).border!.color, custom);
      }
    }
  });

  testWidgets('address border style remains authoritative', (tester) async {
    await tester.pumpWidget(
      app(
        GtAddressCard(
          line1: 'Address',
          line2: 'Lagos',
          borderColor: custom,
          borderStyle: BorderStyle.none,
          line1Style: customStyle,
          line2Color: custom,
        ),
      ),
    );
    expect(card(tester).border!.style, BorderStyle.none);
    expect(textStyle(tester, 'Address'), customStyle);
    expect(textStyle(tester, 'Lagos').color, custom);
  });

  testWidgets('all action constructors forward card styling', (tester) async {
    final widgets = [
      GtActionCard(
        title: 'Action',
        subtitle: 'Details',
        icon: Icons.add,
        onActionTap: () {},
        actionText: 'Go',
        titleStyle: customStyle,
        backgroundColor: custom,
        padding: EdgeInsets.zero,
        actionSpacing: 0,
      ),
      GtActionCard.dismissible(
        title: 'Action',
        subtitle: 'Details',
        icon: Icons.add,
        onActionTap: () {},
        actionText: 'Go',
        onDismiss: () {},
        dismissText: 'Later',
        titleStyle: customStyle,
        backgroundColor: custom,
        padding: EdgeInsets.zero,
        actionSpacing: 0,
      ),
      GtActionCard.dismissibleTrailing(
        title: 'Action',
        subtitle: 'Details',
        trailing: const Icon(Icons.add),
        onActionTap: () {},
        actionText: 'Go',
        onDismiss: () {},
        dismissText: 'Later',
        titleStyle: customStyle,
        backgroundColor: custom,
        padding: EdgeInsets.zero,
        actionSpacing: 0,
      ),
    ];
    for (final widget in widgets) {
      await tester.pumpWidget(app(widget));
      expect(card(tester).color, custom);
      expect(card(tester).padding, EdgeInsets.zero);
      expect(textStyle(tester, 'Action'), customStyle);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('payment-source styles reach the nested account and balance', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtPaymentSourceCard(
          title: 'Account',
          accountDetail: '12345',
          balance: '100',
          icon: const Icon(Icons.add),
          accountDetailStyle: customStyle,
          balanceColor: custom,
          horizontalSpacing: 0,
          balanceSpacing: 0,
        ),
      ),
    );
    expect(textStyle(tester, '12345'), customStyle);
    expect(textStyle(tester, '100').color, custom);
    final tile = tester.widget<GtTransactionParticipantListTile>(
      find.byType(GtTransactionParticipantListTile),
    );
    expect(tile.horizontalSpacing, 0);
    expect((tile.subSpacer! as SizedBox).height, 0);
  });

  testWidgets('progress fill override does not change percentage text', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtProgressCard(
          title: 'Progress',
          subtitle: 'Details',
          maxValue: 100,
          currentValue: 30,
          continueText: 'Go',
          onContinue: () {},
          percentSubtext: 'Complete',
          variant: GtCardVariant.away,
          progressColor: custom,
        ),
      ),
    );
    final context = tester.element(find.byType(GtProgressCard));
    expect(
      textStyle(tester, '30%').color,
      GtCardVariant.away.getProgressColor(context.palette),
    );
    expect(
      tester
          .widget<GtAnimatedProgress>(find.byType(GtAnimatedProgress))
          .valueColor,
      custom,
    );
  });

  testWidgets('card-list padding override preserves positional radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtCardListTile(
          type: GtCardListTileType.starter,
          backgroundColor: custom,
          padding: EdgeInsets.zero,
          child: const GtText('Row'),
        ),
      ),
    );
    final context = tester.element(find.byType(GtCardListTile));
    expect(card(tester).padding, EdgeInsets.zero);
    expect(
      card(tester).borderRadius,
      GtCardListTileType.starter.borderRadius(context),
    );
    expect(card(tester).border, isNull);
  });

  testWidgets(
    'card spacing preserves token defaults and accepts explicit values',
    (tester) async {
      for (final spacing in <double?>[null, 0, 17]) {
        await tester.pumpWidget(
          app(
            GtInstructionCard(
              title: 'Upload',
              description: 'Document',
              onPressed: () {},
              icon: const Icon(Icons.add, key: Key('instruction-icon')),
              padding: EdgeInsets.zero,
              verticalSpacing: 0,
              iconSpacing: spacing,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(GtInstructionCard));
        final expected =
            spacing ?? context.dp(const GtGap.yMd().getGap(context).px);
        final gap =
            tester.getTopLeft(find.text('Upload')).dy -
            tester.getBottomLeft(find.byKey(const Key('instruction-icon'))).dy;
        expect(gap, closeTo(expected, .001));
        expect(
          find.byType(GtGap),
          spacing == null ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('summary forwards surface and row text overrides', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtSummaryBody(
          amount: '100',
          cardBackgroundColor: custom,
          cardPadding: EdgeInsets.zero,
          labelColor: other,
          valueStyle: customStyle,
          sections: const [
            GtSummarySection(
              tiles: [GtSummaryTileData(label: 'Fee', value: 'Free')],
            ),
          ],
        ),
      ),
    );
    expect(card(tester).color, custom);
    expect(card(tester).padding, EdgeInsets.zero);
    expect(textStyle(tester, 'Fee').color, other);
    expect(textStyle(tester, 'Free'), customStyle);
  });

  testWidgets('help custom typography accommodates larger text', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        GtHelpCard(
          title: 'Need help?',
          subtitle: 'Talk to our support team',
          titleStyle: customStyle,
          verticalSpacing: 0,
        ),
        scale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
