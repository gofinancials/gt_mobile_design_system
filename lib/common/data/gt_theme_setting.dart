import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A configuration class that encapsulates the current theme settings.
///
/// This state object holds both the selected design system [GtTheme] and the
/// application's [ThemeMode] (e.g., light, dark, or system). It is typically
/// used by the theme management system to maintain the active theme state.
class GtThemeSetting extends AppEquatable {
  /// Creates a [GtThemeSetting] with the given [theme] and [mode].
  const GtThemeSetting({required this.theme, required this.mode});

  /// The active design system theme.
  final GtTheme theme;

  /// The active theme mode (e.g., [ThemeMode.system], [ThemeMode.light], or [ThemeMode.dark]).
  final ThemeMode mode;

  @override
  List<Object?> get props => [theme, mode];
}
