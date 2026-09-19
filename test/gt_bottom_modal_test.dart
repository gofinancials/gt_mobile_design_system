import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

class _ModalOpener extends StatelessWidget with GtBottomModalMixin {
  final bool withChild;

  const _ModalOpener({this.withChild = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (withChild) {
          showBottomModalWithChild(
            context,
            child: const SizedBox(key: ValueKey('modal_content'), height: 120),
          );
          return;
        }
        showBottomModal(context, title: 'Done');
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

  Future<void> openModal(WidgetTester tester, Widget opener) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(bottom: 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
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

  Finder modalCard(WidgetTester tester, Finder content) {
    final white = tester.element(content).palette.bg.white;

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

  group('GtBottomModal', () {
    testWidgets('keeps a gap above the system bottom inset', (tester) async {
      await openModal(tester, const _ModalOpener());

      final card = modalCard(tester, find.text('DONE'));
      expect(card, findsOneWidget);
      expect(tester.getRect(card).bottom, closeTo(812 - 48 - 18, 1));
    }, variant: bothPlatforms);

    testWidgets(
      'keeps a gap above the system bottom inset with a custom child',
      (tester) async {
        await openModal(tester, const _ModalOpener(withChild: true));

        final card = modalCard(
          tester,
          find.byKey(const ValueKey('modal_content')),
        );
        expect(card, findsOneWidget);
        expect(tester.getRect(card).bottom, closeTo(812 - 48 - 18, 1));
      },
      variant: bothPlatforms,
    );
  });
}
