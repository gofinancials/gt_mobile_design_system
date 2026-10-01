import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

class _SheetOpener extends StatelessWidget with GtBottomSheetMixin {
  final bool floating;
  final bool isScrollable;
  final bool isDismissable;

  const _SheetOpener({
    this.floating = false,
    this.isScrollable = false,
    this.isDismissable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSheet(
          context,
          floating: floating,
          isScrollable: isScrollable,
          isDismissable: isDismissable,
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

    testWidgets(
      'a floating sheet stays above the system bottom inset',
      (tester) async {
        setBottomInset(tester);

        await openSheet(tester, const _SheetOpener(floating: true));

        final card = sheetCard(tester, find.byKey(content));
        expect(card, findsOneWidget);
        expect(tester.getRect(card).bottom, closeTo(812 - 48 - 18, 1));
      },
      variant: bothPlatforms,
    );

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

  group('GtBottomSheet dismissal', () {
    const content = ValueKey('sheet_content');
    const list = ValueKey('sheet_list');

    Future<void> tapAbove(WidgetTester tester, double y) async {
      await tester.tapAt(Offset(10, y));
      await tester.pumpAndSettle();
    }

    // The sheet is 200 tall on an 812 surface, so it starts at y=612. A sheet
    // that is not scrollable is boxed to 9/16 of the screen, so y=500 sits in
    // the band that box covers above the sheet, and y=10 above the box.
    for (final isScrollable in [false, true]) {
      for (final y in [10.0, 500.0]) {
        testWidgets(
          'a tap at y=$y above a sheet with isScrollable: $isScrollable '
          'dismisses it',
          (tester) async {
            await openSheet(tester, _SheetOpener(isScrollable: isScrollable));
            expect(find.byKey(content), findsOneWidget);

            await tapAbove(tester, y);

            expect(find.byKey(content), findsNothing);
          },
        );
      }
    }

    testWidgets(
      'a tap above a floating scrollable sheet dismisses it',
      (tester) async {
        await openSheet(
          tester,
          const _SheetOpener(floating: true, isScrollable: true),
        );

        await tapAbove(tester, 10);

        expect(find.byKey(content), findsNothing);
      },
      variant: bothPlatforms,
    );

    testWidgets('a tap above a draggable sheet dismisses it', (tester) async {
      await openSheet(tester, const _DraggableSheetOpener());
      expect(find.byKey(list), findsOneWidget);

      await tapAbove(tester, 10);

      expect(find.byKey(list), findsNothing);
    }, variant: bothPlatforms);

    for (final isScrollable in [false, true]) {
      testWidgets(
        'a tap above a sheet with isScrollable: $isScrollable leaves it open '
        'when it is not dismissable',
        (tester) async {
          await openSheet(
            tester,
            _SheetOpener(isScrollable: isScrollable, isDismissable: false),
          );

          await tapAbove(tester, 10);

          expect(find.byKey(content), findsOneWidget);
        },
      );
    }

    testWidgets('a tap on the sheet itself leaves it open', (tester) async {
      await openSheet(tester, const _SheetOpener(isScrollable: true));

      await tester.tap(find.byKey(content));
      await tester.pumpAndSettle();

      expect(find.byKey(content), findsOneWidget);
    });
  });
}
