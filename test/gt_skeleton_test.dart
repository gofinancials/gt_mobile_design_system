import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _SkeletonTestApp extends GtStatelessWidget {
  final Widget child;
  final bool disableAnimations;

  const _SkeletonTestApp({required this.child, this.disableAnimations = true});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: disableAnimations),
            child: Scaffold(body: Center(child: child)),
          ),
        ),
      ),
    );
  }
}

class _Counter extends StatefulWidget {
  const _Counter({super.key});

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) => const GtText('Counter');
}

RenderGtBone _bone(WidgetTester tester, [int index = 0]) {
  return tester
      .renderObjectList<RenderGtBone>(find.byType(GtBone))
      .elementAt(index);
}

void main() {
  group('GtSkeleton', () {
    testWidgets('paints a bone in place of text while enabled', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(child: GtSkeleton(child: GtText('Balance'))),
      );

      final bone = _bone(tester);
      expect(bone, paints..rrect());
      expect(bone, isNot(paints..paragraph()));
    });

    testWidgets('paints one bar per line of text', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: SizedBox(
            width: 120,
            child: GtSkeleton(
              child: GtText(
                'A paragraph long enough to wrap across several lines here',
              ),
            ),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(
        find.byType(RichText),
      );
      final lineHeight = paragraph.getFullHeightForCaret(
        const TextPosition(offset: 0),
      );
      final lineCount = (paragraph.size.height / lineHeight).round();

      expect(lineCount, greaterThan(1));
      expect(_bone(tester), paintsExactlyCountTimes(#drawRRect, lineCount));
    });

    testWidgets('draws its child as it is when disabled', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(enabled: false, child: GtText('Balance')),
        ),
      );

      expect(find.byType(GtBone), findsNothing);
      expect(find.text('Balance'), findsOneWidget);
    });

    testWidgets('hides its subtree from assistive technology', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(
            semanticsLabel: 'Loading balance',
            child: GtText('Balance'),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Balance'), findsNothing);
      expect(find.bySemanticsLabel('Loading balance'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('absorbs taps on its subtree', (tester) async {
      var taps = 0;
      Widget button(bool enabled) => _SkeletonTestApp(
        child: GtSkeleton(
          enabled: enabled,
          child: GtInkWell(
            role: .button,
            semanticsLabel: 'Pay',
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 40),
          ),
        ),
      );

      await tester.pumpWidget(button(true));
      await tester.tap(find.byType(GtInkWell), warnIfMissed: false);
      expect(taps, 0);

      await tester.pumpWidget(button(false));
      await tester.tap(find.byType(GtInkWell));
      expect(taps, 1);
    });

    testWidgets('keeps its subtree state when toggled', (tester) async {
      final key = GlobalKey<_CounterState>();

      await tester.pumpWidget(
        _SkeletonTestApp(
          child: GtSkeleton(child: _Counter(key: key)),
        ),
      );
      final state = key.currentState;

      await tester.pumpWidget(
        _SkeletonTestApp(
          child: GtSkeleton(enabled: false, child: _Counter(key: key)),
        ),
      );

      expect(key.currentState, same(state));
    });

    testWidgets('sweeps while animations are enabled', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          disableAnimations: false,
          child: GtSkeleton(child: GtText('Balance')),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.binding.hasScheduledFrame, isTrue);
      expect(_bone(tester).scope?.animate, isTrue);
    });

    testWidgets('holds still when the user asks to reduce motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(child: GtSkeleton(child: GtText('Balance'))),
      );
      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(_bone(tester).scope?.animate, isFalse);
    });

    testWidgets('a nested skeleton joins its parent sweep', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          disableAnimations: false,
          child: GtSkeleton(
            child: Column(
              mainAxisSize: .min,
              children: [
                GtText('Outer'),
                GtSkeleton(child: GtText('Inner')),
              ],
            ),
          ),
        ),
      );

      final outer = _bone(tester, 0).scope!;
      final inner = _bone(tester, 1).scope!;
      expect(inner.sweep, same(outer.sweep));
      expect(inner.frame, same(outer.frame));
    });

    testWidgets('a disabled skeleton keeps its subtree real inside one', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(
            child: Column(
              mainAxisSize: .min,
              children: [
                GtText('Boned'),
                GtSkeleton(enabled: false, child: GtText('Real')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GtBone), findsOneWidget);
      expect(
        find.ancestor(of: find.text('Real'), matching: find.byType(GtBone)),
        findsNothing,
      );
    });
  });

  group('atoms in a skeleton', () {
    testWidgets('icons and images paint blocks', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(
            child: Row(
              mainAxisSize: .min,
              children: [
                GtIcon(GtIcons.anchor),
                GtAssetImage(GtAssetImages.avatar, width: 40, height: 40),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GtBone), findsNWidgets(2));
      expect(_bone(tester, 0), paintsExactlyCountTimes(#drawRRect, 1));
      expect(_bone(tester, 1), paintsExactlyCountTimes(#drawRRect, 1));
    });

    testWidgets('controls paint in their own shape', (tester) async {
      await tester.pumpWidget(
        _SkeletonTestApp(
          child: GtSkeleton(
            child: Row(
              mainAxisSize: .min,
              children: [
                GtRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
                GtSwitch(value: true, onChanged: (_) {}),
              ],
            ),
          ),
        ),
      );

      final radio = tester.widget<GtBone>(
        find.descendant(
          of: find.byType(GtRadio<int>),
          matching: find.byType(GtBone),
        ),
      );
      final toggle = tester.widget<GtBone>(
        find.descendant(
          of: find.byType(GtSwitch),
          matching: find.byType(GtBone),
        ),
      );
      expect(radio.shape, BoxShape.circle);
      expect(toggle.shape, BoxShape.rectangle);
    });
  });

  group('GtImageShimmer', () {
    testWidgets('runs a skeleton of its own when it stands alone', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(child: GtImageShimmer(width: 40, height: 40)),
      );

      expect(find.byType(GtSkeleton), findsOneWidget);
      expect(tester.getSize(find.byType(GtBone)), const Size(40, 40));
    });

    testWidgets('joins an enclosing skeleton', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: GtSkeleton(child: GtImageShimmer(width: 40, height: 40)),
        ),
      );

      expect(find.byType(GtSkeleton), findsOneWidget);
    });

    testWidgets('fills a bounded axis left null', (tester) async {
      await tester.pumpWidget(
        const _SkeletonTestApp(
          child: SizedBox(width: 200, child: GtImageShimmer(height: 40)),
        ),
      );

      expect(tester.getSize(find.byType(GtBone)), const Size(200, 40));
    });
  });

  group('GtSkeletonList', () {
    testWidgets('clips rows that do not fit instead of overflowing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _SkeletonTestApp(
          child: SizedBox(
            height: 100,
            child: GtSkeletonList(
              itemCount: 20,
              itemBuilder: (_, i) =>
                  const SizedBox(height: 40, child: GtText('Row')),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(GtSkeleton), findsOneWidget);
    });

    testWidgets('builds a lazy sliver, announced once', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _SkeletonTestApp(
          child: CustomScrollView(
            slivers: [
              GtSkeletonList.sliver(
                itemCount: 1000,
                semanticsLabel: 'Loading rows',
                itemBuilder: (_, i) =>
                    SizedBox(height: 40, child: GtText('Row $i')),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Row 0'), findsOneWidget);
      expect(find.text('Row 999'), findsNothing);
      expect(find.bySemanticsLabel('Loading rows'), findsOneWidget);
      semantics.dispose();
    });
  });
}
