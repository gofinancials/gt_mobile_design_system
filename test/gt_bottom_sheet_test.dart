import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

class _FloatingSheetOpener extends StatelessWidget with GtBottomSheetMixin {
  const _FloatingSheetOpener();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSheet(
          context,
          floating: true,
          child: const SizedBox(
            key: ValueKey('sheet_content'),
            height: 200,
            child: Text('Sheet content'),
          ),
        );
      },
      child: const Text('Open'),
    );
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  Future<void> openFloatingSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: const MaterialApp(
          home: Scaffold(body: Center(child: _FloatingSheetOpener())),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Finder sheetCard(WidgetTester tester) {
    final content = find.byKey(const ValueKey('sheet_content'));
    final white = tester.element(content).palette.bg.white;

    // Match the painted surface rather than its Container, whose bounds also
    // include the sheet margin.
    return find.ancestor(
      of: content,
      matching: find.byWidgetPredicate((widget) {
        if (widget is! DecoratedBox) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == white &&
            decoration.borderRadius != null;
      }),
    );
  }

  group('GtBottomSheet', () {
    testWidgets(
      'a floating sheet paints a white rounded card inset from the bottom edge',
      (tester) async {
        await openFloatingSheet(tester);

        final card = sheetCard(tester);
        expect(card, findsOneWidget);
        expect(tester.getRect(card).bottom, closeTo(812 - 18, 1));
      },
      variant: TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
      }),
    );

    testWidgets('a floating sheet on Android stays above the navigation bar', (
      tester,
    ) async {
      tester.view.padding = const FakeViewPadding(bottom: 48);
      tester.view.viewPadding = const FakeViewPadding(bottom: 48);

      await openFloatingSheet(tester);

      final card = sheetCard(tester);
      expect(card, findsOneWidget);
      expect(tester.getRect(card).bottom, closeTo(812 - 48 - 18, 1));
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
