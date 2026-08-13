import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/templates/slides/gt_onboarding_slides.dart';

final Uint8List _transparentPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
]);

void main() {
  group('GtOnboardingSlides', () {
    testWidgets('passes footerTextColor and footerLinkColor to GtRichText',
        (WidgetTester tester) async {
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
              footerText:
                  "Agree to <a href='https://example.com'>Terms</a>",
              primaryButton: GtRaisedButton(
                onPressed: () {},
                text: 'Primary',
              ),
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

