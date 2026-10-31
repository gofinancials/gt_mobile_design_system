import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

final Uint8List _transparentPng = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

Widget _slides({
  int count = 4,
  List<String>? titles,
  VoidCallback? onPrimary,
  GlobalKey<NavigatorState>? navigatorKey,
  Duration slideDuration = const Duration(seconds: 5),
  Color? activeProgressColor,
  Color? inActiveProgressColor,
}) {
  final slideTitles = titles ?? [for (var i = 0; i < count; i++) 'Slide $i'];
  return GtThemeProvider(
    theme: kPersonalTheme,
    child: MaterialApp(
      navigatorKey: navigatorKey,
      home: GtOnboardingSlides(
        slides: [
          for (final title in slideTitles)
            GtOnboardingSlideData(
              title: title,
              image: MemoryImage(_transparentPng),
            ),
        ],
        slideDuration: slideDuration,
        activeProgressColor: activeProgressColor,
        inActiveProgressColor: inActiveProgressColor,
        footerText: 'Footer',
        primaryButton: GtRaisedButton(
          onPressed: onPrimary ?? () {},
          text: 'Primary',
        ),
        secondaryButton: GtOutlineButton(onPressed: () {}, text: 'Secondary'),
      ),
    ),
  );
}

/// Pumps [duration] a frame at a time. The progress line runs for as long as
/// the carousel is shown, so `pumpAndSettle` would never return.
Future<void> _pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration frame = const Duration(milliseconds: 50),
}) async {
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += frame) {
    await tester.pump(frame);
  }
}

double _progress(WidgetTester tester) {
  return tester
      .widget<GtProgress>(find.byType(GtProgress, skipOffstage: false))
      .value!;
}

PageController _pageController(WidgetTester tester) {
  return tester
      .widget<PageView>(find.byType(PageView, skipOffstage: false))
      .controller!;
}

double _opacityOf(WidgetTester tester, String text) {
  final fade = tester.widget<FadeTransition>(
    find
        .ancestor(of: find.text(text), matching: find.byType(FadeTransition))
        .first,
  );
  return fade.opacity.value;
}

void main() {
  group('GtOnboardingSlides', () {
    testWidgets('swipes between slides by hand', (WidgetTester tester) async {
      await tester.pumpWidget(_slides());

      expect(find.text('SLIDE 0'), findsOneWidget);

      // Start on the overlay's gradient, and again on the title, which both
      // sit above the page view.
      await tester.flingFrom(
        const Offset(700, 150),
        const Offset(-500, 0),
        1000,
      );
      await _pumpFor(tester, const Duration(seconds: 1));
      expect(
        _pageController(tester).page,
        _pageController(tester).initialPage + 1,
      );

      await tester.flingFrom(
        tester.getCenter(find.text('SLIDE 1')),
        const Offset(-500, 0),
        1000,
      );
      await _pumpFor(tester, const Duration(seconds: 1));
      expect(
        _pageController(tester).page,
        _pageController(tester).initialPage + 2,
      );
      expect(find.text('SLIDE 2'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('keeps the buttons tappable above the page view', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(_slides(onPrimary: () => taps++));

      await tester.tap(find.byType(GtRaisedButton));
      await tester.pump();

      expect(taps, 1);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('neither swipes nor shows progress for a single slide', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_slides(count: 1));
      final controller = _pageController(tester);
      final page = controller.page;

      expect(find.byType(GtProgress), findsNothing);

      await tester.flingFrom(
        const Offset(700, 150),
        const Offset(-500, 0),
        1000,
      );
      await tester.pumpAndSettle();

      expect(controller.page, page);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('replaces the dots with a progress line that fills per slide', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_slides());

      expect(find.byType(GtDots), findsNothing);
      expect(_progress(tester), 0);

      await _pumpFor(tester, const Duration(milliseconds: 2500));
      expect(_progress(tester), closeTo(0.5, 0.05));

      // The slide's time runs out at 5s and the next one starts its own.
      await _pumpFor(tester, const Duration(milliseconds: 3500));
      expect(
        _pageController(tester).page,
        _pageController(tester).initialPage + 1,
      );
      expect(_progress(tester), lessThan(0.3));

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('shows each slide for the slideDuration it is given', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _slides(slideDuration: const Duration(seconds: 2)),
      );

      await _pumpFor(tester, const Duration(seconds: 1));
      expect(_progress(tester), closeTo(0.5, 0.05));
      expect(_pageController(tester).page, _pageController(tester).initialPage);

      await _pumpFor(tester, const Duration(seconds: 2));
      expect(
        _pageController(tester).page,
        _pageController(tester).initialPage + 1,
      );

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('colours the progress line as given', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _slides(
          activeProgressColor: Colors.red,
          inActiveProgressColor: Colors.blue,
        ),
      );

      final progress = tester.widget<GtProgress>(find.byType(GtProgress));
      expect(progress.color, Colors.red);
      expect(progress.inactiveColor, Colors.blue);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('holds the progress while a finger is down', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_slides());
      await _pumpFor(tester, const Duration(seconds: 1));

      final gesture = await tester.startGesture(const Offset(400, 150));
      final held = _progress(tester);
      await _pumpFor(tester, const Duration(seconds: 5));

      expect(_progress(tester), held);
      expect(_pageController(tester).page, _pageController(tester).initialPage);

      await gesture.up();
      await _pumpFor(tester, const Duration(seconds: 1));

      expect(_progress(tester), greaterThan(held));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('holds the progress while another route covers it', (
      WidgetTester tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(_slides(navigatorKey: navigator));
      await _pumpFor(tester, const Duration(seconds: 1));

      navigator.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => const SizedBox()),
      );
      await _pumpFor(tester, const Duration(seconds: 1));
      final covered = _progress(tester);
      final page = _pageController(tester).page;

      await _pumpFor(tester, const Duration(seconds: 10));
      expect(_progress(tester), covered);
      expect(_pageController(tester).page, page);

      navigator.currentState!.pop();
      await _pumpFor(tester, const Duration(seconds: 1));

      expect(_progress(tester), greaterThan(covered));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('fades the outgoing title out in place before the next shows', (
      WidgetTester tester,
    ) async {
      const longTitle =
          'A much longer title that wraps over several lines of the slide';
      await tester.pumpWidget(_slides(titles: ['Short', longTitle]));
      final restingBottom = tester.getBottomLeft(find.text('SHORT')).dy;
      final controller = _pageController(tester);

      controller.jumpToPage(controller.initialPage + 1);
      final transition = tester.widget<AnimatedCrossFade>(
        find
            .ancestor(
              of: find.text('SHORT'),
              matching: find.byType(AnimatedCrossFade),
            )
            .first,
      );
      final duration = transition.duration;

      await tester.pump();
      await tester.pump(duration * 0.25);
      // The box above grows for the taller title, but the outgoing one keeps
      // its place above the buttons rather than riding up with the box's top.
      expect(tester.getBottomLeft(find.text('SHORT')).dy, restingBottom);
      expect(_opacityOf(tester, 'SHORT'), greaterThan(0));
      expect(_opacityOf(tester, longTitle.toUpperCase()), 0);

      await tester.pump(duration * 0.5);
      expect(_opacityOf(tester, 'SHORT'), 0);

      await tester.pumpWidget(const SizedBox());
    });

    // Fractional logical widths such as 1080px at 2.625 put page edges where a
    // large scroll offset cannot hold them exactly, which tripped the sliver's
    // layout assertion every few pages. Run the auto-advance far enough to be
    // brought back at least once and expect no assertion along the way.
    for (final (width, ratio) in [(1080.0, 2.625), (2732.0, 2.0)]) {
      testWidgets('auto-advances cleanly at ${width / ratio} dp wide', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = Size(width, 2400);
        tester.view.devicePixelRatio = ratio;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_slides());
        final controller = _pageController(tester);
        final start = controller.initialPage;
        var last = controller.page!;
        var furthest = 0.0;
        var recentres = 0;

        // About 70 advances: past the 50 pages the carousel may wander.
        for (var frame = 0; frame < 3800; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
          final page = controller.page!;
          if (page < last - 10) recentres++;
          final distance = (page - start).abs();
          if (distance > furthest) furthest = distance;
          last = page;
        }

        expect(recentres, greaterThan(0));
        expect(furthest, lessThanOrEqualTo(51));
        await tester.pumpWidget(const SizedBox());
      });
    }

    testWidgets('uses virtual pages for a smooth last-to-first transition', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: GtOnboardingSlides(
              slides: [
                GtOnboardingSlideData(
                  title: 'First',
                  image: MemoryImage(_transparentPng),
                ),
                GtOnboardingSlideData(
                  title: 'Second',
                  image: MemoryImage(_transparentPng),
                ),
              ],
              footerText: 'Footer',
              primaryButton: GtRaisedButton(onPressed: () {}, text: 'Primary'),
              secondaryButton: GtOutlineButton(
                onPressed: () {},
                text: 'Secondary',
              ),
            ),
          ),
        ),
      );

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller!.initialPage, greaterThan(0));
      expect(pageView.childrenDelegate.estimatedChildCount, isNull);

      pageView.controller!.jumpToPage(pageView.controller!.initialPage + 2);
      await _pumpFor(tester, const Duration(seconds: 1));

      expect(find.text('FIRST'), findsOneWidget);
      final overlayTransition = tester.widget<AnimatedCrossFade>(
        find
            .ancestor(
              of: find.text('FIRST'),
              matching: find.byType(AnimatedCrossFade),
            )
            .first,
      );
      expect(overlayTransition.duration, GtMotion.fluid);
      expect(overlayTransition.sizeCurve, Curves.easeInOutCubic);
      expect(overlayTransition.alignment, Alignment.bottomCenter);
      expect(
        find.ancestor(
          of: find.text('FIRST'),
          matching: find.byType(AnimatedSwitcher),
        ),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('blurs only the wide background copy', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: GtOnboardingSlides(
              slides: [
                GtOnboardingSlideData(
                  title: 'Wide slide',
                  image: MemoryImage(_transparentPng),
                ),
              ],
              footerText: 'Footer',
              primaryButton: GtRaisedButton(onPressed: () {}, text: 'Primary'),
              secondaryButton: GtOutlineButton(
                onPressed: () {},
                text: 'Secondary',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsNothing);
      expect(find.byType(ImageFiltered), findsWidgets);

      final containedImage = find.byWidgetPredicate((widget) {
        if (widget case DecoratedBox(decoration: final BoxDecoration box)) {
          return box.image?.fit == BoxFit.contain;
        }
        return false;
      }).first;

      expect(
        find.ancestor(of: containedImage, matching: find.byType(ImageFiltered)),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('passes footerTextColor and footerLinkColor to GtRichText', (
      WidgetTester tester,
    ) async {
      const customTextColor = Colors.red;
      const customLinkColor = Colors.blue;

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: GtOnboardingSlides(
              slides: [
                GtOnboardingSlideData(
                  title: 'Test Slide',
                  image: MemoryImage(_transparentPng),
                ),
              ],
              footerText: "Agree to <a href='https://example.com'>Terms</a>",
              primaryButton: GtRaisedButton(onPressed: () {}, text: 'Primary'),
              secondaryButton: GtOutlineButton(
                onPressed: () {},
                text: 'Secondary',
              ),
              footerTextColor: customTextColor,
              footerLinkColor: customLinkColor,
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(GtRichText);
      expect(richTextFinder, findsOneWidget);

      final GtRichText richText = tester.widget(richTextFinder);
      expect(richText.linkColor, customLinkColor);
      expect(richText.style?.color, customTextColor);

      await tester.pumpWidget(const SizedBox());
    });
  });
}
