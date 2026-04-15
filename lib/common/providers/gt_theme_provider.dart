import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An [InheritedWidget] that provides a [GtTheme] to its descendants.
///
/// This provider allows widgets deeper in the tree to access the current
/// design system theme without having to pass it down manually. It is a
/// core part of the dynamic theming system, enabling theme changes to
/// propagate efficiently throughout the application.
///
/// Use `GtThemeProvider.of(context)` to access the theme.
class GtThemeProvider extends InheritedWidget {
  /// The design system theme to provide to the widget tree.
  final GtTheme theme;

  /// Creates a theme provider that makes the given [theme] available to its
  /// descendants.
  const GtThemeProvider({required this.theme, required super.child, super.key});

  /// Retrieves the closest [GtTheme] instance from the widget tree.
  ///
  /// This method will assert in debug mode if no [GtThemeProvider] is found
  /// in the ancestry of the given [context]. In release mode, it will throw
  /// an exception.
  ///
  /// For a non-throwing version, see [maybeOf].
  static GtTheme of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<GtThemeProvider>();
    assert(
      provider != null,
      'No GtThemeProvider found in context. Make sure to wrap your widget tree with a GtThemeProvider.',
    );
    return provider!.theme;
  }

  /// Retrieves the closest [GtTheme] instance from the widget tree, if one exists.
  ///
  /// Returns `null` if no [GtThemeProvider] is found in the ancestry of the
  /// given [context]. This is useful for cases where the theme is optional.
  static GtTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GtThemeProvider>()?.theme;
  }

  @override
  bool updateShouldNotify(covariant GtThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
