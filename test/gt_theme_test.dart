import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/app_theme.dart';

void main() {
  group('GtTheme equality', () {
    test('equals a theme of the same type with the same palettes and name', () {
      final copy = GtTheme(
        lightPalette: kKidsTheme.lightPalette,
        darkPalette: kKidsTheme.darkPalette,
        name: kKidsTheme.name,
      );

      expect(copy, kKidsTheme);
      expect(copy.hashCode, kKidsTheme.hashCode);
    });

    test('does not equal a subclass with the same palettes and name', () {
      final subclass = AppTheme(kKidsTheme);

      expect(subclass, isNot(kKidsTheme));
      expect(kKidsTheme, isNot(subclass));
    });

    test('equals another instance of the same subclass', () {
      expect(AppTheme(kKidsTheme), AppTheme(kKidsTheme));
    });

    test('does not equal a theme with a different name', () {
      expect(kKidsTheme, isNot(kPersonalTheme));
    });
  });

  group('GtThemeProvider', () {
    testWidgets('rebuilds dependents when the theme becomes a subclass', (
      tester,
    ) async {
      var builds = 0;
      final probe = Builder(
        builder: (context) {
          builds++;
          GtThemeProvider.of(context);
          return const SizedBox();
        },
      );

      await tester.pumpWidget(GtThemeProvider(theme: kKidsTheme, child: probe));
      await tester.pumpWidget(
        GtThemeProvider(theme: AppTheme(kKidsTheme), child: probe),
      );

      expect(builds, 2);
    });

    testWidgets('survives the capture into a root-navigator sheet', (
      tester,
    ) async {
      late BuildContext scopedContext;
      late BuildContext sheetContext;

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            theme: kPersonalTheme.materialLight,
            home: GtThemedScope(
              theme: kFlexTheme,
              child: Builder(
                builder: (context) {
                  scopedContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      showModalBottomSheet<void>(
        context: scopedContext,
        useRootNavigator: true,
        builder: (context) {
          sheetContext = context;
          return const SizedBox();
        },
      );
      await tester.pumpAndSettle();

      expect(GtThemeProvider.of(sheetContext), same(kFlexTheme));
      expect(
        Theme.of(sheetContext).extension<GtPalette>(),
        same(kFlexTheme.lightPalette),
      );
    });
  });

  group('GtThemedScope', () {
    testWidgets('installs the theme and its palette for the given brightness', (
      tester,
    ) async {
      late BuildContext scopedContext;

      await tester.pumpWidget(
        GtThemeProvider(
          theme: kPersonalTheme,
          child: MaterialApp(
            theme: kPersonalTheme.materialLight,
            home: GtThemedScope(
              theme: kFlexTheme,
              brightness: .dark,
              child: Builder(
                builder: (context) {
                  scopedContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(GtThemeProvider.of(scopedContext), same(kFlexTheme));
      expect(
        Theme.of(scopedContext).extension<GtPalette>(),
        same(kFlexTheme.darkPalette),
      );
    });

    testWidgets('follows the ambient brightness when none is given', (
      tester,
    ) async {
      late BuildContext scopedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: kPersonalTheme.materialLight,
          darkTheme: kPersonalTheme.materialDark,
          themeMode: .dark,
          home: GtThemedScope(
            theme: kFlexTheme,
            child: Builder(
              builder: (context) {
                scopedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(
        Theme.of(scopedContext).extension<GtPalette>(),
        same(kFlexTheme.darkPalette),
      );
    });

    testWidgets('keeps the same ThemeData across rebuilds', (tester) async {
      final contexts = <BuildContext>[];

      Widget build() => MaterialApp(
        theme: kPersonalTheme.materialLight,
        home: GtThemedScope(
          theme: kFlexTheme,
          child: Builder(
            builder: (context) {
              contexts.add(context);
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(build());
      final first = Theme.of(contexts.last);
      await tester.pumpWidget(build());

      expect(Theme.of(contexts.last), same(first));
    });
  });

  group('kAllThemes', () {
    test('cannot be modified', () {
      expect(() => kAllThemes.add(kKidsTheme), throwsUnsupportedError);
      expect(() => kAllThemes[0] = kKidsTheme, throwsUnsupportedError);
      expect(kAllThemes.first, same(kPersonalTheme));
    });
  });
}
