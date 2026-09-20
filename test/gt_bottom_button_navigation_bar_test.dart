import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _BottomButtonNavBarTestApp extends GtStatelessWidget {
  final GtBottomNavBarButtonHidingBehavior behavior;
  final bool keyboardVisible;

  const _BottomButtonNavBarTestApp({
    required this.behavior,
    required this.keyboardVisible,
  });

  @override
  Widget build(BuildContext context) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: keyboardVisible ? 200 : 0),
          ),
          child: Scaffold(
            bottomNavigationBar: GtButtonBottomNavBar(
              hidingBehavior: behavior,
              heading: GtRaisedButton(
                key: const Key('heading'),
                text: 'HEADING',
                onPressed: () {},
              ),
              button: GtRaisedButton(
                key: const Key('button'),
                text: 'BUTTON',
                onPressed: () {},
              ),
              footer: GtRaisedButton(
                key: const Key('footer'),
                text: 'FOOTER',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  const headingHider = Key('gt-bnavbar-heading-hider');
  const buttonHider = Key('gt-bnavbar-button-hider');
  const footerHider = Key('gt-bnavbar-footer-hider');

  bool isShown(WidgetTester tester, Key hiderKey) {
    final fade = find.descendant(
      of: find.byKey(hiderKey),
      matching: find.byType(GtAnimatedFade),
    );
    if (fade.evaluate().isEmpty) return true;
    return tester.widget<GtAnimatedFade>(fade.first).showFirst;
  }

  testWidgets('keeps all regions visible while the keyboard is closed', (
    tester,
  ) async {
    for (final behavior in GtBottomNavBarButtonHidingBehavior.values) {
      await tester.pumpWidget(
        _BottomButtonNavBarTestApp(behavior: behavior, keyboardVisible: false),
      );

      expect(isShown(tester, headingHider), isTrue);
      expect(isShown(tester, buttonHider), isTrue);
      expect(isShown(tester, footerHider), isTrue);
    }
  });

  testWidgets('wrapped regions retain the full available width', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _BottomButtonNavBarTestApp(
        behavior: .footer,
        keyboardVisible: false,
      ),
    );

    final headingWidth = tester.getSize(find.byKey(const Key('heading'))).width;
    final buttonWidth = tester.getSize(find.byKey(const Key('button'))).width;
    final footerWidth = tester.getSize(find.byKey(const Key('footer'))).width;

    expect(headingWidth, buttonWidth);
    expect(buttonWidth, footerWidth);
  });

  testWidgets('footer hides only the footer while the keyboard is open', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _BottomButtonNavBarTestApp(
        behavior: .footer,
        keyboardVisible: true,
      ),
    );

    expect(isShown(tester, headingHider), isTrue);
    expect(isShown(tester, buttonHider), isTrue);
    expect(isShown(tester, footerHider), isFalse);
  });

  testWidgets('header hides only the heading while the keyboard is open', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _BottomButtonNavBarTestApp(
        behavior: .header,
        keyboardVisible: true,
      ),
    );

    expect(isShown(tester, headingHider), isFalse);
    expect(isShown(tester, buttonHider), isTrue);
    expect(isShown(tester, footerHider), isTrue);
  });

  testWidgets('headerAndFooter hides both optional regions', (tester) async {
    await tester.pumpWidget(
      const _BottomButtonNavBarTestApp(
        behavior: .headerAndFooter,
        keyboardVisible: true,
      ),
    );

    expect(isShown(tester, headingHider), isFalse);
    expect(isShown(tester, buttonHider), isTrue);
    expect(isShown(tester, footerHider), isFalse);
  });

  Future<Rect> pumpInsetBar(
    WidgetTester tester, {
    required bool asBottomSheet,
    Widget? bottomNavigationBar,
    double keyboard = 0,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(bottom: keyboard > 0 ? 0 : 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
    tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
    addTearDown(tester.view.reset);

    final bar = GtButtonBottomNavBar(
      button: GtRaisedButton(
        key: const Key('button'),
        text: 'BUTTON',
        onPressed: () {},
      ),
    );

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: Scaffold(
            bottomSheet: asBottomSheet ? bar : null,
            bottomNavigationBar: asBottomSheet ? bottomNavigationBar : bar,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    return tester.getRect(find.byKey(const Key('button')));
  }

  testWidgets(
    'keeps the button above the system bottom inset as a bottom navigation bar',
    (tester) async {
      final button = await pumpInsetBar(tester, asBottomSheet: false);
      expect(button.bottom, closeTo(812 - 48 - 24, 1));
    },
  );

  testWidgets(
    'keeps the button above the system bottom inset as a bottom sheet',
    (tester) async {
      final button = await pumpInsetBar(tester, asBottomSheet: true);
      expect(button.bottom, closeTo(812 - 48 - 24, 1));
    },
  );

  testWidgets(
    'does not add the inset as a bottom sheet above a bottom navigation bar',
    (tester) async {
      final button = await pumpInsetBar(
        tester,
        asBottomSheet: true,
        bottomNavigationBar: const SizedBox(height: 56),
      );
      expect(button.bottom, closeTo(812 - 56 - 24, 1));
    },
  );

  testWidgets('sits just above the keyboard as a bottom sheet', (tester) async {
    final button = await pumpInsetBar(
      tester,
      asBottomSheet: true,
      keyboard: 300,
    );
    expect(button.bottom, closeTo(812 - 300 - 10, 1));
  });

  testWidgets('all hides every region while the keyboard is open', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _BottomButtonNavBarTestApp(behavior: .all, keyboardVisible: true),
    );

    expect(isShown(tester, headingHider), isFalse);
    expect(isShown(tester, buttonHider), isFalse);
    expect(isShown(tester, footerHider), isFalse);
  });
}
