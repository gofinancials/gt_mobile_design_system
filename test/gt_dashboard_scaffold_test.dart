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

  group('page lifetime', () {
    testWidgets('a page stays mounted as its skeleton lifts', (tester) async {
      final probe = _Probe();
      GtDashboardScaffold scaffold({required bool isLoading}) {
        return GtDashboardScaffold(
          onClickHelp: () {},
          data: [
            GtDashboardPageData(
              page: _Counted(probe: probe),
              navItem: navItems[0],
              isLoading: isLoading,
            ),
            payments(),
          ],
        );
      }

      await pump(tester, scaffold(isLoading: true));
      await pump(tester, scaffold(isLoading: false));

      expect(probe.mounts, 1);
      expect(probe.disposals, 0);
    });

    testWidgets('two pages of one class do not share state', (tester) async {
      final first = _Probe();
      final second = _Probe();
      final controller = ValueNotifier(0);
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtDashboardScaffold(
          onClickHelp: () {},
          pageController: controller,
          data: [
            GtDashboardPageData(
              page: _Counted(probe: first),
              navItem: navItems[0],
            ),
            GtDashboardPageData(
              page: _Counted(probe: second),
              navItem: navItems[1],
            ),
          ],
        ),
      );

      controller.value = 1;
      await tester.pumpAndSettle();

      expect(first.disposals, 1);
      expect(second.mounts, 1);
    });

    testWidgets('pages are rebuilt on each visit by default', (tester) async {
      final probe = _Probe();
      final controller = ValueNotifier(0);
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtDashboardScaffold(
          onClickHelp: () {},
          pageController: controller,
          data: [
            GtDashboardPageData(
              page: _Counted(probe: probe),
              navItem: navItems[0],
            ),
            payments(),
          ],
        ),
      );

      controller.value = 1;
      await tester.pumpAndSettle();
      controller.value = 0;
      await tester.pumpAndSettle();

      expect(probe.mounts, 2);
      expect(probe.disposals, 1);
    });

    testWidgets('keepPagesAlive keeps a visited page and builds the rest on '
        'first visit', (tester) async {
      final home = _Probe();
      final cards = _Probe();
      final controller = ValueNotifier(0);
      addTearDown(controller.dispose);

      await pump(
        tester,
        GtDashboardScaffold(
          onClickHelp: () {},
          pageController: controller,
          keepPagesAlive: true,
          data: [
            GtDashboardPageData(
              page: _Counted(probe: home),
              navItem: navItems[0],
              showGradient: true,
            ),
            GtDashboardPageData(
              page: _Counted(probe: cards),
              navItem: navItems[1],
            ),
          ],
        ),
      );
      expect(cards.mounts, 0);

      controller.value = 1;
      await tester.pumpAndSettle();
      controller.value = 0;
      await tester.pumpAndSettle();

      expect(home.mounts, 1);
      expect(home.disposals, 0);
      expect(cards.mounts, 1);
      expect(cards.disposals, 0);
    });
  });
}

/// Counts how often a [_Counted] page is mounted and disposed.
class _Probe {
  int mounts = 0;
  int disposals = 0;
}

class _Counted extends StatefulWidget {
  final _Probe probe;

  const _Counted({required this.probe});

  @override
  State<_Counted> createState() => _CountedState();
}

class _CountedState extends State<_Counted> {
  @override
  void initState() {
    super.initState();
    widget.probe.mounts++;
  }

  @override
  void dispose() {
    widget.probe.disposals++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
