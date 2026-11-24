import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  testWidgets(
    'the Android bar paints under the system bottom inset but keeps its tabs '
    'above it',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(bottom: 48);
      tester.view.viewPadding = const FakeViewPadding(bottom: 48);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: GtBottomNavigationBar(
                style: .android,
                currentIndex: 0,
                onIndexChanged: (_) {},
                items: const [
                  GtBottomNavigationItem(
                    selectedIcon: Icons.home,
                    unselectedIcon: Icons.home_outlined,
                    label: 'Home',
                  ),
                  GtBottomNavigationItem(
                    selectedIcon: Icons.person,
                    unselectedIcon: Icons.person_outline,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tabs = find.byType(Table);
      final surface = find.ancestor(
        of: tabs,
        matching: find.byType(ColoredBox),
      );

      expect(tester.getRect(surface.first).bottom, closeTo(812, 1));
      expect(tester.getRect(tabs).bottom, closeTo(812 - 48 - 12, 1));
    },
  );

  Future<void> pumpIos(
    WidgetTester tester, {
    bool? frosted,
    TargetPlatform platform = TargetPlatform.iOS,
  }) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: ThemeData(platform: platform),
          home: Scaffold(
            bottomNavigationBar: GtBottomNavigationBar(
              style: .ios,
              frosted: frosted,
              currentIndex: 0,
              onIndexChanged: (_) {},
              items: const [
                GtBottomNavigationItem(
                  selectedIcon: Icons.home,
                  unselectedIcon: Icons.home_outlined,
                  label: 'Home',
                ),
                GtBottomNavigationItem(
                  selectedIcon: Icons.person,
                  unselectedIcon: Icons.person_outline,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the iOS glass blurs by default off Android', (tester) async {
    await pumpIos(tester);
    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('the iOS glass does not blur by default on Android', (
    tester,
  ) async {
    await pumpIos(tester, platform: TargetPlatform.android);
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('frosted overrides the platform default', (tester) async {
    await pumpIos(tester, frosted: true, platform: TargetPlatform.android);
    expect(find.byType(BackdropFilter), findsOneWidget);

    await pumpIos(tester, frosted: false);
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
