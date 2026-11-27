import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _url = 'https://example.com/profile/photo.jpg';

/// A cache manager that records removals and never finishes a download, so
/// an image it is asked for stays loading.
class _FakeCacheManager implements BaseCacheManager {
  final List<String> removed = [];

  @override
  Future<void> removeFile(String key) async => removed.add(key);

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) {
    return StreamController<FileResponse>().stream;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(registerTestAppConfig);

  late _FakeCacheManager cacheManager;

  // Not restored: reading the default would build the real cache manager,
  // which needs path_provider, and each test file runs in its own isolate.
  setUp(() {
    cacheManager = _FakeCacheManager();
    CachedNetworkImageProvider.defaultCacheManager = cacheManager;
    PaintingBinding.instance.imageCache.clear();
  });

  tearDown(() {
    PaintingBinding.instance.imageCache.clear();
  });

  /// Puts [image] in the [ImageCache] as [provider]'s picture.
  Future<Object> cache(ImageProvider<Object> provider, ImageInfo image) async {
    final key = await provider.obtainKey(ImageConfiguration.empty);
    PaintingBinding.instance.imageCache.putIfAbsent(
      key,
      () => OneFrameImageStreamCompleter(SynchronousFuture(image)),
    );
    return key;
  }

  /// Draws a 40 dp wide [GtNetworkImage] of [_url] at a device pixel ratio
  /// of 3, which decodes it 120 px wide.
  Future<void> pumpImage(WidgetTester tester) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              devicePixelRatio: 3,
            ),
            child: const Scaffold(
              body: Center(
                child: GtNetworkImage(
                  _url,
                  width: 40,
                  showLoadingIndicator: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  /// The picture the [RawImage] on screen paints, if any.
  Object? painted(WidgetTester tester) {
    final raw = find.byType(RawImage);
    if (raw.evaluate().isEmpty) return null;
    return tester.widget<RawImage>(raw).image;
  }

  testWidgets('evict removes the file and every decoded copy, and the image '
      'on screen loads again', (tester) async {
    final image = await tester.runAsync(() => createTestImage(width: 120));
    final provider = CachedNetworkImageProvider(_url);
    final resized = ResizeImage.resizeIfNeeded(120, null, provider);

    final resizedKey = (await tester.runAsync(
      () => cache(resized, ImageInfo(image: image!.clone())),
    ))!;
    final fullKey = (await tester.runAsync(
      () => cache(provider, ImageInfo(image: image!.clone())),
    ))!;

    await pumpImage(tester);
    expect(painted(tester), isNotNull);

    final before = tester.element(find.byType(CachedNetworkImage));
    await tester.runAsync(() => GtNetworkImage.evict(_url));

    final imageCache = PaintingBinding.instance.imageCache;
    expect(cacheManager.removed, [_url]);
    expect(imageCache.containsKey(resizedKey), isFalse);
    expect(imageCache.containsKey(fullKey), isFalse);

    await tester.pump();
    expect(tester.element(find.byType(CachedNetworkImage)), isNot(before));
    expect(painted(tester), isNull);
  });

  testWidgets('evicting another address leaves the image alone', (
    tester,
  ) async {
    final image = await tester.runAsync(() => createTestImage(width: 120));
    final resized = ResizeImage.resizeIfNeeded(
      120,
      null,
      CachedNetworkImageProvider(_url),
    );
    final resizedKey = (await tester.runAsync(
      () => cache(resized, ImageInfo(image: image!)),
    ))!;

    await pumpImage(tester);
    final before = tester.element(find.byType(CachedNetworkImage));

    await tester.runAsync(
      () => GtNetworkImage.evict('https://example.com/other.jpg'),
    );
    await tester.pump();

    expect(PaintingBinding.instance.imageCache.containsKey(resizedKey), isTrue);
    expect(tester.element(find.byType(CachedNetworkImage)), same(before));
    expect(painted(tester), isNotNull);
  });
}
