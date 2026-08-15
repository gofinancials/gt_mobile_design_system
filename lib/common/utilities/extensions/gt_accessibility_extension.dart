import 'package:flutter/material.dart';

/// An extension on [BuildContext] exposing the operating system's accessibility
/// settings to design-system widgets.
///
/// These settings are user choices made outside the app, and honouring them is
/// what separates a component that merely has semantics from one that is
/// genuinely usable. None of them were read anywhere in the design system
/// before this extension existed.
extension GtAccessibilityContextExtension on BuildContext {
  /// Whether the user has asked the platform to reduce or disable animation.
  ///
  /// Set by "Reduce Motion" on iOS and "Remove animations" on Android. Users
  /// enable it for vestibular disorders and motion sensitivity, where sliding
  /// and scaling transitions can cause real nausea.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Whether the user has asked for heavier font weights.
  ///
  /// Set by "Bold Text" on iOS and "Bold font" on Android.
  bool get prefersBoldText => MediaQuery.boldTextOf(this);

  /// Whether the user has asked for increased contrast.
  ///
  /// Set by "Increase Contrast" on iOS. Not reported by Android.
  bool get prefersHighContrast => MediaQuery.highContrastOf(this);

  /// Whether a screen reader or similar assistive technology is driving the UI.
  ///
  /// Use this to swap gesture-only affordances for explicit controls, not to
  /// hide or simplify content.
  bool get isAccessibleNavigation => MediaQuery.accessibleNavigationOf(this);

  /// Collapses [duration] to zero when the user has asked to reduce motion.
  ///
  /// Prefer this over reading [reduceMotion] directly so that every animated
  /// widget in the design system responds to the setting the same way.
  ///
  /// ```dart
  /// AnimatedOpacity(
  ///   duration: context.motionDuration(500.milliseconds),
  ///   opacity: opacity,
  ///   child: child,
  /// )
  /// ```
  Duration motionDuration(Duration duration) {
    return reduceMotion ? .zero : duration;
  }

  /// Returns [reduced] instead of [standard] when the user has asked to reduce
  /// motion.
  ///
  /// Use this where an animation should change character rather than vanish —
  /// swapping a slide for a cross-fade, for instance, since fades are generally
  /// tolerated by users who cannot tolerate movement.
  T motion<T>({required T standard, required T reduced}) {
    return reduceMotion ? reduced : standard;
  }
}
