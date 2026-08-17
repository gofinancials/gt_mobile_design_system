import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class _TextFieldMotionTestApp extends GtStatelessWidget {
  final bool disableAnimations;
  final String? helperText;
  final GtSpringShakeController? shakeController;
  final GtInputController controller;

  const _TextFieldMotionTestApp({
    required this.controller,
    this.disableAnimations = false,
    this.helperText,
    this.shakeController,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            body: GtTextField(
              controller: controller,
              helperText: helperText,
              shakeController: shakeController,
            ),
          ),
        ),
      ),
    );
  }
}

class _PinInputMotionTestApp extends GtStatelessWidget {
  final bool disableAnimations;
  final GtSpringShakeController? shakeController;

  const _PinInputMotionTestApp({
    this.disableAnimations = false,
    this.shakeController,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: disableAnimations),
          child: Scaffold(
            body: GtPinInput(
              autoFocus: false,
              shakeController: shakeController,
              hapticFeedbackType: .selection,
              completionHapticFeedbackType: .medium,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('GtTextField uses adaptive motion for decoration and support', (
    tester,
  ) async {
    final controller = GtInputController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _TextFieldMotionTestApp(
        controller: controller,
        disableAnimations: true,
        helperText: 'Helpful copy',
      ),
    );

    final decoration = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(GtTextField),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final supportingSize = tester.widget<AnimatedSize>(
      find.descendant(
        of: find.byType(GtTextField),
        matching: find.byType(AnimatedSize),
      ),
    );
    final supportingFade = tester.widget<AnimatedSwitcher>(
      find.descendant(
        of: find.byType(GtTextField),
        matching: find.byType(AnimatedSwitcher),
      ),
    );

    expect(decoration.duration, Duration.zero);
    expect(supportingSize.duration, Duration.zero);
    expect(supportingFade.duration, Duration.zero);
  });

  testWidgets('GtTextField animates supporting text changes', (tester) async {
    final controller = GtInputController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_TextFieldMotionTestApp(controller: controller));
    expect(find.text('Helpful copy'), findsNothing);

    await tester.pumpWidget(
      _TextFieldMotionTestApp(
        controller: controller,
        helperText: 'Helpful copy',
      ),
    );
    await tester.pump();

    expect(find.byType(FadeTransition), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.text('Helpful copy'), findsOneWidget);
  });

  testWidgets('GtTextField accepts explicit shake feedback', (tester) async {
    final controller = GtInputController();
    final shakeController = GtSpringShakeController();
    addTearDown(controller.dispose);
    addTearDown(shakeController.dispose);

    await tester.pumpWidget(
      _TextFieldMotionTestApp(
        controller: controller,
        shakeController: shakeController,
      ),
    );

    shakeController.shake();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final transforms = tester.widgetList<Transform>(
      find.descendant(
        of: find.byType(GtSpringShake),
        matching: find.byType(Transform),
      ),
    );
    expect(
      transforms.any(
        (transform) => transform.transform.getTranslation().x != 0,
      ),
      isTrue,
    );
  });

  testWidgets('GtPinInput uses tokenized entry motion and haptics', (
    tester,
  ) async {
    await tester.pumpWidget(const _PinInputMotionTestApp());

    final field = tester.widget<MaterialPinFormField>(
      find.byType(MaterialPinFormField),
    );

    expect(field.enableHapticFeedback, isTrue);
    expect(field.hapticFeedbackType, HapticFeedbackType.selection);
    expect(field.theme?.entryAnimation, MaterialPinAnimation.scale);
    expect(field.theme?.animationDuration, GtMotion.fast);
    expect(
      field.theme?.animationCurve.transform(.278),
      inInclusiveRange(0.0, 1.0),
    );
  });

  testWidgets('GtPinInput safely overlaps digit entry and shake motion', (
    tester,
  ) async {
    final shakeController = GtSpringShakeController();
    addTearDown(shakeController.dispose);
    await tester.pumpWidget(
      _PinInputMotionTestApp(shakeController: shakeController),
    );

    await tester.enterText(find.byType(EditableText), '1');
    shakeController.shake();
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 30));
    }

    expect(find.text('1'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('GtPinInput removes motion when animations are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _PinInputMotionTestApp(disableAnimations: true),
    );

    final theme = tester
        .widget<MaterialPinFormField>(find.byType(MaterialPinFormField))
        .theme;

    expect(theme?.entryAnimation, MaterialPinAnimation.none);
    expect(theme?.animationDuration, Duration.zero);
    expect(theme?.errorAnimationDuration, Duration.zero);
    expect(theme?.animateCursor, isFalse);
  });

  testWidgets('GtPinInput accepts explicit shake feedback', (tester) async {
    final shakeController = GtSpringShakeController();
    addTearDown(shakeController.dispose);
    await tester.pumpWidget(
      _PinInputMotionTestApp(shakeController: shakeController),
    );

    shakeController.shake();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final transforms = tester.widgetList<Transform>(
      find.descendant(
        of: find.byType(GtSpringShake),
        matching: find.byType(Transform),
      ),
    );
    expect(
      transforms.any(
        (transform) => transform.transform.getTranslation().x != 0,
      ),
      isTrue,
    );
  });
}
