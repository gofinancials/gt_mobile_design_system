import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An [InheritedTheme] that provides a [GtTheme] to its descendants.
///
/// This provider allows widgets deeper in the tree to access the current
/// design system theme without having to pass it down manually. It is a
/// core part of the dynamic theming system, enabling theme changes to
/// propagate efficiently throughout the application.
///
/// It is an [InheritedTheme] rather than a plain [InheritedWidget] so that a
/// theme scoped to part of the tree reaches the routes built from another
/// part of it. `showModalBottomSheet` and `showDialog` carry the caller's
/// styling into the overlay with [InheritedTheme.capture], which only picks up
/// [InheritedTheme]s; a plain provider would be dropped there and the sheet
/// would fall back to the theme above the navigator, keeping the Material
/// palette but losing the fonts, radii, grid and input styles that resolve
/// through this provider.
///
/// Use `GtThemeProvider.of(context)` to access the theme, or [GtThemedScope]
/// to install this provider and its matching Material [Theme] together.
class GtThemeProvider extends InheritedTheme {
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

  /// Reinstalls this provider above [child] when the surrounding theme is
  /// captured into another part of the tree, such as a modal route built from
  /// the navigator's context.
  @override
  Widget wrap(BuildContext context, Widget child) {
    return GtThemeProvider(theme: theme, child: child);
  }

  @override
  bool updateShouldNotify(covariant GtThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
