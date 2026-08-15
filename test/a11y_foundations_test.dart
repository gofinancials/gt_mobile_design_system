import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/semantics_matchers.dart';

void main() {
  Widget buildTestWidget(Widget child, {MediaQueryData? mediaQuery}) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: mediaQuery ?? const MediaQueryData(),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  group('GtSemantics', () {
    testWidgets('maps the checkbox role onto a checked state, not a button', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtSemantics(
              role: .checkbox,
              label: 'Remember me',
              isChecked: true,
              child: SizedBox(width: 20, height: 20),
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtSemantics),
          label: 'Remember me',
          isChecked: true,
          // Regression guard: these used to announce as plain buttons, which
          // gave the user no way to hear whether they were checked.
          isButton: false,
        );
      });
    });

    testWidgets('marks radios as members of a mutually exclusive group', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtSemantics(
              role: .radio,
              label: 'Savings',
              isChecked: false,
              child: SizedBox(width: 20, height: 20),
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtSemantics),
          isChecked: false,
          isInMutuallyExclusiveGroup: true,
          isButton: false,
        );
      });
    });

    testWidgets('does not claim an enabled state for non-interactive roles', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtSemantics(
              label: 'Account balance',
              child: SizedBox(width: 20, height: 20),
            ),
          ),
        );

        final data = semanticsDataOf(tester, find.byType(GtSemantics));
        expect(
          data.flagsCollection.isEnabled.toBoolOrNull(),
          isNull,
          reason: 'static content should not announce an enabled state',
        );
      });
    });
  });

  group('GtDisabledScope', () {
    testWidgets('makes an enclosed control announce as disabled', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtDisabledOverlay(
              true,
              child: GtInkWell(
                semanticsLabel: 'Continue',
                child: SizedBox(width: 100, height: 40),
              ),
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtInkWell),
          label: 'Continue',
          isEnabled: false,
        );
      });
    });

    testWidgets('emits a single merged node rather than one per annotation', (
      tester,
    ) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtDisabledOverlay(
              true,
              child: GtInkWell(
                semanticsLabel: 'Continue',
                child: SizedBox(width: 100, height: 40),
              ),
            ),
          ),
        );

        // Annotating the disabled state on the overlay itself would collide
        // with the control's own enabled flag, and Flutter refuses to merge
        // configurations whose flags conflict. The result would be one control
        // announced as two nodes.
        final node = tester.getSemantics(find.byType(GtInkWell));
        expect(node.childrenCount, 0);
      });
    });

    testWidgets('leaves controls enabled when not disabled', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            GtInkWell(
              semanticsLabel: 'Continue',
              onTap: () {},
              child: const SizedBox(width: 100, height: 40),
            ),
          ),
        );

        expectSemantics(
          tester,
          find.byType(GtInkWell),
          isEnabled: true,
          hasTapAction: true,
        );
      });
    });
  });

  group('GtTapTarget', () {
    testWidgets('accepts touches outside the painted bounds', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtTapTarget(
            child: GtInkWell(
              onTap: () => taps++,
              child: const SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(GtTapTarget));

      // 18px from centre is well outside the 20x20 control but inside the
      // 44x44 minimum touch target.
      await tester.tapAt(center + const Offset(18, 0));
      await tester.pumpAndSettle();
      expect(taps, 1, reason: 'horizontal slop should be tappable');

      await tester.tapAt(center + const Offset(0, -18));
      await tester.pumpAndSettle();
      expect(taps, 2, reason: 'vertical slop should be tappable');
    });

    testWidgets('does not change the layout size of its child', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const GtTapTarget(child: SizedBox(width: 20, height: 20)),
        ),
      );

      // The whole point of the hit-slop approach: visuals and layout are
      // untouched, only the responsive area grows.
      expect(tester.getSize(find.byType(GtTapTarget)), const Size(20, 20));
    });

    testWidgets('ignores touches beyond the minimum target', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestWidget(
          GtTapTarget(
            child: GtInkWell(
              onTap: () => taps++,
              child: const SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(GtTapTarget));
      await tester.tapAt(center + const Offset(40, 0));
      await tester.pumpAndSettle();

      expect(taps, 0);
    });

    testWidgets('satisfies the minimum tap target matcher', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GtTapTarget(
            child: GtInkWell(
              onTap: () {},
              child: const SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      );

      expectMinimumTapTarget(tester, find.byType(GtTapTarget));
    });
  });

  group('GtLiveRegion', () {
    testWidgets('marks its subtree as a live region', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtLiveRegion(child: Text('Transfer successful')),
          ),
        );

        expectSemantics(tester, find.byType(GtLiveRegion), isLiveRegion: true);
      });
    });

    testWidgets('adds nothing while disabled', (tester) async {
      await withSemantics(tester, () async {
        await tester.pumpWidget(
          buildTestWidget(
            const GtLiveRegion(
              enabled: false,
              child: Text('Transfer successful'),
            ),
          ),
        );

        final data = semanticsDataOf(tester, find.text('Transfer successful'));
        expect(data.flagsCollection.isLiveRegion, isFalse);
      });
    });
  });

  group('reduce motion', () {
    testWidgets('collapses durations when the platform asks for it', (
      tester,
    ) async {
      late Duration reduced;
      late Duration standard;

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              reduced = context.motionDuration(const Duration(seconds: 1));
              return const SizedBox.shrink();
            },
          ),
          mediaQuery: const MediaQueryData(disableAnimations: true),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              standard = context.motionDuration(const Duration(seconds: 1));
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(reduced, Duration.zero);
      expect(standard, const Duration(seconds: 1));
    });
  });
}
