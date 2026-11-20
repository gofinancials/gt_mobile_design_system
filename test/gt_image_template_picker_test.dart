import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

const _svgFolder = 'assets/images/vector/illustrations';

Widget _app(GtTheme theme, Widget child) => GtThemeProvider(
  theme: theme,
  child: MaterialApp(
    theme: theme.materialLight,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  ),
);

/// Pumps a tree themed with [palette] and returns a context inside it.
Future<BuildContext> _contextFor(WidgetTester tester, GtPalette palette) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [palette]),
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured;
}

/// The URLs of the template tiles on screen, in order.
List<String> _tileUrls(WidgetTester tester) => tester
    .widgetList<GtImage>(find.byType(GtImage))
    .map((image) => image.image!.imageData as String)
    .toList();

Finder _tab(String label) => find.byWidgetPredicate(
  (widget) => widget is GtTabPill && widget.text == label,
);

void main() {
  setUpAll(registerTestAppConfig);

  group('illustration templates', () {
    test('each one is drawn from a DS illustration of the same name', () {
      for (final (:label, :value) in GtNetworkImages.illustrationTemplates) {
        final name = value.split('/').last.replaceFirst('.webp', '');
        expect(
          File('$_svgFolder/$name.svg').existsSync(),
          isTrue,
          reason: label,
        );
        expect(
          File('$_svgFolder/red/$name.svg').existsSync(),
          isTrue,
          reason: '$label has no red SVG to draw its red template from',
        );
      }
    });

    testWidgets('adapt to red under a red palette', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      expect(
        GtNetworkImages.avatarSavingsCat.adapt(context),
        GtNetworkImages.avatarSavingsCat.replaceFirst(
          '/illustrations/',
          '/illustrations/red/',
        ),
      );
    });

    testWidgets('stay cyan under other palettes', (tester) async {
      final context = await _contextFor(tester, PersonalLightPalette());
      expect(
        GtNetworkImages.avatarSavingsCat.adapt(context),
        GtNetworkImages.avatarSavingsCat,
      );
    });

    testWidgets('adapting twice changes nothing more', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      final red = GtNetworkImages.avatarFamilyCat.adapt(context);
      expect(red.adapt(context), red);
    });

    testWidgets('leave photos and other images alone', (tester) async {
      final context = await _contextFor(tester, SterlingProLightPalette());
      expect(
        GtNetworkImages.avatarPhoto1.adapt(context),
        GtNetworkImages.avatarPhoto1,
      );
      expect(
        GtNetworkImages.avatar3d1.adapt(context),
        GtNetworkImages.avatar3d1,
      );
      expect(GtNetworkImages.savings.adapt(context), GtNetworkImages.savings);
    });
  });

  group('GtImageTemplatePicker', () {
    // A phone's width, tall enough to hold every tile without scrolling.
    setUp(() {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.physicalSize = const Size(375, 1400);
      view.devicePixelRatio = 1;
    });
    tearDown(() {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    testWidgets('opens on Photos, led by the Upload tile', (tester) async {
      var uploads = 0;
      await tester.pumpWidget(
        _app(
          kPersonalTheme,
          GtImageTemplatePicker(onSelect: (_) {}, onUpload: () => uploads++),
        ),
      );
      await tester.pump();

      final photos = GtNetworkImages.photoTemplates.map((it) => it.value);
      expect(_tileUrls(tester), photos.toList());

      await tester.tap(find.text('upload'.ctr()));
      expect(uploads, 1);
    });

    testWidgets('hides the Upload tile without onUpload', (tester) async {
      await tester.pumpWidget(
        _app(kPersonalTheme, GtImageTemplatePicker(onSelect: (_) {})),
      );
      await tester.pump();

      expect(find.text('upload'.ctr()), findsNothing);
      expect(_tileUrls(tester), hasLength(12));
    });

    testWidgets('passes the tapped photo to onSelect', (tester) async {
      AppImageData? picked;
      await tester.pumpWidget(
        _app(
          kPersonalTheme,
          GtImageTemplatePicker(onSelect: (image) => picked = image),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(GtImage).at(2));
      expect(picked?.imageData, GtNetworkImages.avatarPhoto3);
    });

    testWidgets('the tabs split the row and paint across it', (tester) async {
      await tester.pumpWidget(
        _app(kPersonalTheme, GtImageTemplatePicker(onSelect: (_) {})),
      );
      // The image shimmer never settles, so give the indicator its
      // post-frame measure and its glide by hand.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // The painted pill, not the Expanded slot it sits in.
      Rect painted(String label) => tester.getRect(
        find.descendant(
          of: _tab(label),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final photos = painted('photos'.ctr());
      final illustrations = painted('illustrations'.ctr());
      final picker = tester.getRect(find.byType(GtImageTemplatePicker));
      final indicator = tester.getRect(
        find.byKey(const Key('gt_selection_tab_indicator')),
      );

      expect(photos.width, moreOrLessEquals(illustrations.width));
      expect(photos.left, moreOrLessEquals(picker.left));
      expect(illustrations.right, moreOrLessEquals(picker.right));
      expect(indicator.width, moreOrLessEquals(photos.width));
      expect(indicator.left, moreOrLessEquals(photos.left));
    });

    testWidgets('three tiles fit each row', (tester) async {
      await tester.pumpWidget(
        _app(kPersonalTheme, GtImageTemplatePicker(onSelect: (_) {})),
      );
      await tester.pump();

      final tops = tester
          .widgetList<GtImage>(find.byType(GtImage))
          .take(6)
          .map((image) => tester.getTopLeft(find.byWidget(image)).dy)
          .toList();
      expect(tops.take(3).toSet(), hasLength(1));
      expect(tops.skip(3).toSet(), hasLength(1));
      expect(tops[3], greaterThan(tops[0]));
    });

    testWidgets('Illustrations shows the red set under Sterling Pro', (
      tester,
    ) async {
      AppImageData? picked;
      await tester.pumpWidget(
        _app(kProTheme, GtImageTemplatePicker(onSelect: (it) => picked = it)),
      );
      await tester.pump();

      await tester.tap(_tab('illustrations'.ctr()));
      await tester.pump();

      final urls = _tileUrls(tester);
      expect(urls, hasLength(15));
      expect(urls.every((url) => url.contains('/illustrations/red/')), isTrue);

      await tester.tap(find.byType(GtImage).first);
      expect(picked?.imageData, urls.first);
    });

    testWidgets('Illustrations keeps the cyan set under Personal', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(kPersonalTheme, GtImageTemplatePicker(onSelect: (_) {})),
      );
      await tester.pump();

      await tester.tap(_tab('illustrations'.ctr()));
      await tester.pump();

      final illustrations = GtNetworkImages.illustrationTemplates;
      expect(_tileUrls(tester), illustrations.map((it) => it.value).toList());
    });

    testWidgets('closes a sheet with the tapped template', (tester) async {
      AppImageData? picked;
      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            theme: kPersonalTheme.materialLight,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    picked = await GtBottomSheet<AppImageData>(
                      context: context,
                      isScrollable: true,
                      modalWidget: SingleChildScrollView(
                        child: Builder(
                          builder: (sheet) => GtImageTemplatePicker(
                            onSelect: (it) => Navigator.of(sheet).pop(it),
                          ),
                        ),
                      ),
                    ).present(context);
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GtImageTemplatePicker), findsOneWidget);

      await tester.tap(find.byType(GtImage).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(picked?.imageData, GtNetworkImages.avatarPhoto1);
      expect(find.byType(GtImageTemplatePicker), findsNothing);
    });
  });

  testWidgets('a tab bar can switch to filling and back', (tester) async {
    final controller = GtTabController<String>();
    addTearDown(controller.dispose);
    const tabs = [
      GtTabData(value: 'a', label: 'A'),
      GtTabData(value: 'b', label: 'B'),
    ];
    Widget bar({required bool fill, required bool alt}) => GtThemeProvider(
      theme: kPersonalTheme,
      child: MaterialApp(
        theme: kPersonalTheme.materialLight,
        home: Scaffold(
          body: GtTabbar<String>(
            controller: controller,
            tabs: tabs,
            fill: fill,
            useAlternateStyle: alt,
          ),
        ),
      ),
    );

    for (final alt in [false, true]) {
      for (final fill in [false, true, false]) {
        await tester.pumpWidget(bar(fill: fill, alt: alt));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });
}
