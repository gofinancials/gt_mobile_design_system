import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

class _SheetOpener extends StatelessWidget with GtBottomSheetMixin {
  final bool floating;

  const _SheetOpener({this.floating = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSheet(
          context,
          floating: floating,
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

class _DraggableSheetOpener extends StatelessWidget with GtBottomSheetMixin {
  const _DraggableSheetOpener();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDraggableSheet(
          context,
          builder: (controller) {
            return ListView(
              key: const ValueKey('sheet_list'),
              controller: controller,
              // An explicit padding turns off the safe area padding a ListView
              // otherwise adds on its own.
              padding: const EdgeInsets.all(16),
              children: [
                for (var i = 0; i < 40; i++)
                  SizedBox(key: ValueKey('sheet_row_$i'), height: 50),
              ],
            );
          },
        );
      },
      child: const Text('Open'),
    );
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  const bothPlatforms = TargetPlatformVariant({
    TargetPlatform.android,
    TargetPlatform.iOS,
  });

  void setBottomInset(WidgetTester tester) {
    tester.view.padding = const FakeViewPadding(bottom: 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
  }

  Future<void> openSheet(WidgetTester tester, Widget opener) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(body: Center(child: opener)),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Finder sheetCard(WidgetTester tester, Finder content) {
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
    const content = ValueKey('sheet_content');

    testWidgets(
      'a floating sheet paints a white rounded card inset from the bottom edge',
      (tester) async {
        await openSheet(tester, const _SheetOpener(floating: true));

        final card = sheetCard(tester, find.byKey(content));
        expect(card, findsOneWidget);
        expect(tester.getRect(card).bottom, closeTo(812 - 18, 1));
      },
      variant: bothPlatforms,
    );

    testWidgets('a floating sheet stays above the system bottom inset', (
      tester,
    ) async {
      setBottomInset(tester);

      await openSheet(tester, const _SheetOpener(floating: true));

      final card = sheetCard(tester, find.byKey(content));
      expect(card, findsOneWidget);
      expect(tester.getRect(card).bottom, closeTo(812 - 48 - 18, 1));
    }, variant: bothPlatforms);

    testWidgets(
      'an attached sheet paints under the system bottom inset but keeps its '
      'content above it',
      (tester) async {
        setBottomInset(tester);

        await openSheet(tester, const _SheetOpener());

        final card = sheetCard(tester, find.byKey(content));
        expect(card, findsOneWidget);
        expect(tester.getRect(card).bottom, closeTo(812, 1));
        expect(
          tester.getRect(find.byKey(content)).bottom,
          lessThanOrEqualTo(812 - 48 + 1),
        );
      },
      variant: bothPlatforms,
    );

    testWidgets(
      'a draggable sheet scrolls its last item above the system bottom inset',
      (tester) async {
        setBottomInset(tester);

        await openSheet(tester, const _DraggableSheetOpener());

        final position = tester
            .state<ScrollableState>(
              find.descendant(
                of: find.byKey(const ValueKey('sheet_list')),
                matching: find.byType(Scrollable),
              ),
            )
            .position;
        position.jumpTo(position.maxScrollExtent);
        await tester.pumpAndSettle();

        final lastRow = find.byKey(const ValueKey('sheet_row_39'));
        expect(tester.getRect(lastRow).bottom, closeTo(812 - 48 - 16, 1));
      },
      variant: bothPlatforms,
    );
  });
}
