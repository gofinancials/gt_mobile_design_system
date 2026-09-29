import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _MotionTestApp extends GtStatelessWidget {
  final Widget child;
  final bool disableAnimations;

  const _MotionTestApp({required this.child, this.disableAnimations = false});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }
}

Matrix4 _spinnerRotation(WidgetTester tester) {
  final transform = find.descendant(
    of: find.byType(GtSpinner),
    matching: find.byType(Transform),
  );
  return tester.widget<Transform>(transform).transform;
}

void main() {
  group('GtSpinner', () {
    testWidgets('keeps turning while animations are enabled', (tester) async {
      await tester.pumpWidget(const _MotionTestApp(child: GtSpinner()));
      final before = _spinnerRotation(tester);

      await tester.pump(const Duration(milliseconds: 250));

      expect(_spinnerRotation(tester), isNot(before));
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('holds a still arc when animations are disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _MotionTestApp(disableAnimations: true, child: GtSpinner()),
      );
      final before = _spinnerRotation(tester);

      await tester.pumpAndSettle();

      expect(find.byType(GtSpinner), findsOneWidget);
      expect(_spinnerRotation(tester), before);
    });

    testWidgets('resumes turning when animations are re-enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _MotionTestApp(disableAnimations: true, child: GtSpinner()),
      );
      await tester.pumpAndSettle();
      final before = _spinnerRotation(tester);

      await tester.pumpWidget(const _MotionTestApp(child: GtSpinner()));
      await tester.pump(const Duration(milliseconds: 250));

      expect(_spinnerRotation(tester), isNot(before));
    });

    testWidgets('settles under the platform accessibility setting', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: const MaterialApp(home: Scaffold(body: GtSpinner())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtSpinner), findsOneWidget);
    });
  });

  group('GtProgress while indeterminate', () {
    testWidgets('keeps sweeping while animations are enabled', (tester) async {
      await tester.pumpWidget(const _MotionTestApp(child: GtProgress()));
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets(
      'settles and still reads as busy when animations are disabled',
      (tester) async {
        await tester.pumpWidget(
          const _MotionTestApp(disableAnimations: true, child: GtProgress()),
        );
        await tester.pumpAndSettle();

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.value, isNull);
      },
    );
  });

  group('GtNetworkImage with its default spinner', () {
    testWidgets('settles on a request that never completes', (tester) async {
      await tester.pumpWidget(
        const _MotionTestApp(
          disableAnimations: true,
          child: GtNetworkImage(GtNetworkImages.savings),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtSpinner), findsOneWidget);
    });
  });
}
