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
          child: Scaffold(body: child),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('GtAnimatedCounter rolls to a new formatted value', (
    tester,
  ) async {
    final value = ValueNotifier<num>(12);
    addTearDown(value.dispose);

    await tester.pumpWidget(
      _MotionTestApp(
        child: ValueListenableBuilder<num>(
          valueListenable: value,
          builder: (_, current, _) => GtAnimatedCounter(
            value: current,
            formatter: (number) => 'N${number.toInt()}',
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('N12'), findsOneWidget);

    value.value = 34;
    await tester.pump();
    expect(find.byType(SlideTransition), findsWidgets);

    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('N34'), findsOneWidget);
  });

  testWidgets('GtBalanceText can animate visible amount changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _MotionTestApp(
        child: GtBalanceText(amount: 12, animateChanges: true),
      ),
    );

    expect(find.byType(GtAnimatedCounter), findsOneWidget);
    expect(find.bySemanticsLabel('12.00 Naira'), findsOneWidget);

    await tester.pumpWidget(
      const _MotionTestApp(
        child: GtBalanceText(amount: 34, animateChanges: true),
      ),
    );
    await tester.pump();

    expect(find.byType(SlideTransition), findsWidgets);
    expect(find.bySemanticsLabel('34.00 Naira'), findsOneWidget);
  });

  testWidgets('GtBalanceText keeps masked balances static', (tester) async {
    await tester.pumpWidget(
      const _MotionTestApp(
        child: GtBalanceText(amount: 12, hidden: true, animateChanges: true),
      ),
    );

    expect(find.byType(GtAnimatedCounter), findsNothing);
    expect(find.bySemanticsLabel('Balance is hidden'), findsOneWidget);
  });

  testWidgets('GtBalanceText counter honors reduced motion', (tester) async {
    await tester.pumpWidget(
      const _MotionTestApp(
        disableAnimations: true,
        child: GtBalanceText(amount: 12, animateChanges: true),
      ),
    );

    await tester.pumpWidget(
      const _MotionTestApp(
        disableAnimations: true,
        child: GtBalanceText(amount: 34, animateChanges: true),
      ),
    );

    final switchers = tester.widgetList<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtAnimatedCounter),
        matching: find.byType(AnimatedSwitcher),
      ),
    );
    expect(switchers, isNotEmpty);
    expect(
      switchers.every((switcher) => switcher.duration == Duration.zero),
      isTrue,
    );
  });

  testWidgets('GtSpringShake moves after its controller is triggered', (
    tester,
  ) async {
    final controller = GtSpringShakeController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _MotionTestApp(
        child: GtSpringShake(
          controller: controller,
          child: const SizedBox(key: Key('content'), width: 20, height: 20),
        ),
      ),
    );

    controller.shake();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final transforms = tester.widgetList<Transform>(
      find.descendant(
        of: find.byType(GtSpringShake),
        matching: find.byType(Transform),
      ),
    );
    expect(
      transforms.any((item) => item.transform.getTranslation().x != 0),
      isTrue,
    );
  });

  testWidgets('GtTabbarView follows controller selection changes', (
    tester,
  ) async {
    const first = GtTabData(value: 1, label: 'First');
    const second = GtTabData(value: 2, label: 'Second');
    final controller = GtTabController<int>(initialValue: first);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _MotionTestApp(
        child: GtTabbarView<int>(
          controller: controller,
          tabs: const [first, second],
          tabViews: const {1: GtText('FIRST'), 2: GtText('SECOND')},
        ),
      ),
    );

    controller.value = second;
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('SECOND'), findsOneWidget);
  });
}
