import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/test_app_config.dart';

void main() {
  setUpAll(registerTestAppConfig);

  group('GtTheme.systemOverlayStyle', () {
    test('colors the bars from the palette of the given brightness', () {
      final light = kFlexTheme.systemOverlayStyle(Brightness.light);
      expect(light.statusBarColor, kFlexTheme.lightPalette.primary.darker);
      expect(light.statusBarIconBrightness, Brightness.light);
      expect(light.systemNavigationBarColor, kFlexTheme.lightPalette.bg.white);
      expect(light.systemNavigationBarIconBrightness, Brightness.dark);

      final dark = kFlexTheme.systemOverlayStyle(Brightness.dark);
      expect(dark.statusBarColor, kFlexTheme.darkPalette.primary.darker);
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
  Future<SystemUiOverlayStyle?> barsFor(
    WidgetTester tester,
    Widget home, {
    ThemeMode themeMode = .light,
  }) async {
    await tester.pumpWidget(
      GtThemeProvider(
        theme: kPersonalTheme,
        child: MaterialApp(
          theme: kPersonalTheme.materialLight,
          darkTheme: kPersonalTheme.materialDark,
          themeMode: themeMode,
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return SystemChrome.latestStyle;
  }

  testWidgets('an app bar in light mode gets the light palette, though the '
      'dark theme is read too', (tester) async {
    final style = await barsFor(
      tester,
      Scaffold(appBar: AppBar(title: const Text('Stash'))),
    );

    expect(style?.statusBarColor, kPersonalTheme.lightPalette.primary.darker);
  });

  testWidgets('an app bar in dark mode gets the dark palette', (tester) async {
    final style = await barsFor(
      tester,
      Scaffold(appBar: AppBar(title: const Text('Stash'))),
      themeMode: .dark,
    );

    expect(style?.statusBarColor, kPersonalTheme.darkPalette.primary.darker);
  });

  testWidgets('a scoped screen without an app bar gets its own brand\'s bars', (
    tester,
  ) async {
    final style = await barsFor(
      tester,
      GtThemedScope(
        theme: kFlexTheme,
        child: const Scaffold(body: SizedBox.expand()),
      ),
    );

    final flex = kFlexTheme.systemOverlayStyle(Brightness.light);
    expect(style?.statusBarColor, flex.statusBarColor);
    expect(style?.systemNavigationBarColor, flex.systemNavigationBarColor);
    expect(
      style?.statusBarColor,
      isNot(kPersonalTheme.lightPalette.primary.darker),
    );
  });

  testWidgets('an app bar inside a scope takes the scoped brand', (
    tester,
  ) async {
    final style = await barsFor(
      tester,
      GtThemedScope(
        theme: kFlexTheme,
        child: Scaffold(appBar: AppBar(title: const Text('Stash'))),
      ),
    );

    expect(style?.statusBarColor, kFlexTheme.lightPalette.primary.darker);
  });
}
