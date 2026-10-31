import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _naira = GtAccountData<String>(
  id: 'naira',
  type: 'Savings',
  accountNumber: '0000000001',
  balance: 1000,
  data: 'naira',
);

const _dollar = GtAccountData<String>(
  id: 'dollar',
  type: 'Domiciliary',
  accountNumber: '0000000002',
  balance: 20,
  currency: r'$',
  data: 'dollar',
);

const _other = GtAccountData<String>(
  id: 'other',
  type: 'Current',
  accountNumber: '0000000003',
  balance: 300,
  data: 'other',
);

void main() {
  setUpAll(registerTestAppConfig);

  /// Pumps the slides over [controller] on a phone-sized view.
  Future<void> pumpSlides(
    WidgetTester tester,
    GtAccountDataController<String> controller, {
    OnChanged2<int, String?>? onIndexUpdate,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            body: GtAccountDetailSlides<String>(
              controller: controller,
              hidden: false,
              onToggleHide: () {},
              onIndexUpdate: onIndexUpdate,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Fails unless the page on screen is the selected account's.
  void expectPageMatches(GtAccountDataController<String> controller) {
    expect(controller.pageController.page?.round(), controller.activeIndex);
  }

  /// The selected account's pill caption, which follows [activeIndex].
  Finder pillFor(GtAccountData<String> account) {
    return find.text(
      '${account.type}${AppStrings.dotSeparator}${account.accountNumber}'.upper,
    );
  }

  group('GtAccountDetailSlides page sync', () {
    testWidgets('a new controller opens on its own activeIndex', (
      tester,
    ) async {
      final first = GtAccountDataController<String>(
        accounts: const [_naira, _dollar, _other],
        activeIndex: 1,
      );
      addTearDown(first.dispose);
      await pumpSlides(tester, first);
      expectPageMatches(first);
      expect(pillFor(_dollar), findsOneWidget);

      // The host reloads the same accounts in a new order and builds a new
      // controller still on the dollar account, now at index 0. The count is
      // unchanged, so only the controller tells the pager anything moved.
      final second = GtAccountDataController<String>(
        accounts: const [_dollar, _naira, _other],
        activeIndex: 0,
      );
      addTearDown(second.dispose);
      await pumpSlides(tester, second);

      expect(second.activeIndex, 0);
      expectPageMatches(second);
      expect(pillFor(_dollar), findsOneWidget);
    });

    testWidgets('honours an activeIndex set before the pager attaches', (
      tester,
    ) async {
      final controller = GtAccountDataController<String>(
        accounts: const [_naira, _dollar, _other],
      );
      addTearDown(controller.dispose);

      controller.activeIndex = 2;
      await pumpSlides(tester, controller);

      expectPageMatches(controller);
      expect(controller.pageController.page?.round(), 2);
      expect(pillFor(_other), findsOneWidget);
    });

    testWidgets('keeps the selected account in view when one ahead of it is '
        'removed', (tester) async {
      final controller = GtAccountDataController<String>(
        accounts: const [_naira, _dollar, _other],
        activeIndex: 2,
      );
      addTearDown(controller.dispose);
      await pumpSlides(tester, controller);

      controller.removeAccount(_naira);
      await tester.pumpAndSettle();

      expect(controller.activeIndex, 1);
      expectPageMatches(controller);
      expect(pillFor(_other), findsOneWidget);
    });

    testWidgets('a swipe still selects the account it lands on', (
      tester,
    ) async {
      final controller = GtAccountDataController<String>(
        accounts: const [_naira, _dollar, _other],
      );
      addTearDown(controller.dispose);
      final updates = <(int, String?)>[];
      await pumpSlides(
        tester,
        controller,
        onIndexUpdate: (index, data) => updates.add((index, data)),
      );

      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      expect(controller.activeIndex, 1);
      expectPageMatches(controller);
      expect(updates, [(1, 'dollar')]);
    });
  });
}
