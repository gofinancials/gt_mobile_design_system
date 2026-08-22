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
}
