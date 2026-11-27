import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  group('GtTheme.systemOverlayStyle', () {
    test('the status bar is transparent with icons that contrast with the '
        'screen in each mode', () {
      final light = kFlexTheme.systemOverlayStyle(Brightness.light);
      expect(light.statusBarColor, Colors.transparent);
      // Dark icons on the white screen: Android names the icons, iOS the
      // background.
      expect(light.statusBarIconBrightness, Brightness.dark);
      expect(light.statusBarBrightness, Brightness.light);
      expect(light.systemNavigationBarColor, kFlexTheme.lightPalette.bg.white);
      expect(light.systemNavigationBarIconBrightness, Brightness.dark);

      final dark = kFlexTheme.systemOverlayStyle(Brightness.dark);
      expect(dark.statusBarColor, Colors.transparent);
      expect(dark.statusBarIconBrightness, Brightness.light);
      expect(dark.statusBarBrightness, Brightness.dark);
      expect(dark.systemNavigationBarColor, kFlexTheme.darkPalette.bg.white);
      expect(dark.systemNavigationBarIconBrightness, Brightness.light);
    });

    test('each ThemeData carries its own style on its app bar theme', () {
      expect(
        kFlexTheme.materialLight.appBarTheme.systemOverlayStyle,
        kFlexTheme.systemOverlayStyle(Brightness.light),
      );
      expect(
        kFlexTheme.materialDark.appBarTheme.systemOverlayStyle,
        kFlexTheme.systemOverlayStyle(Brightness.dark),
      );
    });
  });

  testWidgets('reading the Material themes sets no global style', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setSystemUIOverlayStyle') {
          calls.add(call);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    kProTheme.materialDark;
    kFlexTheme.materialLight;
    await tester.pump();

    expect(calls, isEmpty);
  });

  /// Mounts an app in [themeMode] with light and dark themes of the Personal
  /// brand around [home], and returns the bar style applied after a frame.
  ///
  /// With [annotateRoot], the app annotates its root from its theme, as the
  /// [GtTheme.systemOverlayStyle] doc comment shows.
  Future<SystemUiOverlayStyle?> barsFor(
    WidgetTester tester,
    Widget home, {
    ThemeMode themeMode = .light,
    bool annotateRoot = false,
  }) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          darkTheme: kPersonalTheme.materialDark,
          themeMode: themeMode,
          builder: annotateRoot
              ? (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
                  value: kPersonalTheme.systemOverlayStyle(
                    Theme.brightnessOf(context),
                  ),
                  child: child!,
                )
              : null,
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return SystemChrome.latestStyle;
  }

  testWidgets('a GtTitleAppBar screen under an annotated root has dark status '
      'bar icons in light mode', (tester) async {
    final style = await barsFor(
      tester,
      const Scaffold(appBar: GtTitleAppBar(title: 'Statements')),
      annotateRoot: true,
    );

    expect(style?.statusBarColor, Colors.transparent);
    expect(style?.statusBarIconBrightness, Brightness.dark);
    expect(style?.statusBarBrightness, Brightness.light);
    expect(
      style?.systemNavigationBarColor,
      kPersonalTheme.lightPalette.bg.white,
    );
  });

  testWidgets('and light status bar icons in dark mode', (tester) async {
    final style = await barsFor(
      tester,
      const Scaffold(appBar: GtTitleAppBar(title: 'Statements')),
      annotateRoot: true,
      themeMode: .dark,
    );

    expect(style?.statusBarIconBrightness, Brightness.light);
    expect(style?.statusBarBrightness, Brightness.dark);
    expect(
      style?.systemNavigationBarColor,
      kPersonalTheme.darkPalette.bg.white,
    );
  });

  testWidgets('a Material app bar follows the mode on screen, though the dark '
      'theme is read too', (tester) async {
    final light = await barsFor(
      tester,
      Scaffold(appBar: AppBar(title: const Text('Stash'))),
    );
    expect(light?.statusBarIconBrightness, Brightness.dark);

    final dark = await barsFor(
      tester,
      Scaffold(appBar: AppBar(title: const Text('Stash'))),
      themeMode: .dark,
    );
    expect(dark?.statusBarIconBrightness, Brightness.light);
  });

  testWidgets('a scoped screen gets its own brand\'s bars', (tester) async {
    final style = await barsFor(
      tester,
      GtThemedScope(
        theme: kFlexTheme,
        child: const Scaffold(body: SizedBox.expand()),
      ),
      annotateRoot: true,
    );

    expect(style?.statusBarIconBrightness, Brightness.dark);
    expect(style?.systemNavigationBarColor, kFlexTheme.lightPalette.bg.white);
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find
          .descendant(
            of: find.byType(GtThemedScope),
            matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
          )
          .first,
    );
    expect(region.value, kFlexTheme.systemOverlayStyle(Brightness.light));
  });
}
