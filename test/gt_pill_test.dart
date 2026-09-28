import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _PillTestApp extends GtStatelessWidget {
  final Widget child;
  final bool disableAnimations;

  const _PillTestApp({required this.child, this.disableAnimations = false});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: kPersonalTheme.materialLight,
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

    testWidgets('is transparent when no border color is given', (
      tester,
    ) async {
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
        tester.getTopLeft(text).dx -
            tester.getTopRight(find.byKey(iconKey)).dx,
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
