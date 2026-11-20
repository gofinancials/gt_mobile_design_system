import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const homeKey = Key('home-page');
  const paymentsKey = Key('payments-page');

  const navItems = [
    GtBottomNavigationItem(
      selectedIcon: GtIcons.homeFilled,
      unselectedIcon: GtIcons.home,
      label: 'Home',
    ),
    GtBottomNavigationItem(
      selectedIcon: GtIcons.walletAltFilled,
      unselectedIcon: GtIcons.walletAlt,
      label: 'Payments',
    ),
  ];

  /// Mounts [scaffold] on a phone-sized view with a 34pt bottom system inset,
  /// as the iOS home indicator or Android gesture navigation leaves. Animations
  /// are off, so a skeleton's shimmer settles.
  Future<void> pump(WidgetTester tester, GtDashboardScaffold scaffold) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: scaffold,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  GtDashboardPageData home({bool withNavItem = true, bool isLoading = false}) {
    return GtDashboardPageData(
      page: const SizedBox.expand(key: homeKey),
      navItem: withNavItem ? navItems[0] : null,
      showGradient: true,
      isLoading: isLoading,
    );
  }

  GtDashboardPageData payments({bool withNavItem = true}) {
    return GtDashboardPageData(
      page: const SizedBox.expand(key: paymentsKey),
      navItem: withNavItem ? navItems[1] : null,
    );
  }

  testWidgets('a single page draws no bottom navigation, and keeps its '
      'gradient, skeleton and pop scope', (tester) async {
    await pump(
      tester,
      GtDashboardScaffold(
        onClickHelp: () {},
        data: [home(withNavItem: false, isLoading: true)],
      ),
    );

    expect(find.byKey(homeKey), findsOneWidget);
    expect(find.byType(GtBottomNavigationBar), findsNothing);
    expect(find.byType(GtSkeleton), findsOneWidget);
    expect(find.byType(GtRootPopScope), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is GtHomeGradientPainter,
      ),
      findsOneWidget,
    );
  });

  testWidgets('two or more pages draw the bottom navigation', (tester) async {
    await pump(
      tester,
      GtDashboardScaffold(onClickHelp: () {}, data: [home(), payments()]),
    );

    expect(find.byType(GtBottomNavigationBar), findsOneWidget);
  });

  testWidgets('showBottomNavigation false hides the bar over several pages, '
      'and the page controller still switches pages', (tester) async {
    final controller = ValueNotifier(1);
    addTearDown(controller.dispose);

    await pump(
      tester,
      GtDashboardScaffold(
        onClickHelp: () {},
        showBottomNavigation: false,
        pageController: controller,
        data: [home(withNavItem: false), payments(withNavItem: false)],
      ),
    );

    expect(find.byType(GtBottomNavigationBar), findsNothing);
    expect(find.byKey(paymentsKey), findsOneWidget);

    controller.value = 0;
    await tester.pumpAndSettle();
    expect(find.byKey(homeKey), findsOneWidget);
    expect(find.byKey(paymentsKey), findsNothing);
  });

  testWidgets('initialIndex picks the page while the bar is hidden', (
    tester,
  ) async {
    await pump(
      tester,
      GtDashboardScaffold(
        onClickHelp: () {},
        showBottomNavigation: false,
        initialIndex: 1,
        data: [home(), payments()],
      ),
    );

    expect(find.byKey(paymentsKey), findsOneWidget);
  });

  testWidgets('without the bar the page clears the bottom system inset', (
    tester,
  ) async {
    await pump(
      tester,
      GtDashboardScaffold(onClickHelp: () {}, data: [home(withNavItem: false)]),
    );

    final page = tester.getRect(find.byKey(homeKey));
    expect(page.top, 47);
    expect(page.bottom, 812 - 34);
  });

  test('showBottomNavigation true needs two or more pages', () {
    expect(
      () => GtDashboardScaffold(
        onClickHelp: () {},
        showBottomNavigation: true,
        data: [home()],
      ),
      throwsAssertionError,
    );
  });

  test('a dashboard needs a page', () {
    expect(
      () => GtDashboardScaffold(onClickHelp: () {}, data: const []),
      throwsAssertionError,
    );
  });

  testWidgets('the bar needs a nav item on every page', (tester) async {
    await pump(
      tester,
      GtDashboardScaffold(
        onClickHelp: () {},
        data: [home(), payments(withNavItem: false)],
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });
}
