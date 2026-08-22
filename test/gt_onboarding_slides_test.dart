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

void main() {
  group('GtOnboardingSlides', () {
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
      await tester.pumpAndSettle();

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
