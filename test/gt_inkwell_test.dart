import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('GtInkWell', () {
    testWidgets('scales down while pressed and springs back on release', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtInkWell(
            onTap: () {},
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GtInkWell)),
      );
      await tester.pump(GtMotion.fast);

      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        .97,
      );

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
    });

    testWidgets('does not scale when reduced motion is enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: buildTestWidget(
            GtInkWell(
              onTap: () {},
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GtInkWell)),
      );
      await tester.pump();

      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
      await gesture.up();
    });

    testWidgets('fires onTap without waiting out the double-tap window', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtInkWell(
            onTap: () => taps++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.tap(find.byType(GtInkWell));
      await tester.pumpAndSettle();

      // Regression guard: forwarding every callback as a non-null closure used
      // to register a DoubleTapGestureRecognizer on every GtInkWell, delaying
      // this tap until the double-tap timer expired.
      expect(taps, 1);
    });

    testWidgets('still fires onDoubleTap when one is supplied', (tester) async {
      var doubleTaps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtInkWell(
            onTap: () {},
            onDoubleTap: () => doubleTaps++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(GtInkWell));
      await tester.tapAt(center);
      await tester.pump(kDoubleTapMinTime);
      await tester.tapAt(center);
      await tester.pumpAndSettle();

      expect(doubleTaps, 1);
    });

    testWidgets('fires onLongPress when one is supplied', (tester) async {
      var longPresses = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtInkWell(
            onTap: () {},
            onLongPress: () => longPresses++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.longPress(find.byType(GtInkWell));
      await tester.pumpAndSettle();

      expect(longPresses, 1);
    });

    testWidgets('reports tap lifecycle callbacks', (tester) async {
      var downs = 0;
      var ups = 0;
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtInkWell(
            onTap: () => taps++,
            onTapDown: (_) => downs++,
            onTapUp: (_) => ups++,
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.tap(find.byType(GtInkWell));
      await tester.pumpAndSettle();

      expect(downs, 1);
      expect(ups, 1);
      expect(taps, 1);
    });

    testWidgets('is inert when no callbacks are supplied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtInkWell(child: SizedBox(width: 100, height: 100)),
        ),
      );

      await tester.tap(find.byType(GtInkWell));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('navigation icon buttons', () {
    testWidgets('GtCancelButton uses the icon press scale', (tester) async {
      await tester.pumpWidget(buildTestWidget(GtCancelButton(onTap: () {})));

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GtInkWell)),
      );
      await tester.pump(GtMotion.fast);

      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        GtMotion.iconPressScale,
      );
      await gesture.up();
    });

    testWidgets('GtBackButton uses the icon press scale', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtBackButton(action: () {}, routeStackSensitive: false),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GtInkWell)),
      );
      await tester.pump(GtMotion.fast);

      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        GtMotion.iconPressScale,
      );
      await gesture.up();
    });
  });
}
