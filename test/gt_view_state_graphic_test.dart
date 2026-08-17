import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _ViewStateTestApp extends GtStatelessWidget {
  final Widget child;

  const _ViewStateTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

void main() {
  const graphicKey = Key('custom-graphic');
  const graphic = SizedBox(key: graphicKey, width: 48, height: 48);

  testWidgets('GtViewStateWidget gives graphic precedence over icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ViewStateTestApp(
        child: GtViewStateWidget(
          title: 'No results',
          icon: AppImageData(GtVectorIllustrations.empty),
          graphic: graphic,
        ),
      ),
    );

    expect(find.byKey(graphicKey), findsOneWidget);
    expect(find.byType(GtImage), findsNothing);
  });

  testWidgets('GtEmptyState forwards a custom graphic', (tester) async {
    await tester.pumpWidget(
      const _ViewStateTestApp(
        child: GtEmptyState(title: 'No results', graphic: graphic),
      ),
    );

    expect(find.byKey(graphicKey), findsOneWidget);
    expect(find.byType(GtImage), findsNothing);
  });

  testWidgets('GtStatusState supports graphics for preset variants', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ViewStateTestApp(
        child: GtStatusState.success(title: 'Complete', graphic: graphic),
      ),
    );

    expect(find.byKey(graphicKey), findsOneWidget);
    expect(find.byType(GtImage), findsNothing);
  });

  testWidgets('GtStatusState.custom accepts a graphic without an icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ViewStateTestApp(
        child: GtStatusState.custom(title: 'Maintenance', graphic: graphic),
      ),
    );

    expect(find.byKey(graphicKey), findsOneWidget);
    expect(find.byType(GtImage), findsNothing);
  });
}
