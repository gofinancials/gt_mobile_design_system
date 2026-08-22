import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class _DelayedStorageService extends AppMockStorageService {
  final Completer<void> writeCompleter = Completer<void>();

  @override
  Future<void> setItem(String key, String? data) async {
    await writeCompleter.future;
    await super.setItem(key, data);
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
}
