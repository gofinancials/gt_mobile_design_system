import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

import 'helpers/app_theme.dart';

class _DelayedStorageService extends AppMockStorageService {
  final Completer<void> writeCompleter = Completer<void>();

  @override
  Future<void> setItem(String key, String? data) async {
    await writeCompleter.future;
    await super.setItem(key, data);
  }
}

class _WatchableStorageService extends AppMockStorageService {
  final _watchers = <String, void Function(String?)>{};

  @override
  void watchItem(String key, [void Function(String? value)? onChanged]) {
    if (onChanged != null) _watchers[key] = onChanged;
  }

  @override
  Future<void> setItem(String key, String? data) async {
    await super.setItem(key, data);
    _watchers[key]?.call(data);
  }
}

void main() {
  test('theme mode updates before persistence completes', () async {
    final storage = _DelayedStorageService();
    final state = GtThemeState(storage, kPersonalTheme);
    addTearDown(state.dispose);
    await Future<void>.delayed(Duration.zero);

    final persistence = state.changeMode(ThemeMode.dark);

    expect(state.themeSetting.mode, ThemeMode.dark);

    storage.writeCompleter.complete();
    await persistence;
    expect(await storage.getItem(AppStorageKey.themeMode), ThemeMode.dark.name);
  });

  group('theme restore', () {
    test('resolves a stored theme name from the supplied themes', () async {
      final storage = AppMockStorageService();
      await storage.setItem(AppStorageKey.themeName, kKidsTheme.name);
      final kids = AppTheme(kKidsTheme);
      final state = GtThemeState(
        storage,
        AppTheme(kPersonalTheme),
        themes: [AppTheme(kPersonalTheme), kids],
      );
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(state.themeSetting.theme, same(kids));
    });

    test('resolves a stored theme name from kAllThemes by default', () async {
      final storage = AppMockStorageService();
      await storage.setItem(AppStorageKey.themeName, kKidsTheme.name);
      final state = GtThemeState(storage, kPersonalTheme);
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(state.themeSetting.theme, same(kKidsTheme));
    });

    test('keeps the current theme when the stored name matches none', () async {
      final storage = AppMockStorageService();
      await storage.setItem(AppStorageKey.themeName, 'Unknown');
      final initial = AppTheme(kPersonalTheme);
      final state = GtThemeState(
        storage,
        initial,
        themes: [initial, AppTheme(kKidsTheme)],
      );
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(state.themeSetting.theme, same(initial));
    });

    test('keeps the first theme when several share a name', () async {
      final storage = AppMockStorageService();
      await storage.setItem(AppStorageKey.themeName, kKidsTheme.name);
      final first = AppTheme(kKidsTheme);
      final state = GtThemeState(
        storage,
        kPersonalTheme,
        themes: [kPersonalTheme, first, AppTheme(kKidsTheme)],
      );
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(state.themeSetting.theme, same(first));
    });
  });

  group('switchTheme', () {
    test('keeps a listed subclass and persists its name', () async {
      final storage = _WatchableStorageService();
      final kids = AppTheme(kKidsTheme);
      final state = GtThemeState(
        storage,
        AppTheme(kPersonalTheme),
        themes: [AppTheme(kPersonalTheme), kids],
      );
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      await state.switchTheme(kids);

      expect(state.themeSetting.theme, same(kids));
      expect(await storage.getItem(AppStorageKey.themeName), kKidsTheme.name);
    });

    test('asserts when the theme is not listed', () async {
      final storage = _WatchableStorageService();
      final state = GtThemeState(storage, kPersonalTheme);
      addTearDown(state.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(
        () => state.switchTheme(AppTheme(kKidsTheme)),
        throwsAssertionError,
      );
      expect(state.themeSetting.theme, same(kPersonalTheme));
    });
  });

  group('construction', () {
    test('asserts when the initial theme is not listed', () {
      expect(
        () => GtThemeState(
          AppMockStorageService(),
          kPersonalTheme,
          themes: [AppTheme(kPersonalTheme)],
        ),
        throwsAssertionError,
      );
    });

    test('ignores later changes to the supplied list', () async {
      final storage = AppMockStorageService();
      await storage.setItem(AppStorageKey.themeName, kKidsTheme.name);
      final kids = AppTheme(kKidsTheme);
      final themes = [kPersonalTheme, kids];
      final state = GtThemeState(storage, kPersonalTheme, themes: themes);
      addTearDown(state.dispose);
      themes[1] = kKidsTheme;
      await Future<void>.delayed(Duration.zero);

      expect(state.themeSetting.theme, same(kids));
    });
  });
}
