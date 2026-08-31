import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  group('GtMarqueeScrollPhysics', () {
    test('creates correct ballistic simulation when content overflows', () {
      const physics = GtMarqueeScrollPhysics(
        marqueeVelocity: 20.0,
        pauseDuration: Duration(seconds: 1),
      );

      final position = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 100,
        pixels: 0,
        viewportDimension: 50,
        axisDirection: AxisDirection.right,
        devicePixelRatio: 1,
      );

      // At start -> targets maxScrollExtent (100)
      final sim = physics.createBallisticSimulation(position, 0);
      expect(sim, isNotNull);

      // Initial pause at start
      expect(sim!.x(0), equals(0));
      expect(sim.x(0.5), equals(0));
      expect(sim.dx(0.5), equals(0));
      expect(sim.isDone(0.5), isFalse);

      // Scrolling at velocity 20 px/s after 1s pause
      // Total duration = 1s pause + (100px / 20px/s) = 6.0s
      expect(sim.x(3.5), equals(50)); // (3.5 - 1.0) * 20 = 50
      expect(sim.dx(3.5), equals(20));
      expect(sim.x(6.0), equals(100));
      expect(sim.isDone(6.0), isTrue);
    });

    test('reverses direction at maxScrollExtent to scroll back to start', () {
      const physics = GtMarqueeScrollPhysics(
        marqueeVelocity: 20.0,
        pauseDuration: Duration(seconds: 1),
      );

      final position = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 100,
        pixels: 100,
        viewportDimension: 50,
        axisDirection: AxisDirection.right,
        devicePixelRatio: 1,
      );

      // At max -> targets minScrollExtent (0)
      final sim = physics.createBallisticSimulation(position, 0);
      expect(sim, isNotNull);

      // Initial pause at max
      expect(sim!.x(0), equals(100));
      expect(sim.x(0.5), equals(100));
      expect(sim.dx(0.5), equals(0));

      // Scrolling back towards 0
      expect(sim.x(3.5), equals(50)); // 100 - (2.5 * 20) = 50
      expect(sim.dx(3.5), equals(-20));
      expect(sim.x(6.0), equals(0));
      expect(sim.isDone(6.0), isTrue);
    });

    test('returns null when content does not overflow', () {
      const physics = GtMarqueeScrollPhysics();

      final position = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 0,
        pixels: 0,
        viewportDimension: 100,
        axisDirection: AxisDirection.right,
        devicePixelRatio: 1,
      );

      final sim = physics.createBallisticSimulation(position, 0);
      expect(sim, isNull);
    });

    test('adjustPositionForNewDimensions triggers ballistic kick off on initial layout', () {
      const physics = GtMarqueeScrollPhysics();

      final oldPosition = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 0,
        pixels: 0,
        viewportDimension: 100,
        axisDirection: AxisDirection.right,
        devicePixelRatio: 1,
      );

      final newPosition = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 50,
        pixels: 0,
        viewportDimension: 100,
        axisDirection: AxisDirection.right,
        devicePixelRatio: 1,
      );

      final newPixels = physics.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: false,
        velocity: 0,
      );

      expect(newPixels, isNot(equals(0.0)));
    });

    testWidgets('SingleChildScrollView with GtMarqueeScrollPhysics scrolls back and forth', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const GtMarqueeScrollPhysics(
                  marqueeVelocity: 50.0,
                  pauseDuration: Duration(milliseconds: 500),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 50,
                  child: Text('Long overflowing marquee text that scrolls continuously'),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollable = find.byType(Scrollable);
      expect(scrollable, findsOneWidget);

      // Initial render: at 0
      ScrollableState state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(0, 0.01));

      // After 500ms pause: still around 0
      await tester.pump(const Duration(milliseconds: 500));
      state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(0, 0.01));

      // After 2000ms: maxScrollExtent is 200 (300 - 100).
      // Time to scroll 200px at 50px/s is 4s (4000ms).
      // At 500ms pause + 2000ms scroll: pixels should be around 100.
      await tester.pump(const Duration(milliseconds: 2000));
      state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(100, 1.0));

      // Complete forward scroll (total 500ms + 4000ms = 4500ms)
      await tester.pump(const Duration(milliseconds: 2000));
      state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(200, 1.0));

      // Reversal: after end pause (500ms) and 2000ms backward scroll -> should be around 100
      await tester.pump(const Duration(milliseconds: 2500));
      state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(100, 1.0));

      // Complete backward scroll -> back at 0
      await tester.pump(const Duration(milliseconds: 2000));
      state = tester.state(scrollable);
      expect(state.position.pixels, closeTo(0, 1.0));
    });
  });
}
