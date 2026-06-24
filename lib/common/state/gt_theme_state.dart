import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Manages the application's global theme state, including the active design system theme
/// and brightness mode.
///
/// This state model interfaces with [AppStorageService] to persist user theme preferences
/// across sessions. It automatically listens for changes to the stored theme mode and
/// theme name, updating the active [GtThemeSetting] and notifying listeners to trigger
/// a UI rebuild.
///
/// Typical usage involves providing this state via a provider and accessing it to read
/// the current theme or invoke [changeMode] and [switchTheme] to update preferences.
class GtThemeState extends StateModel {
  final AppStorageService _service;
  late GtThemeSetting _themeSetting;

  GtThemeState(this._service, GtTheme initialTheme) {
    _themeSetting = GtThemeSetting(theme: initialTheme, mode: .system);
    _seedSetting();
    _observeTheme();
  }

  GtThemeSetting get themeSetting => _themeSetting;

  Future<void> _seedSetting() async {
    final storedValues = await _getStoredValues();
    final mode = _resolveMode(storedValues[AppStorageKey.themeMode]);
    final theme = _resolveTheme(storedValues[AppStorageKey.themeName]);
    _updateSetting(mode: mode, theme: theme);
  }

  void _updateSetting({ThemeMode? mode, GtTheme? theme}) {
    final newSetting = GtThemeSetting(
      mode: mode ?? _themeSetting.mode,
      theme: theme ?? _themeSetting.theme,
    );
    if (newSetting == _themeSetting) return;
    _themeSetting = newSetting;
    notifyListeners();
  }

  void _observeTheme() {
    _service.watchItem(AppStorageKey.themeName, (String? value) {
      _updateSetting(theme: _resolveTheme(value));
    });
    _service.watchItem(AppStorageKey.themeMode, (String? value) {
      _updateSetting(mode: _resolveMode(value));
    });
  }

  ThemeMode _resolveMode(String? value) {
    final mode = ThemeMode.values.tryFirstWhere(
      (it) => it.name.equals(value ?? ''),
    );
    return mode ?? _themeSetting.mode;
  }

  GtTheme _resolveTheme(String? value) {
    final theme = kAllThemes.tryFirstWhere((it) => it.name.equals(value ?? ''));
    return theme ?? _themeSetting.theme;
  }

  Future<Map<String, String?>> _getStoredValues() async {
    return _service.getItems([
      AppStorageKey.themeMode,
      AppStorageKey.themeName,
    ]);
  }

  Future<void> changeMode(ThemeMode mode) async {
    await _service.setItem(AppStorageKey.themeMode, mode.name);
  }

  Future<void> switchTheme(GtTheme theme) async {
    await _service.setItem(AppStorageKey.themeName, theme.name);
  }

  @override
  void dispose() {
    _service.unWatchItems([AppStorageKey.themeMode, AppStorageKey.themeName]);
    super.dispose();
  }
}
