import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';

/// A setting state that holds both the selected [GtTheme] and [ThemeMode].
class GtThemeSetting {
  const GtThemeSetting({required this.theme, required this.mode});

  final GtTheme theme;
  final ThemeMode mode;
}

/// A custom Addon that exposes two configuration fields in Widgetbook:
/// - Theme: Dropdown to pick the active GtTheme (e.g., Personal, Kids).
/// - Mode: Dropdown to pick the active ThemeMode (Light, Dark).
class GtThemeAddon extends WidgetbookAddon<GtThemeSetting> {
  GtThemeAddon({
    required this.themes,
    this.initialTheme,
    this.initialMode = ThemeMode.light,
  }) : super(name: 'Theme');

  final List<GtTheme> themes;
  final GtTheme? initialTheme;
  final ThemeMode initialMode;

  @override
  List<Field> get fields => [
    ObjectDropdownField<GtTheme>(
      name: 'theme',
      values: themes,
      initialValue: initialTheme ?? themes.first,
      labelBuilder: (theme) => theme.name,
    ),
    ObjectDropdownField<ThemeMode>(
      name: 'mode',
      // Only exposing light & dark for explicit design system review
      values: const [ThemeMode.light, ThemeMode.dark],
      initialValue: initialMode,
      labelBuilder: (mode) =>
          mode.name[0].toUpperCase() + mode.name.substring(1),
    ),
  ];

  @override
  GtThemeSetting valueFromQueryGroup(Map<String, String> group) {
    return GtThemeSetting(
      theme: valueOf<GtTheme>('theme', group) ?? initialTheme ?? themes.first,
      mode: valueOf<ThemeMode>('mode', group) ?? initialMode,
    );
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    GtThemeSetting setting,
  ) {
    return GtThemeProvider(
      theme: setting.theme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: setting.theme.materialLight,
            darkTheme: setting.theme.materialDark,
            themeMode: setting.mode,
            debugShowCheckedModeBanner: false,
            navigatorKey: GtRouter.navigatorKey,
            home: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1)),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
