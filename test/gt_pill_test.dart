import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _PillTestApp extends GtStatelessWidget {
  final Widget child;
  final bool disableAnimations;
  final ThemeData? theme;

  const _PillTestApp({
    required this.child,
    this.disableAnimations = false,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: theme ?? kPersonalTheme.materialLight,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('pill uses adaptive design-system motion', (tester) async {
    await tester.pumpWidget(
      const _PillTestApp(
        child: GtStatusPill(text: 'Active', variant: .success),
      ),
    );

    var container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(GtPill),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(container.duration, GtMotion.normal);
    expect(container.curve, Curves.easeOutCubic);

    await tester.pumpWidget(
      const _PillTestApp(
        disableAnimations: true,
        child: GtStatusPill(text: 'Active', variant: .success),
      ),
    );

    container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(GtPill),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(container.duration, Duration.zero);
  });

  testWidgets('interactive button pill has press treatment and tap target', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _PillTestApp(
        child: GtButtonPill(
          text: 'Filter',
          semanticsLabel: 'Filter transactions',
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.byType(GtTapTarget), findsOneWidget);
    expect(find.byType(GtInkWell), findsOneWidget);

    final inkWell = tester.widget<GtInkWell>(find.byType(GtInkWell));
    expect(inkWell.semanticsLabel, 'Filter transactions');
    expect(inkWell.role, GtSemanticRole.button);

    await tester.tap(find.byType(GtButtonPill));
    expect(taps, 1);
  });

  testWidgets('non-interactive button pill is not exposed as a button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _PillTestApp(child: GtButtonPill(text: 'Featured')),
    );

    expect(find.byType(GtTapTarget), findsNothing);
    expect(find.byType(GtInkWell), findsNothing);
    expect(find.byType(GtPill), findsOneWidget);
  });

  group('GtButtonPill styling', () {
    const red = Color(0xFFFF0000);
    const blue = Color(0xFF0000FF);

    TextStyle labelStyleOf(WidgetTester tester) =>
        tester.widget<GtText>(find.byType(GtText)).style!;

    EdgeInsetsGeometry paddingOf(WidgetTester tester) => tester
        .widget<AnimatedContainer>(find.byType(AnimatedContainer))
        .padding!;

    testWidgets('defaults to buttonXs in the variant colour', (tester) async {
      await tester.pumpWidget(
        const _PillTestApp(
          child: GtButtonPill(text: 'Add', variant: .primary),
        ),
      );
      final context = tester.element(find.byType(GtButtonPill));
      final style = labelStyleOf(tester);

      expect(style.fontSize, context.textStyles.buttonXs().fontSize);
      expect(style.color, GtPillVariant.primary.getTextColor(context.palette));
    });

    testWidgets('a custom style takes the variant colour', (tester) async {
      await tester.pumpWidget(
        _PillTestApp(
          child: Builder(
            builder: (context) => GtButtonPill(
              text: 'Add',
              variant: .primary,
              textStyle: context.textStyles.button2s(),
            ),
          ),
        ),
      );
      final context = tester.element(find.byType(GtButtonPill));
      final style = labelStyleOf(tester);

      expect(style.fontSize, context.textStyles.button2s().fontSize);
      expect(style.color, GtPillVariant.primary.getTextColor(context.palette));
    });

    testWidgets('textColor overrides the style colour', (tester) async {
      await tester.pumpWidget(
        const _PillTestApp(
          child: GtButtonPill(
            text: 'Add',
            icon: Icons.add,
            textStyle: TextStyle(color: red),
            textColor: blue,
          ),
        ),
      );

      expect(labelStyleOf(tester).color, blue);
      expect(tester.widget<Icon>(find.byType(Icon)).color, blue);
    });

    testWidgets('padding overrides the size padding', (tester) async {
      const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 4);

      await tester.pumpWidget(
        const _PillTestApp(child: GtButtonPill(text: 'Add')),
      );
      final context = tester.element(find.byType(GtButtonPill));
      expect(paddingOf(tester), context.insets.allDp(6.px));

      await tester.pumpWidget(
        const _PillTestApp(
          child: GtButtonPill(text: 'Add', padding: padding),
        ),
      );
      expect(paddingOf(tester), padding);
    });
  });

  testWidgets('pill supports a custom semantic label', (tester) async {
    await tester.pumpWidget(
      const _PillTestApp(
        child: GtStatusPill(
          text: 'KYC',
          semanticsLabel: 'Identity verification complete',
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('Identity verification complete'),
      findsOneWidget,
    );
  });

  group('GtAccountCopyPill product colours', () {
    BoxDecoration decorationOf(WidgetTester tester) {
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(GtAccountCopyPill),
              matching: find.byType(Container),
            )
            .first,
      );
      return container.decoration! as BoxDecoration;
    }

    Color textColorOf(WidgetTester tester) =>
        tester.widget<GtText>(find.byType(GtText)).style!.color!;

    Color? iconColorOf(WidgetTester tester) => tester
        .widget<Icon>(
          find.descendant(
            of: find.byType(GtAccountCopyPill),
            matching: find.byType(Icon),
          ),
        )
        .color;

    testWidgets('Pro keeps its maroon in dark mode', (tester) async {
      await tester.pumpWidget(
        _PillTestApp(
          theme: kProTheme.materialDark,
          child: const GtAccountCopyPill('0123456789', variant: .proTrailing),
        ),
      );
      final decoration = decorationOf(tester);

      expect(textColorOf(tester), GtColors.maroon700.value);
      expect(iconColorOf(tester), GtColors.maroon700.value);
      expect(decoration.color, GtColors.maroonAlpha8.value);
      expect(decoration.boxShadow!.map((shadow) => shadow.color), [
        GtColors.maroonAlpha3.value,
        GtColors.maroonAlpha15.value,
      ]);
    });

    for (final (mode, theme) in [
      ('light', kPersonalTheme.materialLight),
      ('dark', kPersonalTheme.materialDark),
    ]) {
      testWidgets('every variant takes its light tokens in $mode mode', (
        tester,
      ) async {
        const raw = GtPaletteRawColors.light();

        for (final variant in GtAccountCopyPillVariant.values) {
          await tester.pumpWidget(
            _PillTestApp(
              theme: theme,
              child: GtAccountCopyPill('0123456789', variant: variant),
            ),
          );
          final decoration = decorationOf(tester);

          expect(
            textColorOf(tester),
            variant.textColor(raw),
            reason: '$variant',
          );
          // The copy glyph is the same product colour as the number.
          expect(
            iconColorOf(tester),
            variant.textColor(raw),
            reason: '$variant',
          );
          expect(decoration.color, variant.bgColor(raw), reason: '$variant');
          expect(
            decoration.boxShadow,
            variant.shadows(raw),
            reason: '$variant',
          );
        }
      });
    }
  });

  group('GtPill border', () {
    BoxDecoration decorationOf(WidgetTester tester) {
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(GtPill),
          matching: find.byType(AnimatedContainer),
        ),
      );
      return container.decoration! as BoxDecoration;
    }

    Widget pill({Color? borderColor}) => GtPill(
      text: '50% faster',
      variant: .primary,
      bgColor: const Color(0x3D00A19A),
      borderColor: borderColor,
    );

    testWidgets('is transparent when no border color is given', (tester) async {
      await tester.pumpWidget(_PillTestApp(child: pill()));

      final border = decorationOf(tester).border! as Border;
      expect(border.top.color, GtColors.transparent.value);
    });

    testWidgets('keeps the pill size whether or not a color is given', (
      tester,
    ) async {
      await tester.pumpWidget(_PillTestApp(child: pill()));
      final withoutColor = tester.getSize(find.byType(AnimatedContainer));

      await tester.pumpWidget(
        _PillTestApp(child: pill(borderColor: const Color(0xFF00A19A))),
      );
      final withColor = tester.getSize(find.byType(AnimatedContainer));

      expect(withoutColor, withColor);
    });
  });

  group('GtPill spacing', () {
    const iconKey = Key('icon');
    const trailingKey = Key('trailing');

    Future<(double, double)> pumpGaps(
      WidgetTester tester, {
      double? spacingPx,
    }) async {
      await tester.pumpWidget(
        _PillTestApp(
          child: GtPill(
            text: 'Label',
            variant: .primary,
            bgColor: const Color(0xFFFFFFFF),
            icon: const SizedBox.square(key: iconKey, dimension: 12),
            trailing: const SizedBox.square(key: trailingKey, dimension: 12),
            spacingPx: spacingPx,
          ),
        ),
      );
      final text = find.byType(GtText);
      return (
        tester.getTopLeft(text).dx - tester.getTopRight(find.byKey(iconKey)).dx,
        tester.getTopLeft(find.byKey(trailingKey)).dx -
            tester.getTopRight(text).dx,
      );
    }

    testWidgets('defaults to the small spacing', (tester) async {
      final (leading, trailing) = await pumpGaps(tester);
      final context = tester.element(find.byType(GtPill));

      expect(leading, context.spacing.sm);
      expect(trailing, context.spacing.sm);
    });

    testWidgets('places the icon and trailing flush at zero', (tester) async {
      final (leading, trailing) = await pumpGaps(tester, spacingPx: 0);

      expect(leading, 0);
      expect(trailing, 0);
    });
  });
}
