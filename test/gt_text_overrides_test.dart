import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  const customStyle = TextStyle(fontSize: 19, color: Colors.teal);

  Widget app(Widget child) {
    return GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  TextStyle textStyle(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text).first).style!;
  }

  group('GtModalAppBar.extended', () {
    testWidgets('draws the title in the given style', (tester) async {
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            home: Scaffold(
              appBar: GtModalAppBar.extended(
                title: 'Choose image',
                action: null,
                style: customStyle,
              ),
            ),
          ),
        ),
      );

      final style = textStyle(tester, 'CHOOSE IMAGE');
      expect(style.fontSize, 19);
      expect(style.color, Colors.teal);
    });
  });

  group('GtSectionHeader', () {
    testWidgets('uppercases the title by default', (tester) async {
      await tester.pumpWidget(app(const GtSectionHeader('Personal details')));

      expect(find.text('PERSONAL DETAILS'), findsOneWidget);
    });

    testWidgets('keeps the title as written with GtTextCase.none', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(const GtSectionHeader('Personal details', titleCase: .none)),
      );

      expect(find.text('Personal details'), findsOneWidget);
    });
  });

  group('GtSectionSlide', () {
    testWidgets('passes the title style to its header', (tester) async {
      await tester.pumpWidget(
        app(
          const GtSectionSlide(
            title: 'Gallery',
            titleStyle: customStyle,
            children: [GtText('item')],
          ),
        ),
      );

      final header = tester.widget<GtSectionHeader>(
        find.byType(GtSectionHeader),
      );
      expect(header.style, customStyle);
      expect(textStyle(tester, 'GALLERY').fontSize, 19);
    });
  });

  group('GtDebitCardScreen', () {
    final illustration = find.descendant(
      of: find.byType(GtImage),
      matching: find.byType(GtAssetImage),
    );

    Widget screen({
      TextStyle? titleStyle,
      TextStyle? subtitleStyle,
      TextAlign textAlign = .start,
      DecorationImage? backgroundImage,
      double? titleSpacingPx,
      Alignment imageAlignment = .centerRight,
      double? imageWidth,
      double? imageHeight,
    }) {
      return GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: GtDebitCardScreen(
            title: 'Your card',
            subtitle: 'Spend anywhere',
            button: GtRaisedButton(text: 'Continue', onPressed: () {}),
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            textAlign: textAlign,
            backgroundImage: backgroundImage,
            titleSpacingPx: titleSpacingPx,
            imageAlignment: imageAlignment,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
          ),
        ),
      );
    }

    testWidgets('keeps start-aligned text and no background image', (
      tester,
    ) async {
      await tester.pumpWidget(screen());

      final title = tester.widget<Text>(find.text('YOUR CARD'));
      expect(title.textAlign, TextAlign.start);
      expect(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });

    testWidgets('applies the given styles and alignment', (tester) async {
      await tester.pumpWidget(
        screen(
          titleStyle: customStyle,
          subtitleStyle: const TextStyle(fontSize: 16),
          textAlign: .center,
        ),
      );

      final title = tester.widget<Text>(find.text('YOUR CARD'));
      final subtitle = tester.widget<Text>(find.text('Spend Anywhere'));
      expect(title.textAlign, TextAlign.center);
      expect(title.style!.fontSize, 19);
      expect(subtitle.textAlign, TextAlign.center);
      expect(subtitle.style!.fontSize, 16);
    });

    testWidgets('paints the background image behind the content', (
      tester,
    ) async {
      final image = DecorationImage(
        image: MemoryImage(kTransparentImage),
        fit: .cover,
      );
      await tester.pumpWidget(screen(backgroundImage: image));

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect((box.decoration as BoxDecoration).image, image);
    });

    testWidgets('spaces the title and subtitle by titleSpacingPx', (
      tester,
    ) async {
      await tester.pumpWidget(screen(titleSpacingPx: 12));

      final context = tester.element(find.text('YOUR CARD'));
      final gap =
          tester.getTopLeft(find.text('Spend Anywhere')).dy -
          tester.getBottomLeft(find.text('YOUR CARD')).dy;
      expect(gap, context.dp(12.px));
    });

    testWidgets('hugs the right edge with the image by default', (
      tester,
    ) async {
      await tester.pumpWidget(screen());

      final screenWidth = tester.getSize(find.byType(Scaffold)).width;
      expect(tester.getTopRight(illustration).dx, screenWidth);
    });

    testWidgets('sizes the image with imageWidth and imageHeight', (
      tester,
    ) async {
      await tester.pumpWidget(screen(imageWidth: 200, imageHeight: 120));

      final asset = tester.widget<GtAssetImage>(illustration);
      expect(asset.width, 200);
      expect(asset.height, 120);
    });

    testWidgets('centres the image with imageAlignment', (tester) async {
      await tester.pumpWidget(screen(imageAlignment: .center));

      final screenWidth = tester.getSize(find.byType(Scaffold)).width;
      expect(tester.getCenter(illustration).dx, screenWidth / 2);
    });
  });

  group('GtGuageChartCenter', () {
    testWidgets('keeps the default pill fill', (tester) async {
      await tester.pumpWidget(
        app(const GtGuageChartCenter('₦20,000', pillText: 'Used')),
      );

      final pill = tester.widget<GtPill>(find.byType(GtPill));
      final context = tester.element(find.byType(GtPill));
      expect(pill.bgColor, context.palette.bg.weak);
    });

    testWidgets('applies the pill and footer overrides', (tester) async {
      const pillStyle = TextStyle(fontSize: 12, color: Colors.black);
      const footerStyle = TextStyle(fontSize: 12, color: Colors.grey);
      await tester.pumpWidget(
        app(
          const GtGuageChartCenter(
            '₦20,000',
            pillText: 'Used',
            footerText: 'of ₦50,000',
            pillColor: Colors.white,
            pillTextStyle: pillStyle,
            footerStyle: footerStyle,
          ),
        ),
      );

      final pill = tester.widget<GtPill>(find.byType(GtPill));
      expect(pill.bgColor, Colors.white);
      expect(pill.textStyle, pillStyle);
      expect(textStyle(tester, 'of ₦50,000'), footerStyle);
    });

    testWidgets('applies the value style, with valueColor winning', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const GtGuageChartCenter(
            '₦20,000',
            valueStyle: customStyle,
            valueColor: Colors.red,
          ),
        ),
      );

      final style = textStyle(tester, '₦20,000');
      expect(style.fontSize, 19);
      expect(style.color, Colors.red);
    });
  });

  group('GtTextStyles.d3_5', () {
    testWidgets('sets Youth 40 on a 40 line with no tracking', (tester) async {
      await tester.pumpWidget(app(const SizedBox()));

      final context = tester.element(find.byType(SizedBox));
      final style = context.textStyles.d3_5();
      expect(style.fontSize, 40);
      expect(style.height, 1);
      expect(style.letterSpacing, 0);
    });
  });

  group('GtTipCard', () {
    testWidgets('draws the close button when onClose is given', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        app(GtTipCard(title: 'Tip', onClose: () => closed = true)),
      );

      await tester.tap(find.byType(GtCancelButton));
      expect(closed, isTrue);
    });

    testWidgets('draws no close button without onClose', (tester) async {
      await tester.pumpWidget(app(const GtTipCard(title: 'Tip')));

      expect(find.text('Tip'), findsOneWidget);
      expect(find.byType(GtCancelButton), findsNothing);
    });
  });
}

final kTransparentImage = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);
