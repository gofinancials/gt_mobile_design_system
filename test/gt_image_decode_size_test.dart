import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _url = GtNetworkImages.sampleAvatar1;

/// A screen 400 dp wide at a device pixel ratio of 3.
const _media = MediaQueryData(size: Size(400, 800), devicePixelRatio: 3);

void main() {
  setUpAll(registerTestAppConfig);

  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: MediaQuery(
            data: _media,
            child: Scaffold(body: Center(child: child)),
          ),
        ),
      ),
    );
  }

  /// The decode size the [CachedNetworkImage] in the tree was handed.
  (int?, int?) networkDecode(WidgetTester tester) {
    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    return (image.memCacheWidth, image.memCacheHeight);
  }

  /// The decode size the [Image] in the tree resizes to.
  (int?, int?) imageDecode(WidgetTester tester) {
    final provider = tester.widget<Image>(find.byType(Image)).image;
    expect(provider, isA<ResizeImage>());
    final resize = provider as ResizeImage;
    return (resize.width, resize.height);
  }

  group('GtNetworkImage', () {
    testWidgets('pins the height of a square slot', (tester) async {
      await pump(tester, const GtNetworkImage(_url, width: 24, height: 24));

      expect(networkDecode(tester), (null, 72));
    });

    testWidgets('pins the longer side of the slot', (tester) async {
      await pump(tester, const GtNetworkImage(_url, width: 100, height: 50));

      expect(networkDecode(tester), (300, null));
    });

    testWidgets('pins the only dimension given', (tester) async {
      await pump(tester, const GtNetworkImage(_url, width: 30));
      expect(networkDecode(tester), (90, null));

      await pump(tester, const GtNetworkImage(_url, height: 30));
      expect(networkDecode(tester), (null, 90));
    });

    testWidgets('caps an unsized image at the screen width', (tester) async {
      await pump(tester, const GtNetworkImage(_url));

      expect(networkDecode(tester), (1200, null));
    });

    testWidgets('treats an unbounded dimension as unknown', (tester) async {
      await pump(
        tester,
        const GtNetworkImage(_url, width: double.infinity, height: 40),
      );

      expect(networkDecode(tester), (null, 120));
    });

    testWidgets('lays out under an IntrinsicHeight when unsized', (
      tester,
    ) async {
      await pump(tester, const IntrinsicHeight(child: GtNetworkImage(_url)));

      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('GtMemoryImage decodes at the drawn size', (tester) async {
    await pump(
      tester,
      GtMemoryImage(Uint8List(0), width: 24, height: 24, isDecorative: true),
    );

    expect(imageDecode(tester), (null, 72));
  });

  testWidgets('GtFileImage decodes at the drawn size', (tester) async {
    await pump(
      tester,
      GtFileImage(File('missing.png'), width: 40, isDecorative: true),
    );

    expect(imageDecode(tester), (120, null));
  });
}
