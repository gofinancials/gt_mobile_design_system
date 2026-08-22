import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

const _firstTab = GtTabData(value: 'first', label: 'One');
const _secondTab = GtTabData(value: 'second', label: 'A much wider second tab');

class _TabBarMotionTestApp extends GtStatelessWidget {
  final GtTabController<String> controller;
  final bool disableAnimations;
  final bool enableIndicatorAnimation;

  const _TabBarMotionTestApp({
    required this.controller,
    this.disableAnimations = false,
    this.enableIndicatorAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            body: GtSelectionTabbar<String>(
              controller: controller,
              enableIndicatorAnimation: enableIndicatorAnimation,
              tabs: const [_firstTab, _secondTab],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('shared indicator glides across variable-width tabs', (
    tester,
  ) async {
    final controller = GtTabController<String>(initialValue: _firstTab);
    addTearDown(controller.dispose);
    await tester.pumpWidget(_TabBarMotionTestApp(controller: controller));
    await tester.pump();

    final initialIndicator = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('gt_selection_tab_indicator')),
    );
    final initialLeft = initialIndicator.left!;
    final initialWidth = initialIndicator.width!;
    final tabPills = tester.widgetList<GtTabPill<GtTabData<String>>>(
      find.byType(GtTabPill<GtTabData<String>>),
    );
    expect(tabPills.every((pill) => !pill.showSelectedBackground), isTrue);

    controller.value = _secondTab;
    await tester.pump();
    await tester.pump();

    final movedIndicator = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('gt_selection_tab_indicator')),
    );
    expect(movedIndicator.duration, GtMotion.fluid);
    expect(movedIndicator.curve, GtSpringCurves.snappy);
    expect(movedIndicator.left, greaterThan(initialLeft));
    expect(movedIndicator.width, greaterThan(initialWidth));

    await tester.pumpAndSettle();
    expect(find.text('A MUCH WIDER SECOND TAB'), findsOneWidget);
  });

  testWidgets('shared indicator honors opt-out and reduced motion', (
    tester,
  ) async {
    final controller = GtTabController<String>(initialValue: _firstTab);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _TabBarMotionTestApp(
        controller: controller,
        enableIndicatorAnimation: false,
      ),
    );
    await tester.pump();

    var indicator = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('gt_selection_tab_indicator')),
    );
    expect(indicator.duration, Duration.zero);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      _TabBarMotionTestApp(controller: controller, disableAnimations: true),
    );
    await tester.pump();
    indicator = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('gt_selection_tab_indicator')),
    );
    expect(indicator.duration, Duration.zero);
  });
}
