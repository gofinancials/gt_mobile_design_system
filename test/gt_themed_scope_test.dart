import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

/// Opens a sheet whose content reports the styling it resolved.
class _SheetOpener extends StatelessWidget with GtBottomSheetMixin {
  final void Function(BuildContext) onBuilt;

  const _SheetOpener(this.onBuilt);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showSheet(
        context,
        child: Builder(
          builder: (context) {
            onBuilt(context);
            return const SizedBox(height: 100);
          },
        ),
      ),
      child: const Text('Open'),
    );
  }
}

/// Opens a confirmation dialog.
///
/// The dialog builds its own content, so the styling it resolved is read off
/// the [GtConfirmDialog] element rather than reported through a callback.
class _DialogOpener extends StatelessWidget with GtConfirmDialogMixin {
  const _DialogOpener();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          confirmAction(context, title: 'Confirm', onContinue: () {}),
      child: const Text('Open'),
    );
  }
}

/// Shows a toast overlay from inside the scope.
///
/// The toast builds its own content, so the styling it resolved is read off
/// the [GtToastOverlay] element.
class _ToastOpener extends StatelessWidget {
  const _ToastOpener();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => GtToast.of(context).show('Saved'),
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

  const phone = Size(375, 812);
  const tablet = Size(1024, 1366);

  /// Pumps [opener] inside a [GtThemedScope] for [kFlexTheme] at [size], with
  /// the app itself on [kPersonalTheme], and taps it.
  Future<void> openFromScope(
    WidgetTester tester,
    Widget opener, {
    required Size size,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          home: GtThemedScope(
            theme: kFlexTheme,
            child: Scaffold(body: Center(child: opener)),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  /// Asserts that both halves of the styling under [context] are Flex.
  void expectFlex(BuildContext context) {
    expect(GtThemeProvider.of(context), same(kFlexTheme));
    expect(
      Theme.of(context).extension<GtPalette>(),
      same(kFlexTheme.lightPalette),
    );
  }

  group('GtThemedScope route capture', () {
    testWidgets('a sheet opened from a scope keeps its brand on a phone', (
      tester,
    ) async {
      late BuildContext sheetContext;

      await openFromScope(
        tester,
        _SheetOpener((context) => sheetContext = context),
        size: phone,
      );

      expectFlex(sheetContext);
    }, variant: bothPlatforms);

    testWidgets('a sheet opened from a scope keeps its brand on a tablet', (
      tester,
    ) async {
      late BuildContext sheetContext;

      await openFromScope(
        tester,
        _SheetOpener((context) => sheetContext = context),
        size: tablet,
      );

      expectFlex(sheetContext);
    }, variant: bothPlatforms);

    testWidgets(
      'a confirmation dialog keeps the brand of the scope that opened it',
      (tester) async {
        await openFromScope(tester, const _DialogOpener(), size: phone);

        expectFlex(tester.element(find.byType(GtConfirmDialog)));
      },
      variant: bothPlatforms,
    );

    testWidgets('a toast overlay keeps the brand of the scope that raised it', (
      tester,
    ) async {
      await openFromScope(tester, const _ToastOpener(), size: phone);

      expectFlex(tester.element(find.byType(GtToastOverlay)));

      // The toast dismisses itself on a timer the test must outlive.
      await tester.pumpAndSettle(const Duration(seconds: 4));
    }, variant: bothPlatforms);
  });
}
