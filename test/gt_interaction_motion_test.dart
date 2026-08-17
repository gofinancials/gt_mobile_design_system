import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class _AdaptiveSwitcherTestApp extends GtStatelessWidget {
  final bool disableAnimations;

  const _AdaptiveSwitcherTestApp({required this.disableAnimations});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Column(
            children: [
              GtAnimatedSwitcher(
                key: const Key('scale-switcher'),
                child: const SizedBox(key: ValueKey('scale-child')),
              ),
              GtAnimatedSlider(
                key: const Key('size-switcher'),
                child: const SizedBox(key: ValueKey('size-child')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationTestApp extends GtStatelessWidget {
  final int currentIndex;
  final bool disableAnimations;
  final bool enableSelectionAnimation;

  const _BottomNavigationTestApp({
    required this.currentIndex,
    this.disableAnimations = false,
    this.enableSelectionAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            bottomNavigationBar: GtBottomNavigationBar(
              style: .ios,
              currentIndex: currentIndex,
              enableSelectionAnimation: enableSelectionAnimation,
              onIndexChanged: (_) {},
              items: const [
                GtBottomNavigationItem(
                  selectedIcon: GtIcons.homeFilled,
                  unselectedIcon: GtIcons.home,
                  label: 'Home',
                ),
                GtBottomNavigationItem(
                  selectedIcon: GtIcons.cardFilled,
                  unselectedIcon: GtIcons.card,
                  label: 'Cards',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeypadTestApp extends GtStatelessWidget {
  final TextEditingController controller;
  final bool enableScaleEffect;

  const _KeypadTestApp({
    required this.controller,
    this.enableScaleEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: Scaffold(
          body: GtKeyPadGrid(
            controller: controller,
            limit: 4,
            enableScaleEffect: enableScaleEffect,
            onBioAuth: () {},
          ),
        ),
      ),
    );
  }
}

class _ButtonLabelMotionTestApp extends GtStatelessWidget {
  final String label;
  final bool disableAnimations;
  final bool enableLabelAnimation;

  const _ButtonLabelMotionTestApp({
    required this.label,
    this.disableAnimations = false,
    this.enableLabelAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            body: GtRaisedButton(
              text: label,
              enableLabelAnimation: enableLabelAnimation,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('shared switchers use zero duration for reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _AdaptiveSwitcherTestApp(disableAnimations: true),
    );

    final scaleSwitcher = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byKey(const Key('scale-switcher')),
        matching: find.byType(AnimatedSwitcher),
      ),
    );
    final sizeSwitcher = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byKey(const Key('size-switcher')),
        matching: find.byType(AnimatedSwitcher),
      ),
    );

    expect(scaleSwitcher.duration, Duration.zero);
    expect(scaleSwitcher.reverseDuration, Duration.zero);
    expect(sizeSwitcher.duration, Duration.zero);
    expect(sizeSwitcher.reverseDuration, Duration.zero);
  });

  testWidgets('button labels transition when their action changes', (
    tester,
  ) async {
    await tester.pumpWidget(const _ButtonLabelMotionTestApp(label: 'Continue'));
    await tester.pumpWidget(const _ButtonLabelMotionTestApp(label: 'Confirm'));
    await tester.pump();

    final labelSwitcher = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtButtonText),
        matching: find.byType(AnimatedSwitcher),
      ),
    );
    expect(labelSwitcher.duration, GtMotion.fast);
    expect(find.byType(SlideTransition), findsWidgets);

    await tester.pumpAndSettle();
    expect(find.text('CONFIRM'), findsOneWidget);
    expect(find.text('CONTINUE'), findsNothing);
  });

  testWidgets('button label transitions honor opt-out and reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ButtonLabelMotionTestApp(
        label: 'Continue',
        enableLabelAnimation: false,
      ),
    );
    var switcher = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtButtonText),
        matching: find.byType(AnimatedSwitcher),
      ),
    );
    expect(switcher.duration, Duration.zero);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      const _ButtonLabelMotionTestApp(
        label: 'Confirm',
        disableAnimations: true,
      ),
    );
    switcher = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtButtonText),
        matching: find.byType(AnimatedSwitcher),
      ),
    );
    expect(switcher.duration, Duration.zero);
  });

  testWidgets('bottom navigation uses tokenized selection motion', (
    tester,
  ) async {
    await tester.pumpWidget(const _BottomNavigationTestApp(currentIndex: 0));

    final highlight = tester.widget<AnimatedPositioned>(
      find.byType(AnimatedPositioned),
    );
    final iconSwitchers = tester.widgetList<GtAnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtBottomNavigationBar),
        matching: find.byType(GtAnimatedSwitcher),
      ),
    );

    expect(highlight.duration, GtMotion.fluid);
    expect(iconSwitchers, hasLength(2));
    expect(
      iconSwitchers.every(
        (switcher) =>
            switcher.duration == GtMotion.normal.inMilliseconds &&
            switcher.beginScale == GtMotion.iconPressScale,
      ),
      isTrue,
    );
  });

  testWidgets('bottom navigation disables selection motion when requested', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _BottomNavigationTestApp(
        currentIndex: 0,
        enableSelectionAnimation: false,
      ),
    );

    final highlight = tester.widget<AnimatedPositioned>(
      find.byType(AnimatedPositioned),
    );
    final iconSwitchers = tester.widgetList<GtAnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtBottomNavigationBar),
        matching: find.byType(GtAnimatedSwitcher),
      ),
    );

    expect(highlight.duration, Duration.zero);
    expect(iconSwitchers.every((switcher) => switcher.duration == 0), isTrue);
  });

  testWidgets('bottom navigation honors reduced motion', (tester) async {
    await tester.pumpWidget(
      const _BottomNavigationTestApp(currentIndex: 0, disableAnimations: true),
    );

    expect(
      tester
          .widget<AnimatedPositioned>(find.byType(AnimatedPositioned))
          .duration,
      Duration.zero,
    );
    for (final switcher in tester.widgetList<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtBottomNavigationBar),
        matching: find.byType(AnimatedSwitcher),
      ),
    )) {
      expect(switcher.duration, Duration.zero);
    }
  });

  testWidgets('keypad exposes scale and calibrated haptic configuration', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_KeypadTestApp(controller: controller));

    final cells = tester.widgetList<GtKeyCell>(find.byType(GtKeyCell));
    final pressables = tester.widgetList<GtPressable>(
      find.descendant(
        of: find.byType(GtKeyPadGrid),
        matching: find.byType(GtPressable),
      ),
    );

    expect(cells, hasLength(12));
    expect(
      cells.every(
        (cell) =>
            cell.keyHapticFeedbackType == HapticFeedbackType.light &&
            cell.actionHapticFeedbackType == HapticFeedbackType.medium,
      ),
      isTrue,
    );
    expect(pressables, hasLength(12));
    expect(
      pressables.every(
        (pressable) =>
            pressable.enabled &&
            pressable.pressedScale == GtMotion.buttonPressScale,
      ),
      isTrue,
    );

    await tester.tap(find.text('1'));
    expect(controller.text, '1');

    await tester.pumpWidget(
      _KeypadTestApp(controller: controller, enableScaleEffect: false),
    );
    expect(
      tester
          .widgetList<GtPressable>(
            find.descendant(
              of: find.byType(GtKeyPadGrid),
              matching: find.byType(GtPressable),
            ),
          )
          .every((pressable) => !pressable.enabled),
      isTrue,
    );
  });
}
