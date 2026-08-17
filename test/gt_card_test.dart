import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class _CardTestApp extends GtStatelessWidget {
  final Widget child;

  const _CardTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}

void main() {
  testWidgets('GtCard forwards its default motion configuration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _CardTestApp(
        child: GtCard(onPressed: () {}, child: const GtText('CARD')),
      ),
    );

    final inkWell = tester.widget<GtInkWell>(find.byType(GtInkWell));
    expect(inkWell.enableScaleEffect, isTrue);
    expect(inkWell.pressedScale, GtMotion.cardPressScale);
    expect(inkWell.hapticFeedbackType, HapticFeedbackType.medium);
  });

  testWidgets('GtCard forwards custom motion configuration', (tester) async {
    await tester.pumpWidget(
      _CardTestApp(
        child: GtCard(
          onPressed: () {},
          enableScaleEffect: false,
          pressedScale: .9,
          child: const GtText('CARD'),
        ),
      ),
    );

    final inkWell = tester.widget<GtInkWell>(find.byType(GtInkWell));
    expect(inkWell.enableScaleEffect, isFalse);
    expect(inkWell.pressedScale, .9);
  });
}
