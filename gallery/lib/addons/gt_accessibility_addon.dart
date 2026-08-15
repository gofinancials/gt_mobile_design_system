import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// The operating-system accessibility settings a use case is rendered under.
class GtAccessibilitySetting {
  /// Whether the platform is reporting a request for heavier font weights.
  final bool boldText;

  /// Whether the platform is reporting a request for increased contrast.
  final bool highContrast;

  /// Whether the platform is reporting a request to reduce motion.
  final bool reduceMotion;

  /// Whether a screen reader is reported as driving the interface.
  final bool accessibleNavigation;

  /// Creates a [GtAccessibilitySetting].
  const GtAccessibilitySetting({
    this.boldText = false,
    this.highContrast = false,
    this.reduceMotion = false,
    this.accessibleNavigation = false,
  });
}

/// A Widgetbook addon that simulates the operating system's accessibility
/// settings.
///
/// These are user choices made outside the app, which means they are easy to
/// forget and almost never exercised during design review. Toggling them here
/// puts the failure in front of whoever is looking at the component, rather
/// than leaving it to be discovered by the people who rely on them.
///
/// Text scale is deliberately left to Widgetbook's own `TextScaleAddon` rather
/// than duplicated here.
///
/// Register this **after** the theme addon: addons nest in list order, so a
/// later addon sits closer to the use case and its [MediaQuery] wins.
class GtAccessibilityAddon extends WidgetbookAddon<GtAccessibilitySetting> {
  /// Creates a [GtAccessibilityAddon].
  GtAccessibilityAddon() : super(name: 'Accessibility');

  @override
  List<Field> get fields => [
    BooleanField(name: 'boldText', initialValue: false),
    BooleanField(name: 'highContrast', initialValue: false),
    BooleanField(name: 'reduceMotion', initialValue: false),
    BooleanField(name: 'screenReader', initialValue: false),
  ];

  @override
  GtAccessibilitySetting valueFromQueryGroup(Map<String, String> group) {
    return GtAccessibilitySetting(
      boldText: valueOf<bool>('boldText', group) ?? false,
      highContrast: valueOf<bool>('highContrast', group) ?? false,
      reduceMotion: valueOf<bool>('reduceMotion', group) ?? false,
      accessibleNavigation: valueOf<bool>('screenReader', group) ?? false,
    );
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    GtAccessibilitySetting setting,
  ) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            boldText: setting.boldText,
            highContrast: setting.highContrast,
            disableAnimations: setting.reduceMotion,
            accessibleNavigation: setting.accessibleNavigation,
          ),
          child: child,
        );
      },
    );
  }
}
