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
///
/// Only the theme name is persisted, so a stored name is resolved back to a theme
/// from the list given as `themes`. An app that subclasses [GtTheme] passes its own
/// instances there so a restored theme keeps its overrides.
class GtThemeState extends StateModel {
  /// The storage service that persists the theme mode and theme name.
  final AppStorageService _service;

  /// The themes a stored theme name is resolved against.
  ///
  /// Copied on construction so later changes to the caller's list have no effect.
  final List<GtTheme> _themes;

  /// The active theme and mode, replaced whenever either one changes.
  late GtThemeSetting _themeSetting;

  /// Creates a [GtThemeState] that starts on [initialTheme] and then restores the
  /// preferences persisted in the storage service.
  ///
  /// A persisted theme name is resolved against [themes], which defaults to
  /// [kAllThemes]. When several themes share a name, the first one wins.
  /// [initialTheme] must be one of [themes], otherwise a persisted name could
  /// never resolve back to it.
  GtThemeState(this._service, GtTheme initialTheme, {List<GtTheme>? themes})
    : _themes = List.unmodifiable(themes ?? kAllThemes) {
    assert(
      _themes.contains(initialTheme),
      'initialTheme "${initialTheme.name}" is not in themes. Pass the same '
      'instances GtThemeState resolves stored names against.',
    );
    _themeSetting = GtThemeSetting(theme: initialTheme, mode: .system);
    _seedSetting();
    _observeTheme();
  }

  /// The active theme and theme mode.
  GtThemeSetting get themeSetting => _themeSetting;

  /// Applies the persisted theme mode and theme, keeping the current value of
  /// either one that has nothing stored.
  Future<void> _seedSetting() async {
    final storedValues = await _getStoredValues();
    final mode = _resolveMode(storedValues[AppStorageKey.themeMode]);
    final theme = _resolveTheme(storedValues[AppStorageKey.themeName]);
    _updateSetting(mode: mode, theme: theme);
  }

  /// Replaces the active setting with [mode] and [theme], keeping the current
  /// value of whichever is null.
  ///
  /// Listeners are only notified when the resulting setting differs.
  void _updateSetting({ThemeMode? mode, GtTheme? theme}) {
    final newSetting = GtThemeSetting(
      mode: mode ?? _themeSetting.mode,
      theme: theme ?? _themeSetting.theme,
    );
    if (newSetting == _themeSetting) return;
    _themeSetting = newSetting;
    notifyListeners();
  }

  /// Watches the stored theme name and mode and applies each change.
  void _observeTheme() {
    _service.watchItem(AppStorageKey.themeName, (String? value) {
      _updateSetting(theme: _resolveTheme(value));
    });
    _service.watchItem(AppStorageKey.themeMode, (String? value) {
      _updateSetting(mode: _resolveMode(value));
    });
  }

  /// Resolves the stored [value] to a [ThemeMode], or the current mode when it
  /// matches none.
  ThemeMode _resolveMode(String? value) {
    final mode = ThemeMode.values.tryFirstWhere(
      (it) => it.name.equals(value ?? ''),
    );
    return mode ?? _themeSetting.mode;
  }

  /// Resolves the stored [value] to a theme in [_themes], or the current theme
  /// when its name matches none.
  GtTheme _resolveTheme(String? value) {
    final theme = _themes.tryFirstWhere((it) => it.name.equals(value ?? ''));
    return theme ?? _themeSetting.theme;
  }

  /// Reads the stored theme mode and theme name.
  Future<Map<String, String?>> _getStoredValues() async {
    return _service.getItems([
      AppStorageKey.themeMode,
      AppStorageKey.themeName,
    ]);
  }

  /// Applies [mode] immediately and persists it.
  Future<void> changeMode(ThemeMode mode) async {
    _updateSetting(mode: mode);
    await _service.setItem(AppStorageKey.themeMode, mode.name);
  }

  /// Applies [theme] immediately and persists its name.
  ///
  /// [theme] must be one of the themes this state resolves names against.
  /// Only the name is persisted, so an unlisted theme would be replaced by
  /// the listed one with that name as soon as the stored value changes.
  Future<void> switchTheme(GtTheme theme) async {
    assert(
      _themes.contains(theme),
      'Theme "${theme.name}" is not in themes. Pass the same instances '
      'GtThemeState resolves stored names against.',
    );
    _updateSetting(theme: theme);
    await _service.setItem(AppStorageKey.themeName, theme.name);
  }

  /// Whether the UI under [context] is rendered in dark mode.
  ///
  /// Follows the theme or platform brightness when the mode is
  /// [ThemeMode.system].
  bool isInDarkMode(BuildContext context) {
    final mode = _themeSetting.mode;
    if (mode != .system) return mode == .dark;

    final themeBrightness = Theme.maybeBrightnessOf(context);
    final platformBrightness = MediaQuery.maybePlatformBrightnessOf(context);

    return (themeBrightness ?? platformBrightness) == .dark;
  }

  /// Stops watching the stored preferences before disposing this state.
  @override
  void dispose() {
    _service.unWatchItems([AppStorageKey.themeMode, AppStorageKey.themeName]);
    super.dispose();
  }
}
