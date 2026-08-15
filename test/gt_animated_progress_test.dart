import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// The fill the bar is currently painting.
double _paintedValue(WidgetTester tester) {
  // The track underneath paints too, so pick the layer driven by the fill.
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(GtAnimatedProgress),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.foregroundPainter is GtProgressPainter,
      ),
    ),
  );

  return (paint.foregroundPainter as GtProgressPainter).value;
}

Widget _wrap(Widget child) {
  return GtThemeProvider(
    theme: kPersonalTheme,
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  setUpAll(registerTestAppConfig);

  group('GtAnimatedProgress', () {
    testWidgets('fills from zero to the initial value', (tester) async {
      await tester.pumpWidget(_wrap(const GtAnimatedProgress(value: .4)));

      expect(_paintedValue(tester), 0);

      await tester.pumpAndSettle();

      expect(_paintedValue(tester), closeTo(.4, .0001));
    });

    testWidgets('animates on to a new value without being re-keyed', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const GtAnimatedProgress(value: .4)));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_wrap(const GtAnimatedProgress(value: .8)));

      // Picks up where the previous fill stopped rather than snapping back to
      // zero, which is what a caller re-keying the widget used to get.
      expect(_paintedValue(tester), closeTo(.4, .0001));

      await tester.pump(const Duration(milliseconds: 150));

      expect(_paintedValue(tester), greaterThan(.4));
      expect(_paintedValue(tester), lessThan(.8));

      await tester.pumpAndSettle();

      expect(_paintedValue(tester), closeTo(.8, .0001));
    });

    testWidgets('animates back down when the value drops', (tester) async {
      await tester.pumpWidget(_wrap(const GtAnimatedProgress(value: .9)));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_wrap(const GtAnimatedProgress(value: .3)));
      await tester.pumpAndSettle();

      expect(_paintedValue(tester), closeTo(.3, .0001));
    });

    testWidgets('reports completion once the bar is full', (tester) async {
      var completions = 0;

      await tester.pumpWidget(
        _wrap(GtAnimatedProgress(value: .5, onDone: () => completions++)),
      );
      await tester.pumpAndSettle();

      expect(completions, 0);

      await tester.pumpWidget(
        _wrap(GtAnimatedProgress(value: 1, onDone: () => completions++)),
      );
      await tester.pumpAndSettle();

      expect(completions, greaterThan(0));
    });
  });
}
