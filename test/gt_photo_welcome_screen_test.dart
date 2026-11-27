import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A one-pixel transparent PNG.
final _photo = MemoryImage(
  base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQAB'
    'h6FO1AAAAABJRU5ErkJggg==',
  ),
);

const _welcome = GtPhotoWelcomeSlideData(
  title: 'Banking for every day',
  description: 'Send money, pay bills and save for what matters.',
  image: AssetImage('unused'),
);

void main() {
  /// Pumps a [GtPhotoWelcomeScreen] of [slides] on a 375 by 812 phone.
  Future<void> pumpScreen(
    WidgetTester tester, {
    List<GtPhotoWelcomeSlideData>? slides,
    Widget? header,
    VoidCallback? onPrimary,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 44, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: GtPhotoWelcomeScreen(
            slides: [
              for (final slide in slides ?? [_welcome])
                GtPhotoWelcomeSlideData(
                  title: slide.title,
                  description: slide.description,
                  image: _photo,
                ),
            ],
            header: header,
            footerText: 'By continuing, you agree to the terms.',
            primaryButton: GtRaisedButton(
              onPressed: onPrimary ?? () {},
              text: 'Open an account',
            ),
            secondaryButton: GtOutlineButton(onPressed: () {}, text: 'Log in'),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  PageController pageController(WidgetTester tester) =>
      tester.widget<PageView>(find.byType(PageView)).controller!;

  /// The opacity the cross-fade gives [text].
  double opacityOf(WidgetTester tester, String text) {
    final fade = tester.widget<FadeTransition>(
      find
          .ancestor(of: find.text(text), matching: find.byType(FadeTransition))
          .first,
    );
    return fade.opacity.value;
  }

  const stash = GtPhotoWelcomeSlideData(
    title: 'Save for what matters',
    image: AssetImage('unused'),
  );

  testWidgets('draws the lockup above a mixed-case title and description', (
    tester,
  ) async {
    await pumpScreen(tester);

    final lockup = find.byWidgetPredicate(
      (widget) =>
          widget is GtSvg &&
          widget.path == GtVectors.whiteOneBankBySterlingLockup,
    );
    expect(lockup, findsOneWidget);
    expect(tester.getTopLeft(lockup).dy, 44 + 24);
    expect(tester.getSize(lockup), const Size(144, 44));

    expect(find.text('Banking for every day'), findsOneWidget);
    expect(
      find.text('Send money, pay bills and save for what matters.'),
      findsOneWidget,
    );
    expect(
      tester.getBottomLeft(find.text('Banking for every day')).dy,
      lessThan(tester.getTopLeft(find.byType(GtRaisedButton)).dy),
    );
  });

  testWidgets('a header replaces the lockup', (tester) async {
    await pumpScreen(tester, header: const Text('Header'));

    expect(find.text('Header'), findsOneWidget);
    expect(find.byType(GtSvg), findsNothing);
  });

  testWidgets('leaves out a missing description', (tester) async {
    await pumpScreen(tester, slides: [stash]);

    final title = tester.getBottomLeft(find.text('Save for what matters'));
    final bar = tester.getTopLeft(find.byType(GtButtonBottomNavBar));
    expect(bar.dy - title.dy, 32);
  });

  testWidgets('never advances on its own and draws no progress line', (
    tester,
  ) async {
    await pumpScreen(tester, slides: [_welcome, stash]);

    await tester.pump(const Duration(seconds: 30));
    await tester.pumpAndSettle();

    expect(pageController(tester).page, 0);
    expect(find.text('Banking for every day'), findsOneWidget);
    expect(find.byType(GtProgress), findsNothing);
  });

  testWidgets('swipes to the next slide from the text, and stops at the last', (
    tester,
  ) async {
    await pumpScreen(tester, slides: [_welcome, stash]);

    await tester.flingFrom(
      tester.getCenter(find.text('Banking for every day')),
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(pageController(tester).page, 1);
    expect(opacityOf(tester, 'Save for what matters'), 1);
    expect(opacityOf(tester, 'Banking for every day'), 0);

    await tester.flingFrom(const Offset(300, 150), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();

    expect(pageController(tester).page, 1);
  });

  testWidgets('keeps the buttons tappable above the photograph', (
    tester,
  ) async {
    var taps = 0;
    await pumpScreen(tester, onPrimary: () => taps++);

    await tester.tap(find.byType(GtRaisedButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('gives the system bars light icons', (tester) async {
    await pumpScreen(tester);

    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).last,
    );
    expect(region.value.statusBarIconBrightness, Brightness.light);
    expect(region.value.statusBarBrightness, Brightness.dark);
    expect(region.value.systemNavigationBarIconBrightness, Brightness.light);
  });
}
