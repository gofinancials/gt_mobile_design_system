import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A centralized styling class that provides access to the application's
/// standard shadow and elevation styles.
///
/// This class uses the provided [BuildContext] to resolve the theme-dependent
/// default shadow color as defined in the design system's palette.
class GtShadows {
  /// The [BuildContext] used to access the current theme and color palettes.
  final BuildContext context;

  /// Creates an instance of [GtShadows].
  ///
  /// Requires a [BuildContext] to accurately resolve context-dependent shadow colors.
  const GtShadows(this.context);

  Color get _shadow => context.palette.staticColors.shadow;

  /// Extra small shadow.
  ///
  /// Typically used for subtle depth on small components like badges, chips,
  /// or standard buttons.
  ///
  /// Accepts an optional [color] to override the default theme shadow color.
  List<BoxShadow> xs([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        offset: Offset(0, 4),
        blurRadius: 8,
        spreadRadius: -2,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        offset: Offset(0, -1),
        blurRadius: 1,
        spreadRadius: -0.5,
      ),
    ];
  }

  /// Small shadow.
  ///
  /// Typically used for cards, dropdown menus, or standard elevated components.
  ///
  /// Accepts an optional [color] to override the default theme shadow color.
  List<BoxShadow> sm([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.16),
        blurRadius: 3,
        spreadRadius: -1.5,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.08),
        blurRadius: 5,
        spreadRadius: -2.5,
        offset: Offset(0, 5),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.02),
        offset: Offset(0, 12),
        blurRadius: 6,
        spreadRadius: -6,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.01),
        offset: Offset(0, 16),
        blurRadius: 8,
        spreadRadius: -8,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.08),
        offset: Offset(0, -0.5),
        blurRadius: 0.5,
        spreadRadius: 0,
      ),
    ];
  }

  /// Medium shadow.
  ///
  /// Typically used for modals, dialogs, or prominent floating elements.
  ///
  /// Accepts an optional [color] to override the default theme shadow color.
  List<BoxShadow> md([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 48,
        spreadRadius: -24,
        offset: Offset(0, 48),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 24,
        spreadRadius: -12,
        offset: Offset(0, 24),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 12),
        blurRadius: 12,
        spreadRadius: -6,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 6),
        blurRadius: 6,
        spreadRadius: -3,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.02),
        offset: Offset(0, 3),
        blurRadius: 3,
        spreadRadius: -1.5,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 1),
        blurRadius: 1,
        spreadRadius: 0.5,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        offset: Offset(0, -1),
        blurRadius: 1,
        spreadRadius: -0.5,
      ),
    ];
  }

  /// Large shadow.
  ///
  /// Typically used for bottom sheets, drawers, or elements that need to sit
  /// at the highest elevation above the rest of the UI.
  ///
  /// Accepts an optional [color] to override the default theme shadow color.
  List<BoxShadow> lg([Color? color]) {
    return [
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        blurRadius: 96,
        spreadRadius: -32,
        offset: Offset(0, 96),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        blurRadius: 48,
        spreadRadius: -24,
        offset: Offset(0, 48),
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 24),
        blurRadius: 24,
        spreadRadius: -12,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 12),
        blurRadius: 12,
        spreadRadius: -6,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 6),
        blurRadius: 6,
        spreadRadius: -3,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.02),
        offset: Offset(0, 3),
        blurRadius: 3,
        spreadRadius: -1.5,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 1),
        blurRadius: 1,
        spreadRadius: 0.5,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.04),
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: (color ?? _shadow).setOpacity(.06),
        offset: Offset(0, -1),
        blurRadius: 1,
        spreadRadius: -0.5,
      ),
    ];
  }
}
