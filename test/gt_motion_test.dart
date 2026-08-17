import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _MotionTestApp extends GtStatelessWidget {
  final Widget child;

  const _MotionTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
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

  testWidgets('GtTabbarView animates when the selected tab changes', (
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
          tabViews: const {1: GtText('FIRST'), 2: GtText('SECOND')},
        ),
      ),
    );

    controller.value = second;
    await tester.pump();

    expect(find.byType(SlideTransition), findsWidgets);
    expect(find.text('SECOND'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('FIRST'), findsNothing);
  });
}
