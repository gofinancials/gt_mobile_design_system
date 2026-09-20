import 'package:flutter/widgets.dart';
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
  });

  group('kAllThemes', () {
    test('cannot be modified', () {
      expect(() => kAllThemes.add(kKidsTheme), throwsUnsupportedError);
      expect(() => kAllThemes[0] = kKidsTheme, throwsUnsupportedError);
      expect(kAllThemes.first, same(kPersonalTheme));
    });
  });
}
