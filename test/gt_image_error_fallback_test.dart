import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _url = GtNetworkImages.sampleAvatar1;
const _fallbackKey = Key('fallback');
const _fallback = SizedBox(key: _fallbackKey, width: 40, height: 40);

Widget _app(Widget child) => GtThemeProvider(
  theme: kPersonalTheme,
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

/// Pumps [child] and lets its image resolve, which for assets and bytes means
/// real asynchronous work outside the fake clock.
Future<void> _pumpAndResolve(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(_app(child));
  await tester.runAsync(() => Future<void>.delayed(Durations.short2));
  await tester.pump();
}

/// What the [CachedNetworkImage] under [finder] would draw if its download
/// failed. flutter_test neither completes nor fails a download, so the error
/// path is driven by hand.
Widget _networkErrorWidget(WidgetTester tester, [Finder? finder]) {
  final found = finder ?? find.byType(CachedNetworkImage);
  final image = tester.widget<CachedNetworkImage>(found);
  return image.errorWidget!(tester.element(found), _url, Exception());
}

/// An asset bundle whose loads fail after a gap, as they do on a device.
///
/// The test bundle throws synchronously for a missing asset, which skips the
/// path where `vector_graphics` leaks a failed load as an uncaught error.
class _AsyncFailingBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    await Future<void>.value();
    throw FlutterError('Unable to load asset: "$key".');
  }
}

void main() {
  setUpAll(registerTestAppConfig);

  group('atoms draw the fallback when their image fails', () {
    testWidgets('GtMemoryImage with undecodable bytes', (tester) async {
      await _pumpAndResolve(
        tester,
        GtMemoryImage(
          Uint8List.fromList([1, 2, 3]),
          width: 40,
          height: 40,
          errorWidget: _fallback,
        ),
      );

      expect(find.byKey(_fallbackKey), findsOneWidget);
    });

    testWidgets('GtAssetImage with a missing raster asset', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtAssetImage(
          'assets/missing.png',
          width: 40,
          height: 40,
          errorWidget: _fallback,
        ),
      );

      expect(find.byKey(_fallbackKey), findsOneWidget);
    });

    testWidgets('GtAssetImage with a missing vector asset', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtAssetImage(
          'assets/missing.svg',
          width: 40,
          height: 40,
          errorWidget: _fallback,
        ),
      );

      expect(find.byKey(_fallbackKey), findsOneWidget);
      expect(find.byType(GtImageShimmer), findsNothing);
    });

    testWidgets('a failed SVG stops shimmering even without a fallback', (
      tester,
    ) async {
      await _pumpAndResolve(
        tester,
        const GtSvg('assets/missing.svg', width: 40, height: 40),
      );

      expect(find.byType(GtImageShimmer), findsNothing);
    });

    testWidgets('every GtSvg sharing a failed graphic falls back, quietly', (
      tester,
    ) async {
      final uncaught = <Object>[];
      await runZonedGuarded(
        () => _pumpAndResolve(
          tester,
          DefaultAssetBundle(
            bundle: _AsyncFailingBundle(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GtSvg(
                  'assets/shared.svg',
                  width: 40,
                  height: 40,
                  errorWidget: SizedBox(key: Key('first'), width: 40),
                ),
                GtSvg(
                  'assets/shared.svg',
                  width: 40,
                  height: 40,
                  errorWidget: SizedBox(key: Key('second'), width: 40),
                ),
              ],
            ),
          ),
        ),
        (error, _) => uncaught.add(error),
      );
      await tester.pump();

      expect(uncaught, isEmpty);
      expect(find.byKey(const Key('first')), findsOneWidget);
      expect(find.byKey(const Key('second')), findsOneWidget);
    });

    testWidgets('GtNetworkImage with a malformed data URI', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtNetworkImage(
            'data:not base64!',
            width: 40,
            height: 40,
            errorWidget: _fallback,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(_fallbackKey), findsOneWidget);
    });

    testWidgets('a data URI fallback is annotated like the image it replaces', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          const GtNetworkImage(
            'data:not base64!',
            semanticsLabel: 'Stash picture',
            errorWidget: _fallback,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Stash picture'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('GtNetworkImage with a failed download', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtNetworkImage(
            _url,
            width: 40,
            height: 40,
            errorWidget: _fallback,
          ),
        ),
      );

      expect(_networkErrorWidget(tester), same(_fallback));
    });
  });

  group('without a fallback, a failed image draws its empty variant', () {
    const missing = AppImageData('assets/missing.png');

    /// The [AppImageData] values drawn by every [GtImage] on screen.
    List<Object?> drawnImages(WidgetTester tester) => tester
        .widgetList<GtImage>(find.byType(GtImage))
        .map((image) => image.image?.imageData)
        .toList();

    testWidgets('GtMemoryImage and GtAssetImage fail quietly', (tester) async {
      await _pumpAndResolve(
        tester,
        Column(
          children: [
            GtMemoryImage(Uint8List.fromList([1, 2, 3]), width: 40, height: 40),
            const GtAssetImage('assets/missing.png', width: 40, height: 40),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('GtNetworkImage does not throw on a malformed data URI', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const GtNetworkImage('data:not base64!', width: 40, height: 40)),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(GtMemoryImage), findsNothing);
    });

    testWidgets('GtImage hands down its own empty placeholder box', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const GtImage(image: missing, width: 40, height: 40)),
      );

      final asset = tester.widget<GtAssetImage>(find.byType(GtAssetImage));
      expect(asset.errorWidget, isA<Align>());
    });

    testWidgets('a user GtAvatar shows its placeholder asset', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtAvatar(avatar: missing, isUserAvatar: true, size: 40),
      );

      expect(drawnImages(tester), contains(GtAssetImages.avatar));
    });

    testWidgets('a GtAvatar with initials leaves them showing', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtAvatar(
          avatar: missing,
          initials: 'HS',
          isUserAvatar: true,
          size: 40,
        ),
      );

      expect(find.text('HS'), findsOneWidget);
      expect(drawnImages(tester), isNot(contains(GtAssetImages.avatar)));
    });

    testWidgets('a user GtSquareAvatar shows the user glyph', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtSquareAvatar(avatar: missing, isUserAvatar: true, size: 72),
      );

      expect(
        tester
            .widgetList<GtIcon>(find.byType(GtIcon))
            .any((icon) => icon.icon == GtIcons.userSolid),
        isTrue,
      );
    });

    testWidgets('any other GtSquareAvatar shows the default artwork', (
      tester,
    ) async {
      await _pumpAndResolve(
        tester,
        const GtSquareAvatar(avatar: missing, size: 72),
      );

      expect(drawnImages(tester), contains(GtNetworkImages.avatar3d2));
    });
  });

  group('GtImage', () {
    testWidgets('forwards the fallback to a network image', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtImage(
            image: AppImageData(_url),
            width: 40,
            height: 40,
            errorWidget: _fallback,
          ),
        ),
      );

      expect(_networkErrorWidget(tester), same(_fallback));
    });

    testWidgets('forwards the fallback to an asset image', (tester) async {
      await _pumpAndResolve(
        tester,
        const GtImage(
          image: AppImageData('assets/missing.png'),
          width: 40,
          height: 40,
          errorWidget: _fallback,
        ),
      );

      expect(find.byKey(_fallbackKey), findsOneWidget);
    });

    testWidgets('keeps the empty box when there is no image at all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const GtImage(width: 40, height: 40, errorWidget: _fallback)),
      );

      expect(find.byKey(_fallbackKey), findsNothing);
    });
  });

  group('avatars', () {
    testWidgets('GtAvatar forwards the fallback to its image', (tester) async {
      await tester.pumpWidget(
        _app(
          const GtAvatar(
            avatar: AppImageData(_url),
            size: 40,
            errorWidget: _fallback,
          ),
        ),
      );

      expect(_networkErrorWidget(tester), same(_fallback));
    });

    testWidgets('GtSquareAvatar forwards the fallback to its image', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const GtSquareAvatar(
            avatar: AppImageData(_url),
            size: 72,
            errorWidget: _fallback,
          ),
        ),
      );

      expect(_networkErrorWidget(tester), same(_fallback));
    });
  });

  group('GtTransferField participant legs', () {
    const fallbackImage = AppImageData(GtVectors.dashedPlaceholder);

    Widget field(GtTransferParticipantImageType imageType) {
      return SingleChildScrollView(
        child: GtTransferField(
          amountController: GtInputController(),
          noteController: GtInputController(),
          firstParticipant: GtTransferParticipantData(
            name: 'Holiday stash',
            label: 'From',
            image: const AppImageData(_url),
            errorImage: fallbackImage,
            imageType: imageType,
            validate: false,
          ),
          secondParticipant: GtTransferParticipantData.empty(label: 'To'),
          noteHint: 'Note',
        ),
      );
    }

    for (final imageType in GtTransferParticipantImageType.values) {
      testWidgets('an ${imageType.name} leg draws its error image on failure', (
        tester,
      ) async {
        await tester.pumpWidget(_app(field(imageType)));

        final fallback = _networkErrorWidget(tester);

        expect(fallback, isA<GtImage>());
        expect((fallback as GtImage).image, fallbackImage);
      });
    }

    test('copyWith carries the tag and tap handler over', () {
      void onTap() {}
      final data = GtTransferParticipantData(
        label: 'From',
        image: const AppImageData(_url),
        tag: fallbackImage,
        onTap: onTap,
        validate: false,
      );
      final copy = data.copyWith(name: 'Holiday stash');

      expect(copy.tag, fallbackImage);
      expect(copy.onTap, same(onTap));
      expect(
        data,
        isNot(data.copyWith(tag: const AppImageData(GtAssetImages.avatar))),
      );
    });

    test('errorImage survives copyWith and counts toward equality', () {
      final data = GtTransferParticipantData(
        label: 'From',
        image: const AppImageData(_url),
        errorImage: fallbackImage,
        validate: false,
      );

      expect(data.copyWith(name: 'Holiday stash').errorImage, fallbackImage);
      expect(
        data,
        isNot(
          data.copyWith(errorImage: const AppImageData(GtAssetImages.avatar)),
        ),
      );
    });
  });
}
