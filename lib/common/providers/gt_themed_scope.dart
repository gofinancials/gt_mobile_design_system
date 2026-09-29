import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Brands a part of the widget tree with [theme].
///
/// A surface is styled from two places: its palette comes from the Material
/// [Theme] and everything else — fonts, radii, grid, text styles, input
/// styles — from the [GtThemeProvider]. Installing only one of them renders a
/// half-branded surface, so this widget installs both from a single [GtTheme]
/// and picks the [ThemeData] that matches the resolved brightness.
///
/// Use it to brand a route or a subtree in an app that is otherwise in a
/// different brand, such as an onboarding flow for a product the customer
/// does not hold an account with yet:
///
/// ```dart
/// GtThemedScope(
///   theme: kFlexTheme,
///   child: const FlexOnboardingScreen(),
/// )
/// ```
///
/// Sheets and dialogs opened from inside the scope keep the brand, because
/// both halves are captured into the overlay by [InheritedTheme.capture].
/// A route pushed from inside it does not: it is built from the navigator's
/// context, so it needs its own scope.
///
/// Note that [GtTheme.materialLight] and [GtTheme.materialDark] call
/// [SystemChrome.setSystemUIOverlayStyle] as a side effect of being read. This
/// widget only reads them when [theme] or the resolved brightness changes, but
/// the style it sets is global and sticky: it stays on the scoped brand after
/// the scope is gone. A screen that cares about the status bar outside the
/// scope sets it back through `AppBar.systemOverlayStyle` or an
/// [AnnotatedRegion].
class GtThemedScope extends StatefulWidget {
  /// Creates a scope that brands [child] with [theme].
  const GtThemedScope({
    required this.theme,
    required this.child,
    this.brightness,
    super.key,
  });

  /// The design system theme to brand [child] with.
  final GtTheme theme;

  /// The brightness to resolve [theme] against.
  ///
  /// Defaults to the brightness of the ambient [Theme], which is the mode the
  /// app has already resolved.
  ///
  /// An explicit brightness is not reflected by `context.isInDarkMode`, which
  /// reads the app's [GtThemeState] whenever the app pins a mode rather than
  /// following the system. Widgets that pick colours off that getter stay on
  /// the app's mode, so leave this null unless the scope has to be fixed to
  /// one brightness.
  final Brightness? brightness;

  /// The widget subtree rendered in [theme].
  final Widget child;

  @override
  State<GtThemedScope> createState() => _GtThemedScopeState();
}

class _GtThemedScopeState extends State<GtThemedScope> {
  /// The theme and brightness [_data] was built from, kept so the Material
  /// theme is only rebuilt when one of them changes.
  GtTheme? _source;
  Brightness? _sourceBrightness;

  /// The Material theme installed above [GtThemedScope.child].
  late ThemeData _data;

  @override
  Widget build(BuildContext context) {
    final brightness = widget.brightness ?? Theme.brightnessOf(context);
    if (widget.theme != _source || brightness != _sourceBrightness) {
      _source = widget.theme;
      _sourceBrightness = brightness;
      _data = switch (brightness) {
        .dark => widget.theme.materialDark,
        .light => widget.theme.materialLight,
      };
    }

    return Theme(
      data: _data,
      child: GtThemeProvider(theme: widget.theme, child: widget.child),
    );
  }
}
